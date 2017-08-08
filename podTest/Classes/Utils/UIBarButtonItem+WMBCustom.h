//
//  UIBarButtonItem+WMBCustom.h
//  waimaibiz
//
//  Created by aochuih on 15/4/3.
//  Copyright (c) 2015年 meituan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (WMBCustom)

+ (UIBarButtonItem *)wmbBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@end
