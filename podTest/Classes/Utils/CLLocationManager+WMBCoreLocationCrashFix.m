//
//  CLLocationManager+WMBCoreLocationCrashFix.m
//  waimaibiz
//
//  Created by jianghaowen on 16/9/14.
//  Copyright © 2016年 meituan. All rights reserved.
//

#import "CLLocationManager+WMBCoreLocationCrashFix.h"
#import "SAKSwizzle.h"

//these code borrowed from 配送
@implementation CLLocationManager (WMBCoreLocationCrashFix)

+ (void)load
{
    [self sak_SwizzleMethod:@selector(init) withMethod:@selector(bmcs_init) error:nil];
}

- (instancetype)bmcs_init
{
    id tmpSelf = [self bmcs_init];
    if ([NSThread isMainThread]) {
        // 延迟释放
        CLLocationManager *delayManager = tmpSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"%@", delayManager);
        });
    }
    return tmpSelf;
}


@end