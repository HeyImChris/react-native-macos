/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <React/RCTUIKit.h>

#import <React/RCTView.h>

#import "RCTBackedTextInputViewProtocol.h"
#import "RCTFontAttributes.h"
#import "RCTFontAttributesDelegate.h"

@class RCTBridge;
@class RCTEventDispatcher;
@class RCTTextSelection;

@interface RCTTextInput : RCTView <RCTFontAttributesDelegate> {
@protected
  RCTBridge *_bridge;
  RCTEventDispatcher *_eventDispatcher;
  NSInteger _nativeEventCount;
  NSInteger _mostRecentEventCount;
  BOOL _blurOnSubmit;
}

- (instancetype)initWithBridge:(RCTBridge *)bridge NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)decoder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@property (nonatomic, readonly) UIView<RCTBackedTextInputViewProtocol> *backedTextInputView;

@property (nonatomic, assign) UIEdgeInsets reactPaddingInsets;
@property (nonatomic, assign) UIEdgeInsets reactBorderInsets;
@property (nonatomic, assign, readonly) CGSize contentSize;

@property (nonatomic, copy) RCTDirectEventBlock onContentSizeChange;
@property (nonatomic, copy) RCTDirectEventBlock onSelectionChange;

@property (nonatomic, readonly, strong) RCTFontAttributes *fontAttributes;

@property (nonatomic, assign) NSInteger mostRecentEventCount;
@property (nonatomic, assign) BOOL blurOnSubmit;
#if !TARGET_OS_OSX
@property (nonatomic, assign) BOOL selectTextOnFocus;
@property (nonatomic, assign) BOOL clearTextOnFocus;
#endif
@property (nonatomic, copy) RCTTextSelection *selection;

- (void)setFont:(UIFont *)font;

- (void)invalidateContentSize;

// Temporary exposure of partial `RCTBackedTextInputDelegate` support.
// In the future all methods of the protocol should move to this class.
- (BOOL)textInputShouldBeginEditing;
- (void)textInputDidBeginEditing;
- (BOOL)textInputShouldReturn;
- (void)textInputDidReturn;
- (void)textInputDidChangeSelection;
- (BOOL)textInputShouldEndEditing;
- (void)textInputDidEndEditing;
- (BOOL)textInputShouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string;
- (void)textInputDidChange;
- (BOOL)textInputShouldHandleDeleteBackward:(id)sender;
#if TARGET_OS_OSX
- (BOOL)textInputShouldHandleDeleteForward:(id)sender;
#endif

@end