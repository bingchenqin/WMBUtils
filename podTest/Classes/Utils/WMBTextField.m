//
//  WMBTextField.m
//  waimaibiz
//
//  Created by jianghaowen on 2016/12/7.
//  Copyright © 2016年 meituan. All rights reserved.
//

#import "WMBTextField.h"
#import "MTTextField.h"
#import <ReactiveCocoa.h>

@interface WMBTextField ()<UITextFieldDelegate>

@property (nonatomic, weak) id <UITextFieldDelegate> wmb_delegate;

@end

@implementation WMBTextField 

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.delegate = self;
}

- (void)setDelegate:(id<UITextFieldDelegate>)delegate
{
    if (delegate == self) {
        [super setDelegate:delegate];
    } else {
        self.wmb_delegate = delegate;
    }
}

- (void)setMaxTextLength:(NSUInteger)maxTextLength
{
    _maxTextLength = maxTextLength;
    
    if (_maxTextLength > 0) {
        @weakify(self);
        [[[[NSNotificationCenter defaultCenter]
           rac_addObserverForName:UITextFieldTextDidChangeNotification object:self]
          takeUntil:self.rac_willDeallocSignal]
         subscribeNext:^(NSNotification *notification) {
             @strongify(self);
             [self handleTextDidChangeNotification:notification];
         }];
    }
}

- (void)handleTextDidChangeNotification:(NSNotification *)notification
{
    BOOL should = NO;
    
    if (self.maxTextLength > 0) {
        if ([self.textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [self markedTextRange];
            UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
            if(!position) {
                should = YES;
            }
        } else {
            should = YES;
        }
    }
    if (should) {
        if(self.text.length > self.maxTextLength) {
            // 防止emoji截断
            NSRange rangeIndex = [self.text rangeOfComposedCharacterSequenceAtIndex:self.maxTextLength];
            self.text = [self.text substringToIndex:(rangeIndex.location)];
            [UIAlertView showAlertViewWithMessage:[NSString stringWithFormat:@"最多输入%@字", @(self.maxTextLength)]];
            [self.undoManager removeAllActions];
        }
    }
}

#pragma mark forwarding UITextFieldDelegate method

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self.wmb_delegate respondsToSelector:aSelector]) {
        return self.wmb_delegate;
    }
    return  [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [super respondsToSelector:aSelector] || [self.wmb_delegate respondsToSelector:aSelector];
}

@end
