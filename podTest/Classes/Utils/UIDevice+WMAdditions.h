//
//  UIDevice+WMAdditions.h
//  waimai
//
//  Created by wangjiangjiao on 15/9/21.
//  Copyright (c) 2015年 meituan. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kWMJailbreakKey;

@interface UIDevice (WMAdditions)

+ (NSDictionary *)deviceIsJailbroken;
- (NSString *)wm_platformString;
+ (CGFloat)wm_getDeviceScale;
+ (CGFloat)wm_getDeviceDetailScale;

@end
