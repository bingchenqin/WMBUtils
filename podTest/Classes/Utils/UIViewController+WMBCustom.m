//
//  UIViewController+WMBCustom.m
//  waimaibiz
//
//  Created by liuyanming on 02/06/2017.
//  Copyright © 2017 meituan. All rights reserved.
//

#import "UIViewController+WMBCustom.h"
#import "WMBAppDelegate.h"

@implementation UIViewController (WMBCustom)

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end
