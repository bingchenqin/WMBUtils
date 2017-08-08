//
//  UINavigationController+WMBCustom.m
//  waimaibiz
//
//  Created by liuyanming on 02/06/2017.
//  Copyright © 2017 meituan. All rights reserved.
//

#import "UINavigationController+WMBCustom.h"

@implementation UINavigationController (WMBCustom)

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

@end
