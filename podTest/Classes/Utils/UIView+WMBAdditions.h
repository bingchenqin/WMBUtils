//
//  UIView+WMBAdditions.h
//  waimaibiz
//
//  Created by 刘言明 on 8/4/15.
//  Copyright (c) 2015 meituan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WMBAdditions)

- (void)dropShadow;
- (void)dropTopShadow;
- (void)dropBottomShadow;
- (void)dropNoShadow;

@end

@interface UIView (WMBAnimation)

- (void)recursiveRemoveAnimations;

@end

@interface UIView (WMBCornerRadius)

- (void)setCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color;

@end

@interface UIView (WMBShowKeyboard)

- (void)showFirstResponderWhenKeyboardShowWithScrollView:(UIScrollView *)scrollView;

@end

