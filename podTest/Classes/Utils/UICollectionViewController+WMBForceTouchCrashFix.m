//
//  UICollectionView+WMBForceTouchCrashFix.m
//  waimaibiz
//
//  Created by jianghaowen on 16/7/7.
//  Copyright © 2016年 meituan. All rights reserved.
//

#import "UICollectionViewController+WMBForceTouchCrashFix.h"
#import <objc/runtime.h>

@implementation UICollectionViewController (WMBForceTouchCrashFix)

static UIViewController* previewingContextWithViewControllerForLocation(id self, SEL _cmd, id<UIViewControllerPreviewing> previewingContext, CGPoint location)
{
    return nil;
}

+ (void)load
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(9.3) ||
        SYSTEM_VERSION_LESS_THAN(9.0)) {
        return;
    }
    
    class_replaceMethod([self class], @selector(previewingContext:viewControllerForLocation:), (IMP)previewingContextWithViewControllerForLocation, "@@:@{CGPoint=dd}");
}

@end
