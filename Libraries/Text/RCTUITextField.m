/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "RCTUITextField.h"

#import <React/RCTUtils.h>
#import <React/UIView+React.h>
#import "RCTBackedTextInputDelegateAdapter.h"

#if TARGET_OS_OSX

@interface RCTUITextFieldCell : NSTextFieldCell

@property (nonatomic, assign) UIEdgeInsets textContainerInset;
@property (nonatomic, getter=isAutomaticTextReplacementEnabled) BOOL automaticTextReplacementEnabled;
@property (nonatomic, getter=isAutomaticSpellingCorrectionEnabled) BOOL automaticSpellingCorrectionEnabled;
@property (nonatomic, strong, nullable) UIColor *selectionColor;

@end

@implementation RCTUITextFieldCell

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset
{
  _textContainerInset = textContainerInset;
}

- (NSRect)titleRectForBounds:(NSRect)rect
{
  return UIEdgeInsetsInsetRect([super titleRectForBounds:rect], self.textContainerInset);
}

- (void)editWithFrame:(NSRect)rect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)delegate event:(NSEvent *)event
{
  [super editWithFrame:[self titleRectForBounds:rect] inView:controlView editor:textObj delegate:delegate event:event];
}

- (void)selectWithFrame:(NSRect)rect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)delegate start:(NSInteger)selStart length:(NSInteger)selLength
{
  [super selectWithFrame:[self titleRectForBounds:rect] inView:controlView editor:textObj delegate:delegate start:selStart length:selLength];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
  if (self.drawsBackground) {
    if (self.backgroundColor && self.backgroundColor.alphaComponent > 0) {
      
      [self.backgroundColor set];
      NSRectFill(cellFrame);
    }
  }
  
  [super drawInteriorWithFrame:[self titleRectForBounds:cellFrame] inView:controlView];
}

- (NSText *)setUpFieldEditorAttributes:(NSText *)textObj
{
  NSTextView *fieldEditor = (NSTextView *)[super setUpFieldEditorAttributes:textObj];
  fieldEditor.automaticSpellingCorrectionEnabled = self.isAutomaticSpellingCorrectionEnabled;
  fieldEditor.automaticTextReplacementEnabled = self.isAutomaticTextReplacementEnabled;
  NSMutableDictionary *selectTextAttributes = fieldEditor.selectedTextAttributes.mutableCopy;
  selectTextAttributes[NSBackgroundColorAttributeName] = self.selectionColor ?: [NSColor selectedControlColor];
	fieldEditor.selectedTextAttributes = selectTextAttributes;
  fieldEditor.insertionPointColor = self.selectionColor ?: [NSColor selectedControlColor];
  return fieldEditor;
}

@end

#endif // TARGET_OS_OSX

@implementation RCTUITextField {
  RCTBackedTextFieldDelegateAdapter *_textInputDelegateAdapter;
}

#if TARGET_OS_OSX
@dynamic delegate;

static UIFont *defaultPlaceholderFont()
{
  return [UIFont systemFontOfSize:17];
}

static UIColor *defaultPlaceholderTextColor()
{
  // Default placeholder color from UITextField.
  return [UIColor colorWithRed:0 green:0 blue:0.0980392 alpha:0.22];
}

#endif

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
        
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_textDidChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self];

#if TARGET_OS_OSX
    self.bordered = NO;
    self.accessibilityRole = NSAccessibilityTextFieldRole;
#endif

    _textInputDelegateAdapter = [[RCTBackedTextFieldDelegateAdapter alloc] initWithTextField:self];
  }

  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)_textDidChange
{
  _textWasPasted = NO;
}

#pragma mark - Properties

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset
{
  _textContainerInset = textContainerInset;
#if !TARGET_OS_OSX
  [self setNeedsLayout];
#else
  ((RCTUITextFieldCell*)self.cell).textContainerInset = _textContainerInset;
#endif
}

#if TARGET_OS_OSX

+ (Class)cellClass
{
  return RCTUITextFieldCell.class;
}

- (void)setText:(NSString *)text
{
  self.stringValue = text;
}

- (NSString*)text
{
  return self.stringValue;
}

- (void)setAutomaticTextReplacementEnabled:(BOOL)automaticTextReplacementEnabled
{
  ((RCTUITextFieldCell*)self.cell).automaticTextReplacementEnabled = automaticTextReplacementEnabled;
}

