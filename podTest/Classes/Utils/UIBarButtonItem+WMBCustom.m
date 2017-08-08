//
//  UIBarButtonItem+WMBCustom.m
//  waimaibiz
//
//  Created by aochuih on 15/4/3.
//  Copyright (c) 2015年 meituan. All rights reserved.
//

#import "UIBarButtonItem+WMBCustom.h"
#import "UIBarButtonItem+Custom.h"
#import "UIBarButtonItemAdditions.h"
#import "NSString+WMAdditions.h"

@implementation UIBarButtonItem (WMBCustom)

+ (UIBarButtonItem *)wmbBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = Font(16);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    button.width = [title boundingRectSizeWithFont:Font(16)].width;
    button.height = 50;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
}

@end
