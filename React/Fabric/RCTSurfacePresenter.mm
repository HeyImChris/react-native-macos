/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "RCTSurfacePresenter.h"

<<<<<<< HEAD
#import <cxxreact/MessageQueueThread.h>
#import <jsi/jsi.h>
#import <objc/runtime.h>
=======
>>>>>>> fb/0.62-stable
#import <mutex>

#import <React/RCTAssert.h>
#import <React/RCTComponentViewFactory.h>
#import <React/RCTComponentViewRegistry.h>
#import <React/RCTFabricSurface.h>
#import <React/RCTFollyConvert.h>
#import <React/RCTMountingManager.h>
#import <React/RCTMountingManagerDelegate.h>
#import <React/RCTScheduler.h>
#import <React/RCTSurfaceRegistry.h>
#import <React/RCTSurfaceView+Internal.h>
#import <React/RCTSurfaceView.h>
#import <React/RCTUtils.h>

#import <react/components/root/RootShadowNode.h>
#import <react/core/LayoutConstraints.h>
#import <react/core/LayoutContext.h>
#import <react/uimanager/ComponentDescriptorFactory.h>
#import <react/uimanager/SchedulerToolbox.h>
#import <react/utils/ContextContainer.h>
#import <react/utils/ManagedObjectWrapper.h>

#import "MainRunLoopEventBeat.h"
#import "RCTConversions.h"
#import "RuntimeEventBeat.h"

using namespace facebook::react;

@interface RCTSurfacePresenter () <RCTSchedulerDelegate, RCTMountingManagerDelegate>
@end

@implementation RCTSurfacePresenter {
  std::mutex _schedulerMutex;
<<<<<<< HEAD
  std::mutex _contextContainerMutex;
  RCTScheduler
      *_Nullable _scheduler; // Thread-safe. Mutation of the instance variable is protected by `_schedulerMutex`.
  RCTMountingManager *_mountingManager; // Thread-safe.
  RCTSurfaceRegistry *_surfaceRegistry; // Thread-safe.
  RCTBridge *_bridge; // Unsafe. We are moving away from Bridge.
  RCTBridge *_batchedBridge;
  std::shared_ptr<const ReactNativeConfig> _reactNativeConfig;
=======
  RCTScheduler
      *_Nullable _scheduler; // Thread-safe. Mutation of the instance variable is protected by `_schedulerMutex`.
  ContextContainer::Shared _contextContainer;
  RuntimeExecutor _runtimeExecutor;
  RCTMountingManager *_mountingManager; // Thread-safe.
  RCTSurfaceRegistry *_surfaceRegistry; // Thread-safe.
>>>>>>> fb/0.62-stable
  better::shared_mutex _observerListMutex;
  NSMutableArray<id<RCTSurfacePresenterObserver>> *_observers;
  RCTImageLoader *_imageLoader;
  RuntimeExecutor _runtimeExecutor;
}