- (BOOL)isAutomaticTextReplacementEnabled
{
  return ((RCTUITextFieldCell*)self.cell).isAutomaticTextReplacementEnabled;
}

- (void)setAutomaticSpellingCorrectionEnabled:(BOOL)automaticSpellingCorrectionEnabled
{
  ((RCTUITextFieldCell*)self.cell).automaticSpellingCorrectionEnabled = automaticSpellingCorrectionEnabled;
}

- (BOOL)isAutomaticSpellingCorrectionEnabled
{
  return ((RCTUITextFieldCell*)self.cell).isAutomaticSpellingCorrectionEnabled;
}

- (void)setSelectionColor:(UIColor *)selectionColor
{
  ((RCTUITextFieldCell*)self.cell).selectionColor = selectionColor;
}

- (UIColor*)selectionColor
{
  return ((RCTUITextFieldCell*)self.cell).selectionColor;
}

- (void)setFont:(UIFont *)font
{
  ((RCTUITextFieldCell*)self.cell).font = font;
}

- (UIFont *)font
{
  return ((RCTUITextFieldCell*)self.cell).font;
}

#endif // TARGET_OS_OSX

- (void)setPlaceholder:(NSString *)placeholderString
{
#if !TARGET_OS_OSX
  [super setPlaceholder:placeholderString];
#else
  [super setPlaceholderString:placeholderString];
#endif
  [self _updatePlaceholder];
}
  
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
  _placeholderColor = placeholderColor;
  [self _updatePlaceholder];
}
  
- (NSString*)placeholder
{
#if !TARGET_OS_OSX
  return super.placeholder;
#else
  return self.placeholderAttributedString.string ?: self.placeholderString;
#endif
}

- (void)_updatePlaceholder
{
  if (self.placeholder == nil) {
    return;
  }

  NSMutableDictionary *attributes = [NSMutableDictionary new];
  
#if !TARGET_OS_OSX
  if (_placeholderColor) {
    [attributes setObject:_placeholderColor forKey:NSForegroundColorAttributeName];
  }

  self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder
                                                               attributes:attributes];
#else
  attributes[NSForegroundColorAttributeName] = _placeholderColor ?: defaultPlaceholderTextColor();
  attributes[NSFontAttributeName] = self.font ?: defaultPlaceholderFont();
  
  self.placeholderAttributedString = [[NSAttributedString alloc] initWithString:self.placeholder
                                                                     attributes:attributes];
#endif
}

- (BOOL)isEditable
{
  return self.isEnabled;
}

- (void)setEditable:(BOOL)editable
{
#if TARGET_OS_OSX
  // on macos the super must be called otherwise its NSTextFieldCell editable property doesn't get set.
  [super setEditable:editable];
#endif
  self.enabled = editable;
}

#if !TARGET_OS_OSX

#pragma mark - Caret Manipulation

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
  if (_caretHidden) {
    return CGRectZero;
  }

  return [super caretRectForPosition:position];
}

#pragma mark - Positioning Overrides

- (CGRect)textRectForBounds:(CGRect)bounds
{
  return UIEdgeInsetsInsetRect([super textRectForBounds:bounds], _textContainerInset);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
  return [self textRectForBounds:bounds];
}
  
#else
  
#pragma mark - NSTextViewDelegate methods

- (void)textDidBeginEditing:(NSNotification *)notification
{
  [super textDidBeginEditing:notification];
  id<RCTUITextFieldDelegate> delegate = self.delegate;
  if ([delegate respondsToSelector:@selector(textFieldBeginEditing:)]) {
    [delegate textFieldBeginEditing:self];
  }
}
  
- (void)textDidChange:(NSNotification *)notification
{
  [super textDidChange:notification];
  id<RCTUITextFieldDelegate> delegate = self.delegate;
  if ([delegate respondsToSelector:@selector(textFieldDidChange:)]) {
    [delegate textFieldDidChange:self];
  }
}
  
- (void)textDidEndEditing:(NSNotification *)notification
{
  [super textDidEndEditing:notification];    
  id<RCTUITextFieldDelegate> delegate = self.delegate;
  if ([delegate respondsToSelector:@selector(textFieldEndEditing:)]) {
    [delegate textFieldEndEditing:self];
  }
}
  
