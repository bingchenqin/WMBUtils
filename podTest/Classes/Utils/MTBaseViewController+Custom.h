//
//  MTBaseViewController+Custom.h
//  imeituan
//
//  Created by 陈晓亮 on 13-6-5.
//  Copyright (c) 2013年 Meituan.com. All rights reserved.
//

#import "MTBaseViewController.h"

@interface MTBaseViewController (Custom)

- (void)enableTitle:(NSString *)title andSubTitle:(NSString *)subTitle;
- (void)updateTitle:(NSString *)title andSubTitle:(NSString *)subTitle;
- (void)resetState;

@end
