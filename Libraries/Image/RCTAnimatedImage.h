<<<<<<< HEAD
/**
=======
/*
>>>>>>> fb/0.62-stable
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

<<<<<<< HEAD
#import <React/RCTUIKit.h> // TODO(macOS ISS#2323203)
=======
#import <UIKit/UIKit.h>
>>>>>>> fb/0.62-stable

@protocol RCTAnimatedImage <NSObject>
@property (nonatomic, assign, readonly) NSUInteger animatedImageFrameCount;
@property (nonatomic, assign, readonly) NSUInteger animatedImageLoopCount;

- (nullable UIImage *)animatedImageFrameAtIndex:(NSUInteger)index;
- (NSTimeInterval)animatedImageDurationAtIndex:(NSUInteger)index;

@end

@interface RCTAnimatedImage : UIImage <RCTAnimatedImage>
<<<<<<< HEAD
// [TODO(macOS ISS#2323203)
// This is a known initializer for UIImage, but needs to be exposed publicly for macOS since
// this is not a known initializer for NSImage
- (nullable instancetype)initWithData:(NSData *)data scale:(CGFloat)scale;
// ]TODO(macOS ISS#2323203)
=======

>>>>>>> fb/0.62-stable
@end