- (void)textViewDidChangeSelection:(NSNotification *)notification
{
  id<RCTUITextFieldDelegate> delegate = self.delegate;
  if ([delegate respondsToSelector:@selector(textFieldDidChangeSelection:)]) {
    [delegate textFieldDidChangeSelection:self];
  }
}

- (BOOL)textView:(NSTextView *)aTextView shouldChangeTextInRange:(NSRange)aRange replacementString:(NSString *)aString
{
  id<RCTUITextFieldDelegate> delegate = self.delegate;
  if ([delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
    return [delegate textField:self shouldChangeCharactersInRange:aRange replacementString:aString];
  }
  return NO;
}
  
#endif

#pragma mark - Overrides

#if TARGET_OS_OSX
- (BOOL)becomeFirstResponder
{
  BOOL isFirstResponder = [super becomeFirstResponder];
  if (isFirstResponder) {
    NSScrollView *scrollView = [self enclosingScrollView];
    if (scrollView != nil) {
      NSRect visibleRect = [[scrollView documentView] convertRect:self.frame fromView:self];
      [[scrollView documentView] scrollRectToVisible:visibleRect];
    }
  }
  return isFirstResponder;
}
#endif
	
#if !TARGET_OS_OSX
- (void)setSelectedTextRange:(UITextRange *)selectedTextRange
{
  [super setSelectedTextRange:selectedTextRange];
  [_textInputDelegateAdapter selectedTextRangeWasSet];
}

- (void)setSelectedTextRange:(UITextRange *)selectedTextRange notifyDelegate:(BOOL)notifyDelegate
{
  if (!notifyDelegate) {
    // We have to notify an adapter that following selection change was initiated programmatically,
    // so the adapter must not generate a notification for it.
    [_textInputDelegateAdapter skipNextTextInputDidChangeSelectionEventWithTextRange:selectedTextRange];
  }

  [super setSelectedTextRange:selectedTextRange];
}

- (void)paste:(id)sender
{
  [super paste:sender];
  _textWasPasted = YES;
}
#else
- (void)setSelectedTextRange:(NSRange)selectedTextRange notifyDelegate:(BOOL)notifyDelegate
{
  if (!notifyDelegate) {
    // We have to notify an adapter that following selection change was initiated programmatically,
    // so the adapter must not generate a notification for it.
    [_textInputDelegateAdapter skipNextTextInputDidChangeSelectionEventWithTextRange:selectedTextRange];
  }
  
  [[self currentEditor] setSelectedRange:selectedTextRange];
}

- (NSRange)selectedTextRange
{
  return [[self currentEditor] selectedRange];
}
#endif

#pragma mark - Layout

- (CGSize)contentSize
{
  // Returning size DOES contain `textContainerInset` (aka `padding`).
  return self.intrinsicContentSize;
}

- (CGSize)intrinsicContentSize
{
  // Note: `placeholder` defines intrinsic size for `<TextInput>`.
  NSString *text = self.placeholder ?: @"";
  CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: self.font}];
  
#if !TARGET_OS_OSX
  size = CGSizeMake(RCTCeilPixelValue(size.width), RCTCeilPixelValue(size.height));
#else
  CGFloat scale = self.window.backingScaleFactor;
  // TODO(tomun): a layout pass now happens before the view is in a window
  //RCTAssert(scale != 0.0, @"Layout occurs before the view is in a window?");
  if (scale == 0) {
    scale = [[NSScreen mainScreen] backingScaleFactor];
  }
  size = CGSizeMake(RCTCeilPixelValue(size.width, scale), RCTCeilPixelValue(size.height, scale));
#endif
  size.width += _textContainerInset.left + _textContainerInset.right;
  size.height += _textContainerInset.top + _textContainerInset.bottom;
  // Returning size DOES contain `textContainerInset` (aka `padding`).
  return size;
}

- (CGSize)sizeThatFits:(CGSize)size
{
  // All size values here contain `textContainerInset` (aka `padding`).
  CGSize intrinsicSize = self.intrinsicContentSize;
  return CGSizeMake(MIN(size.width, intrinsicSize.width), MIN(size.height, intrinsicSize.height));
}

#if !TARGET_OS_OSX
- (void)deleteBackward {
  id<RCTBackedTextInputDelegate> textInputDelegate = [self textInputDelegate];
  if ([textInputDelegate textInputShouldHandleDeleteBackward:self]) {
    [super deleteBackward];
  }
}
#endif

@end