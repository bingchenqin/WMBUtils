//
//  UIButton+Custom.m
//  imeituan
//
//  Created by 陈晓亮 on 13-6-4.
//  Copyright (c) 2013年 Meituan.com. All rights reserved.
//

#import "UIButton+WaimaiBizCustom.h"
#import "UIButtonAdditions.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+WMAdditions.h"
#import "ReactiveCocoa.h"

@implementation UIButton (WaimaiBizCustom)

+ (instancetype)customButtonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    return button;
}

#pragma mark - solid buttons

+ (instancetype)themeColorSolidButton
{
    //为了给子类使用
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 5.0f;
    button.clipsToBounds = YES;
    button.titleLabel.font = Font(16);
    [button changeAppearanceWithBorderColor:[UIColor clearColor] normalBackgroundColor:THEME_COLOR highlightedImageColor:HEXCOLOR(0x05b3a1) titleColor:[UIColor whiteColor]];
    return button;
}

#pragma mark - border buttons

+ (instancetype)greyBorderButton
{
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 5.0f;
    button.clipsToBounds = YES;
    button.layer.borderWidth = 1;
    button.titleLabel.font = Font(16);
    [button changeAppearanceWithBorderColor:HEXCOLOR(0xd8d8d8) normalBackgroundColor:HEXCOLOR(0xf1f1f2) highlightedImageColor:HEXCOLOR(0xd8d8d8) titleColor:HEXCOLOR(0x505050) highlightedTitleColor:HEXCOLOR(0x505050)];
    return button;
}

+ (instancetype)themeColorBorderButton
{
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 5.0f;
    button.clipsToBounds = YES;
    button.layer.borderWidth = 1;
    button.titleLabel.font = BoldFont(15);
    [button changeAppearanceToColor:THEME_COLOR];
    return button;
}

+ (instancetype)themeColorHollowBorderButton
{
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button changeAppearanceWithBorderColor:THEME_COLOR normalBackgroundColor:[UIColor clearColor] highlightedImageColor:THEME_COLOR titleColor:THEME_COLOR];
    
    return button;
}

+ (instancetype)redHollowBorderButton
{
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button changeAppearanceWithBorderColor:HEXCOLOR(0x8fc31f) normalBackgroundColor:[UIColor clearColor] highlightedImageColor:HEXCOLOR(0x8fc31f) titleColor:HEXCOLOR(0x8fc31f)];
    
    return button;
}

+ (instancetype)fdb463HollowBorderButton
{
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button changeAppearanceWithBorderColor:HEXCOLOR(0xfdb463) normalBackgroundColor:[UIColor clearColor] highlightedImageColor:HEXCOLOR(0xfdb463) titleColor:HEXCOLOR(0xfdb463)];
    
    return button;
}

#pragma mark - solid color buttons

+ (instancetype)themeColorButton
{
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button changeAppearanceToThemeColorCustomButton];
    return button;
}

+ (instancetype)greyButton
{
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xe9e9e9)] forState:UIControlStateNormal];
    [button setTitleColor:HEXCOLOR(0xc2c2c2) forState:UIControlStateNormal];
    button.clipsToBounds = YES;
    return button;
}

+ (instancetype)smallButton
{
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    button.width = 46;
    button.height = 26;
    button.layer.cornerRadius = 3;
    button.layer.borderWidth = 1;
    button.clipsToBounds = YES;
    button.titleLabel.font = Font(12);
    return button;
}

+ (instancetype)yellowCustomButton
{
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xED9400)] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xBE7600)] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageWithColor:HEXACOLOR(0xED9400, 0.3)] forState:UIControlStateDisabled];
    button.layer.cornerRadius = 2.0f;
    button.clipsToBounds = YES;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = Font(16);
    return button;
}

+ (instancetype)tagButtonWithTitle:(NSString *)title
{
    UIButton *button = [[self alloc] init];
    button.titleLabel.font = Font(16);
    [button setTitle:title forState:UIControlStateNormal];
    button.layer.cornerRadius = 2.0;
    button.clipsToBounds = YES;
    [button setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xeeeeee)] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:THEME_COLOR] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageWithColor:THEME_COLOR] forState:UIControlStateSelected];
    [button setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
    [button setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateHighlighted];
    [button setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateSelected];
    [button setContentEdgeInsets:UIEdgeInsetsMake(2, 5, 2, 5)];
    
    return button;
}

