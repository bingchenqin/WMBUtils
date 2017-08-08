//
//  UIImagePickerController+CrashFix.m
//  waimaibiz
//
//  Created by jianghaowen on 2017/7/24.
//  Copyright © 2017年 meituan. All rights reserved.
//

#import "UIImagePickerController+CrashFix.h"
#import <objc/runtime.h>
#import <SAKSwizzle.h>

@implementation UIImagePickerController (CrashFix)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

static IMP originalIMP;

FOUNDATION_STATIC_INLINE void wmb_didCapturePhoto(id slf, SEL sel, id vc, id image, id pro, id error) {
    if (image) {
        ((void (*)(id,SEL,id,id,id,id))originalIMP)(slf, sel, vc, image, pro, error);
    } else {
        return;
    }
}

+ (void)load
{
    if (SYSTEM_VERSION_IS_IOS_10_OR_ABOVE && !SYSTEM_VERSION_IS_IOS_11_OR_ABOVE) {
        [self sak_SwizzleMethod:@selector(viewDidLoad) withMethod:@selector(wmb_viewDidLoad) error:nil];
    }
}

- (void)wmb_viewDidLoad
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *s1 = @"CAMImage";
        NSString *s2 = @"ontroller";
        NSString *s3 = @"PickerCameraViewC";
        
        Class cls = NSClassFromString([NSString stringWithFormat:@"%@%@%@", s1, s3, s2]);
        if (cls) {
            SEL originalSelector = @selector(cameraViewController:didCapturePhoto:withProperties:error:);
            Method originalMethod = class_getInstanceMethod(cls, originalSelector);
            originalIMP = method_getImplementation(originalMethod);
            method_setImplementation(originalMethod, (IMP)wmb_didCapturePhoto);
        }
    });
    [self wmb_viewDidLoad];
}

#pragma clang diagnostic pop

@end