<<<<<<< HEAD
- (instancetype)initWithBridge:(RCTBridge *)bridge
                        config:(std::shared_ptr<const ReactNativeConfig>)config
                   imageLoader:(RCTImageLoader *)imageLoader
               runtimeExecutor:(RuntimeExecutor)runtimeExecutor
{
  if (self = [super init]) {
    _imageLoader = imageLoader;
    _runtimeExecutor = runtimeExecutor;
    _bridge = bridge;
    _batchedBridge = [_bridge batchedBridge] ?: _bridge;
    [_batchedBridge setSurfacePresenter:self];
=======
- (instancetype)initWithContextContainer:(ContextContainer::Shared)contextContainer
                         runtimeExecutor:(RuntimeExecutor)runtimeExecutor
{
  if (self = [super init]) {
    assert(contextContainer && "RuntimeExecutor must be not null.");
>>>>>>> fb/0.62-stable

    _runtimeExecutor = runtimeExecutor;
    _contextContainer = contextContainer;

    _surfaceRegistry = [[RCTSurfaceRegistry alloc] init];
    _mountingManager = [[RCTMountingManager alloc] init];
    _mountingManager.delegate = self;

    _observers = [NSMutableArray array];

    _scheduler = [self _createScheduler];
  }

  return self;
}

- (RCTComponentViewFactory *)componentViewFactory
{
  return _mountingManager.componentViewRegistry.componentViewFactory;
}

- (ContextContainer::Shared)contextContainer
{
  std::lock_guard<std::mutex> lock(_schedulerMutex);
  return _contextContainer;
}

- (void)setContextContainer:(ContextContainer::Shared)contextContainer
{
  std::lock_guard<std::mutex> lock(_schedulerMutex);
  _contextContainer = contextContainer;
}

- (void)setRuntimeExecutor:(RuntimeExecutor)runtimeExecutor
{
  std::lock_guard<std::mutex> lock(_schedulerMutex);
  _runtimeExecutor = runtimeExecutor;
}

- (RuntimeExecutor)runtimeExecutor
{
  std::lock_guard<std::mutex> lock(_schedulerMutex);
  return _runtimeExecutor;
}

#pragma mark - Internal Surface-dedicated Interface

- (void)registerSurface:(RCTFabricSurface *)surface
{
  std::lock_guard<std::mutex> lock(_schedulerMutex);
  [_surfaceRegistry registerSurface:surface];
  if (_scheduler) {
    [self _startSurface:surface];
  }
}

- (void)unregisterSurface:(RCTFabricSurface *)surface
{
  std::lock_guard<std::mutex> lock(_schedulerMutex);
  if (_scheduler) {
    [self _stopSurface:surface];
  }
  [_surfaceRegistry unregisterSurface:surface];
}

- (void)setProps:(NSDictionary *)props surface:(RCTFabricSurface *)surface
{
  std::lock_guard<std::mutex> lock(_schedulerMutex);
  // This implementation is suboptimal indeed but still better than nothing for now.
  [self _stopSurface:surface];
  [self _startSurface:surface];
}

- (RCTFabricSurface *)surfaceForRootTag:(ReactTag)rootTag
{
  return [_surfaceRegistry surfaceForRootTag:rootTag];
}

- (CGSize)sizeThatFitsMinimumSize:(CGSize)minimumSize
                      maximumSize:(CGSize)maximumSize
                          surface:(RCTFabricSurface *)surface
{
<<<<<<< HEAD
  LayoutContext layoutContext = {.pointScaleFactor = RCTScreenScale()};

  LayoutConstraints layoutConstraints = {.minimumSize = RCTSizeFromCGSize(minimumSize),
                                         .maximumSize = RCTSizeFromCGSize(maximumSize)};

  return [self._scheduler measureSurfaceWithLayoutConstraints:layoutConstraints
                                                layoutContext:layoutContext
                                                    surfaceId:surface.rootTag];
=======
  std::lock_guard<std::mutex> lock(_schedulerMutex);
  LayoutContext layoutContext = {.pointScaleFactor = RCTScreenScale()};
  LayoutConstraints layoutConstraints = {.minimumSize = RCTSizeFromCGSize(minimumSize),
                                         .maximumSize = RCTSizeFromCGSize(maximumSize)};
  return [_scheduler measureSurfaceWithLayoutConstraints:layoutConstraints
                                           layoutContext:layoutContext
                                               surfaceId:surface.rootTag];
>>>>>>> fb/0.62-stable
}

- (void)setMinimumSize:(CGSize)minimumSize maximumSize:(CGSize)maximumSize surface:(RCTFabricSurface *)surface
{
<<<<<<< HEAD
  LayoutContext layoutContext = {.pointScaleFactor = RCTScreenScale()};

  LayoutConstraints layoutConstraints = {.minimumSize = RCTSizeFromCGSize(minimumSize),
                                         .maximumSize = RCTSizeFromCGSize(maximumSize)};

  [self._scheduler constraintSurfaceLayoutWithLayoutConstraints:layoutConstraints
                                                  layoutContext:layoutContext
                                                      surfaceId:surface.rootTag];
=======
  std::lock_guard<std::mutex> lock(_schedulerMutex);
  LayoutContext layoutContext = {.pointScaleFactor = RCTScreenScale()};
  LayoutConstraints layoutConstraints = {.minimumSize = RCTSizeFromCGSize(minimumSize),
                                         .maximumSize = RCTSizeFromCGSize(maximumSize)};
  [_scheduler constraintSurfaceLayoutWithLayoutConstraints:layoutConstraints
                                             layoutContext:layoutContext
                                                 surfaceId:surface.rootTag];
>>>>>>> fb/0.62-stable
}

- (BOOL)synchronouslyUpdateViewOnUIThread:(NSNumber *)reactTag props:(NSDictionary *)props
{
  std::lock_guard<std::mutex> lock(_schedulerMutex);
  ReactTag tag = [reactTag integerValue];
  UIView<RCTComponentViewProtocol> *componentView =
      [_mountingManager.componentViewRegistry findComponentViewWithTag:tag];
  if (componentView == nil) {
    return NO; // This view probably isn't managed by Fabric
  }
  ComponentHandle handle = [[componentView class] componentDescriptorProvider].handle;
  auto *componentDescriptor = [_scheduler findComponentDescriptorByHandle_DO_NOT_USE_THIS_IS_BROKEN:handle];

  if (!componentDescriptor) {
    return YES;
  }

  [_mountingManager synchronouslyUpdateViewOnUIThread:tag changedProps:props componentDescriptor:*componentDescriptor];
  return YES;
}

- (BOOL)suspend
{
  std::lock_guard<std::mutex> lock(_schedulerMutex);

  if (!_scheduler) {
    return NO;
  }

<<<<<<< HEAD
  auto componentRegistryFactory = [factory = wrapManagedObject(self.componentViewFactory)](
                                      EventDispatcher::Shared const &eventDispatcher,
                                      ContextContainer::Shared const &contextContainer) {
    return [(RCTComponentViewFactory *)unwrapManagedObject(factory)
        createComponentDescriptorRegistryWithParameters:{eventDispatcher, contextContainer}];
  };

  auto runtimeExecutor = [self getRuntimeExecutor];

  auto toolbox = SchedulerToolbox{};
  toolbox.contextContainer = self.contextContainer;
  toolbox.componentRegistryFactory = componentRegistryFactory;
  toolbox.runtimeExecutor = runtimeExecutor;

  toolbox.synchronousEventBeatFactory = [runtimeExecutor]() {
    return std::make_unique<MainRunLoopEventBeat>(runtimeExecutor);
  };

  toolbox.asynchronousEventBeatFactory = [runtimeExecutor]() {
    return std::make_unique<RuntimeEventBeat>(runtimeExecutor);
  };

  _scheduler = [[RCTScheduler alloc] initWithToolbox:toolbox];
  _scheduler.delegate = self;
=======
  [self _stopAllSurfaces];
  _scheduler = nil;
>>>>>>> fb/0.62-stable

  return YES;
}

<<<<<<< HEAD
@synthesize contextContainer = _contextContainer;

- (RuntimeExecutor)getRuntimeExecutor
{
  if (_runtimeExecutor) {
    return _runtimeExecutor;
  }

  auto messageQueueThread = _batchedBridge.jsMessageThread;
  if (messageQueueThread) {
    // Make sure initializeBridge completed
    messageQueueThread->runOnQueueSync([] {});
  }
=======
- (BOOL)resume
{
  std::lock_guard<std::mutex> lock(_schedulerMutex);

  if (_scheduler) {
    return NO;
  }

  _scheduler = [self _createScheduler];
  [self _startAllSurfaces];

  return YES;
}
>>>>>>> fb/0.62-stable

#pragma mark - Private

- (RCTScheduler *)_createScheduler
{
  auto componentRegistryFactory = [factory = wrapManagedObject(self.componentViewFactory)](
                                      EventDispatcher::Weak const &eventDispatcher,
                                      ContextContainer::Shared const &contextContainer) {
    return [(RCTComponentViewFactory *)unwrapManagedObject(factory)
        createComponentDescriptorRegistryWithParameters:{eventDispatcher, contextContainer}];
  };

<<<<<<< HEAD
  return runtimeExecutor;
}

- (ContextContainer::Shared)contextContainer
{
  std::lock_guard<std::mutex> lock(_contextContainerMutex);

  if (_contextContainer) {
    return _contextContainer;
  }

  _contextContainer = std::make_shared<ContextContainer>();
  // Please do not add stuff here; `SurfacePresenter` must not alter `ContextContainer`.
  // Those two pieces eventually should be moved out there:
  // * `RCTImageLoader` should be moved to `RCTImageComponentView`.
  // * `ReactNativeConfig` should be set by outside product code.
  _contextContainer->insert("ReactNativeConfig", _reactNativeConfig);
  // TODO T47869586 petetheheat: Delete else case when TM rollout 100%
  if (_imageLoader) {
    _contextContainer->insert("RCTImageLoader", wrapManagedObject(_imageLoader));
  } else {
    _contextContainer->insert("RCTImageLoader", wrapManagedObject([_bridge moduleForClass:[RCTImageLoader class]]));
  }

  return _contextContainer;
=======
  auto runtimeExecutor = _runtimeExecutor;

  auto toolbox = SchedulerToolbox{};
  toolbox.contextContainer = _contextContainer;
  toolbox.componentRegistryFactory = componentRegistryFactory;
  toolbox.runtimeExecutor = runtimeExecutor;

  toolbox.synchronousEventBeatFactory = [runtimeExecutor](EventBeat::SharedOwnerBox const &ownerBox) {
    return std::make_unique<MainRunLoopEventBeat>(ownerBox, runtimeExecutor);
  };

  toolbox.asynchronousEventBeatFactory = [runtimeExecutor](EventBeat::SharedOwnerBox const &ownerBox) {
    return std::make_unique<RuntimeEventBeat>(ownerBox, runtimeExecutor);
  };

  RCTScheduler *scheduler = [[RCTScheduler alloc] initWithToolbox:toolbox];
  scheduler.delegate = self;

  return scheduler;
>>>>>>> fb/0.62-stable
}

- (void)_startSurface:(RCTFabricSurface *)surface
{
  RCTMountingManager *mountingManager = _mountingManager;
  RCTExecuteOnMainQueue(^{
    [mountingManager.componentViewRegistry dequeueComponentViewWithComponentHandle:RootShadowNode::Handle()
                                                                               tag:surface.rootTag];
  });

  LayoutContext layoutContext = {.pointScaleFactor = RCTScreenScale()};

  LayoutConstraints layoutConstraints = {.minimumSize = RCTSizeFromCGSize(surface.minimumSize),
                                         .maximumSize = RCTSizeFromCGSize(surface.maximumSize)};

  [_scheduler startSurfaceWithSurfaceId:surface.rootTag
                             moduleName:surface.moduleName
                           initialProps:surface.properties
                      layoutConstraints:layoutConstraints
                          layoutContext:layoutContext];
}

- (void)_stopSurface:(RCTFabricSurface *)surface
{
  [_scheduler stopSurfaceWithSurfaceId:surface.rootTag];

  RCTMountingManager *mountingManager = _mountingManager;
  RCTExecuteOnMainQueue(^{
    RCTComponentViewDescriptor rootViewDescriptor =
        [mountingManager.componentViewRegistry componentViewDescriptorWithTag:surface.rootTag];
    [mountingManager.componentViewRegistry enqueueComponentViewWithComponentHandle:RootShadowNode::Handle()
                                                                               tag:surface.rootTag
                                                           componentViewDescriptor:rootViewDescriptor];
  });

  [surface _unsetStage:(RCTSurfaceStagePrepared | RCTSurfaceStageMounted)];
}

- (void)_startAllSurfaces
{
  [_surfaceRegistry enumerateWithBlock:^(NSEnumerator<RCTFabricSurface *> *enumerator) {
    for (RCTFabricSurface *surface in enumerator) {
      [self _startSurface:surface];
    }
  }];
}

- (void)_stopAllSurfaces
{
  [_surfaceRegistry enumerateWithBlock:^(NSEnumerator<RCTFabricSurface *> *enumerator) {
    for (RCTFabricSurface *surface in enumerator) {
      [self _stopSurface:surface];
    }
  }];
}

#pragma mark - RCTSchedulerDelegate

- (void)schedulerDidFinishTransaction:(MountingCoordinator::Shared const &)mountingCoordinator
{
  RCTFabricSurface *surface = [_surfaceRegistry surfaceForRootTag:mountingCoordinator->getSurfaceId()];

  [surface _setStage:RCTSurfaceStagePrepared];

  [_mountingManager scheduleTransaction:mountingCoordinator];
}

<<<<<<< HEAD
- (void)schedulerDidDispatchCommand:(facebook::react::ShadowView const &)shadowView
=======
- (void)schedulerDidDispatchCommand:(ShadowView const &)shadowView
>>>>>>> fb/0.62-stable
                        commandName:(std::string const &)commandName
                               args:(folly::dynamic const)args
{
  ReactTag tag = shadowView.tag;
  NSString *commandStr = [[NSString alloc] initWithUTF8String:commandName.c_str()];
  NSArray *argsArray = convertFollyDynamicToId(args);

  [self->_mountingManager dispatchCommand:tag commandName:commandStr args:argsArray];
}

- (void)addObserver:(id<RCTSurfacePresenterObserver>)observer
{
  std::unique_lock<better::shared_mutex> lock(_observerListMutex);
  [self->_observers addObject:observer];
}

- (void)removeObserver:(id<RCTSurfacePresenterObserver>)observer
{
  std::unique_lock<better::shared_mutex> lock(_observerListMutex);
  [self->_observers removeObject:observer];
}

#pragma mark - RCTMountingManagerDelegate

- (void)mountingManager:(RCTMountingManager *)mountingManager willMountComponentsWithRootTag:(ReactTag)rootTag
{
  RCTAssertMainQueue();

  std::shared_lock<better::shared_mutex> lock(_observerListMutex);
  for (id<RCTSurfacePresenterObserver> observer in _observers) {
    if ([observer respondsToSelector:@selector(willMountComponentsWithRootTag:)]) {
      [observer willMountComponentsWithRootTag:rootTag];
    }
  }
}

- (void)mountingManager:(RCTMountingManager *)mountingManager didMountComponentsWithRootTag:(ReactTag)rootTag
{
  RCTAssertMainQueue();

  RCTFabricSurface *surface = [_surfaceRegistry surfaceForRootTag:rootTag];
  RCTSurfaceStage stage = surface.stage;
  if (stage & RCTSurfaceStagePrepared) {
    // We have to progress the stage only if the preparing phase is done.
    if ([surface _setStage:RCTSurfaceStageMounted]) {
      auto rootComponentViewDescriptor =
          [_mountingManager.componentViewRegistry componentViewDescriptorWithTag:rootTag];
      surface.view.rootView = (RCTSurfaceRootView *)rootComponentViewDescriptor.view;
    }
  }

  std::shared_lock<better::shared_mutex> lock(_observerListMutex);
  for (id<RCTSurfacePresenterObserver> observer in _observers) {
    if ([observer respondsToSelector:@selector(didMountComponentsWithRootTag:)]) {
      [observer didMountComponentsWithRootTag:rootTag];
    }
  }
}

<<<<<<< HEAD
#pragma mark - Bridge events

- (void)handleBridgeWillReloadNotification:(NSNotification *)notification
{
  {
    std::lock_guard<std::mutex> lock(_schedulerMutex);
    if (!_scheduler) {
      // Seems we are already in the realoding process.
      return;
    }
  }

  [self _stopAllSurfaces];

  {
    std::lock_guard<std::mutex> lock(_schedulerMutex);
    _scheduler = nil;
  }
}

- (void)handleJavaScriptDidLoadNotification:(NSNotification *)notification
{
  RCTBridge *bridge = notification.userInfo[@"bridge"];
  if (bridge != _batchedBridge) {
    _batchedBridge = bridge;

    [self _startAllSurfaces];
  }
}

=======
>>>>>>> fb/0.62-stable
@end
