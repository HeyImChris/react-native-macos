/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "RCTBackedTextInputViewProtocol.h"
#import "RCTBackedTextInputDelegate.h"

#pragma mark - RCTBackedTextFieldDelegateAdapter (for UITextField)

@interface RCTBackedTextFieldDelegateAdapter : NSObject

- (instancetype)initWithTextField:(UITextField<RCTBackedTextInputViewProtocol> *)backedTextInput;

#if !TARGET_OS_OSX
- (void)skipNextTextInputDidChangeSelectionEventWithTextRange:(UITextRange *)textRange;
#else
- (void)skipNextTextInputDidChangeSelectionEventWithTextRange:(NSRange)textRange;
#endif
- (void)selectedTextRangeWasSet;

@end

#pragma mark - RCTBackedTextViewDelegateAdapter (for UITextView)

@interface RCTBackedTextViewDelegateAdapter : NSObject

- (instancetype)initWithTextView:(UITextView<RCTBackedTextInputViewProtocol> *)backedTextInput;

#if !TARGET_OS_OSX
- (void)skipNextTextInputDidChangeSelectionEventWithTextRange:(UITextRange *)textRange;
#else
- (void)skipNextTextInputDidChangeSelectionEventWithTextRange:(NSRange)textRange;
#endif

@end