+ (instancetype)foodCustomButtonWithTitleLabelName:(NSString *)titleLabelName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    [button setTitleColor:HEXCOLOR(0xc2c2c2) forState:UIControlStateDisabled];
    button.titleLabel.font = Font(14);
    
    AutoType makeImage = ^UIImage *(BOOL disabled) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(11, 11), NO, 0);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.5, 0.5, 10, 10) cornerRadius:3.5];
        path.lineWidth = 1;
        if (disabled) {
            [HEXCOLOR(0xd8d8d8) setStroke];
            [BACKGROUND_COLOR setFill];
        } else {
            [THEME_COLOR setStroke];
            [UIColor.clearColor setFill];
        }
        [path fill];
        [path stroke];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    };
    UIImage *normalImage = makeImage(NO);
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:normalImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:makeImage(YES) forState:UIControlStateDisabled];
    [button setTitle:titleLabelName forState:UIControlStateNormal];
    return button;
}

#pragma mark - instance methods

- (void)changeTitle:(NSString *)title andColor:(UIColor *)color
{
    self.layer.borderColor = [color CGColor];
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xFFFFFF)] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateHighlighted];
    [self setTitleColor:HEXCOLOR(0xFFFFFF) forState:UIControlStateHighlighted];
}

- (void)changeAppearanceWithBorderColor:(UIColor *)borderColor normalBackgroundColor:(UIColor *)normalBackgroundColor highlightedImageColor:(UIColor *)highlightedColor titleColor:(UIColor *)titleColor highlightedTitleColor:(UIColor *)highlightedTitleColor
{
    [self setBackgroundImage:[UIImage imageWithColor:normalBackgroundColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:highlightedColor] forState:UIControlStateHighlighted];
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    [self setTitleColor:highlightedTitleColor forState:UIControlStateHighlighted];
    self.layer.borderColor = borderColor.CGColor;
}

- (void)changeAppearanceWithBorderColor:(UIColor *)borderColor normalBackgroundColor:(UIColor *)normalBackgroundColor highlightedImageColor:(UIColor *)highlightedColor titleColor:(UIColor *)titleColor
{
    [self setBackgroundImage:[UIImage imageWithColor:normalBackgroundColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:highlightedColor] forState:UIControlStateHighlighted];
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    self.layer.borderColor = borderColor.CGColor;
}

- (void)changeAppearanceToThemeColorCustomButton
{
    [self setBackgroundImage:[UIImage imageWithColor:THEME_COLOR] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x049387)] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x96E4DA)] forState:UIControlStateDisabled];
    self.layer.cornerRadius = 2.0f;
    self.clipsToBounds = YES;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = Font(16);
}

- (void)changeAppearanceToThemeColorSelectedButton
{
    self.layer.cornerRadius = 3.0f;
    self.layer.borderWidth = 1.;
    self.clipsToBounds = YES;
    self.titleLabel.font = Font(14);
    [self setTitleColor:HEXCOLOR(0x909090) forState:UIControlStateNormal];
    [self setTitleColor:THEME_COLOR forState:UIControlStateSelected];
    [self setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xF1F1F2)] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
    [self setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xd8d8d8)] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xd8d8d8)] forState:UIControlStateHighlighted | UIControlStateSelected];
    
    @weakify(self);
    [RACObserve(self, selected) subscribeNext:^(id x) {
        @strongify(self);
        self.layer.borderColor = (self.selected ? THEME_COLOR : HEXCOLOR(0xd8d8d8)).CGColor;
    }];
}

- (void)changeAppearanceToGrayColorCustomButton
{
    self.layer.cornerRadius = 5.0f;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 1;
    self.titleLabel.font = Font(16);
    [self changeAppearanceWithBorderColor:HEXCOLOR(0xd8d8d8) normalBackgroundColor:HEXCOLOR(0xf1f1f2) highlightedImageColor:HEXCOLOR(0xd8d8d8) titleColor:HEXCOLOR(0x505050) highlightedTitleColor:HEXCOLOR(0x505050)];
}

- (void)changeAppearanceToColor:(UIColor *)color
{
    [self changeAppearanceWithBorderColor:color normalBackgroundColor:[UIColor clearColor] highlightedImageColor:color titleColor:color];
}

- (void)centerImageAndTitleWithSpacing:(CGFloat)spacing
{
    if (self.imageView.right <= self.titleLabel.left) {
        // [imageView][titleLabel]
        self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    } else if (self.imageView.left >= self.titleLabel.right){
        // [titleLabel][imageView]
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
        self.imageEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
    }
}

@end

@implementation UIButton (WMBDropdownlistButton)

+ (UIButton *)buttonWithImage:(UIImage *)image andTitle:(NSString *)titile imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:titile forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    [button setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
    button.titleLabel.font = Font(16);
    [button setImageEdgeInsets:imageEdgeInsets];
    [button setTitleEdgeInsets:titleEdgeInsets];
    return button;
}

@end
