//
//  UIButton+Custom.h
//  imeituan
//
//  Created by 陈晓亮 on 13-6-4.
//  Copyright (c) 2013年 Meituan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (WaimaiBizCustom)

+ (instancetype)customButtonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font;

+ (instancetype)themeColorSolidButton;

+ (instancetype)themeColorButton;
+ (instancetype)greyBorderButton;
+ (instancetype)themeColorBorderButton;
+ (instancetype)themeColorHollowBorderButton;
+ (instancetype)redHollowBorderButton;
+ (instancetype)fdb463HollowBorderButton;
+ (instancetype)smallButton;
+ (instancetype)tagButtonWithTitle:(NSString *)title;
+ (instancetype)greyButton;
+ (instancetype)foodCustomButtonWithTitleLabelName:(NSString *)titleLabelName;

- (void)changeTitle:(NSString *)title andColor:(UIColor *)color;
- (void)changeAppearanceToColor:(UIColor *)color;
- (void)changeAppearanceWithBorderColor:(UIColor *)borderColor normalBackgroundColor:(UIColor *)normalBackgroundColor highlightedImageColor:(UIColor *)highlightedColor titleColor:(UIColor *)titleColor;

- (void)changeAppearanceToThemeColorCustomButton;
- (void)changeAppearanceToThemeColorSelectedButton;
- (void)changeAppearanceToGrayColorCustomButton;

- (void)centerImageAndTitleWithSpacing:(CGFloat)spacing;

@end

@interface UIButton (WMBDropdownlistButton)

+ (UIButton *)buttonWithImage:(UIImage *)image andTitle:(NSString *)titile imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets;

@end
