//
//  UIView+WMBAdditions.m
//  waimaibiz
//
//  Created by 刘言明 on 8/4/15.
//  Copyright (c) 2015 meituan. All rights reserved.
//

#import "UIView+WMBAdditions.h"
#import <ReactiveCocoa.h>
#import "UIResponder+WMBAdditions.h"

@implementation UIView (WMBAdditions)

- (void)dropShadow {
    [self dropShadowWithRect:self.bounds];
}

- (void)dropTopShadow {
    CGRect rect = self.bounds;
    rect.size.height /= 2;
    [self dropShadowWithRect:rect];
}

- (void)dropBottomShadow {
    CGRect rect = self.bounds;
    rect.size.height /= 2;
    rect.origin.y += rect.size.height;
    [self dropShadowWithRect:rect];
}

- (void)dropNoShadow {
    self.layer.shadowOpacity = 0;
}

- (void)dropShadowWithRect:(CGRect)rect {
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowColor = HEXCOLOR(0xcccccc).CGColor;
    self.layer.shadowRadius = 0.5;
    self.layer.shadowOpacity = 1;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:rect].CGPath;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

@end

@implementation UIView (WMBAnimation)

- (void)recursiveRemoveAnimations
{
    for (UIView *subview in self.subviews) {
        [subview.layer removeAllAnimations];
        [subview recursiveRemoveAnimations];
    }
}

@end

@implementation UIView (WMBCornerRadius)

- (void)setCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
    if (width > 0) {
        self.layer.borderWidth = width;
        if (color) {
            self.layer.borderColor = color.CGColor;
        }
    }
}

@end

@implementation UIView (WMBShowKeyboard)

- (void)showFirstResponderWhenKeyboardShowWithScrollView:(UIScrollView *)scrollView
{
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter]
       rac_addObserverForName:UIKeyboardWillShowNotification object:nil]
      takeUntil:self.rac_willDeallocSignal]
     subscribeNext:^(NSNotification *notification) {
         @strongify(self);
         [self handleKeyboardWillShowWithNotification:notification scrollView:scrollView];
     }];
}

- (void)handleKeyboardWillShowWithNotification:(NSNotification *)notification scrollView:(UIScrollView *)scrollView
{
    NSDictionary *userInfo = notification.userInfo;
    CGSize keyboardSize = (((NSValue *)userInfo[UIKeyboardFrameEndUserInfoKey]).CGRectValue).size;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    UIResponder *firstResponder = [UIResponder wmb_currentFirstResponder];
    UIView *view;
    if ([firstResponder isKindOfClass:[UIView class]]) {
        view = (UIView *)firstResponder;
    }
    // 暂不考虑VC的情况
    if (view) {
        CGRect frame = [view convertRect:view.bounds toView:self];
        CGFloat offsetHeight = floor(CGRectGetMaxY(frame) - (CGRectGetHeight(self.bounds) - keyboardSize.height));
        if (offsetHeight > 0) {
            [UIView animateWithDuration:duration animations:^{
                [scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y + offsetHeight) animated:NO];
            } completion:^(BOOL finished) {
            }];
        }
    }
}

@end

