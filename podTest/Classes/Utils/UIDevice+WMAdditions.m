//
//  UIDevice+WMAdditions.m
//  waimai
//
//  Created by wangjiangjiao on 15/9/21.
//  Copyright (c) 2015年 meituan. All rights reserved.
//

#import "UIDevice+WMAdditions.h"
#import <mach-o/dyld.h>
#include <sys/sysctl.h>
#import <sys/stat.h>

NSString *const kWMJailbreakKey = @"Jailbreak";  // 越狱用户

static NSString *WM_UIDevice_platfrom = nil;

@implementation UIDevice (WMAdditions)

+ (NSDictionary *)deviceIsJailbroken
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@(NO) forKey:kWMJailbreakKey];
    // 直接通过NSFileManager检查是否存在Cydia
    if ([[NSURL fileURLWithPath:@"/Applications/Cydia.app"] checkResourceIsReachableAndReturnError:nil] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"]
        ) {
        [dictionary setObject:@(YES) forKey:kWMJailbreakKey];
        return [dictionary copy];
    }
    
    // 通过stat检查Cydia.app是否存在
    struct stat stat_info;
    if (0 == stat("/Applications/Cydia.app", &stat_info)) {
        [dictionary setObject:@(YES) forKey:kWMJailbreakKey];
        return [dictionary copy];
    }
    
    // 检查环境变量中的DYLD_INSERT_LIBRARIES 越狱了之后会插入MobileSubstrate
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    NSString *envString = [NSString stringWithFormat:@"%s", env];
    if ([envString rangeOfString:@"mobilesubstrate" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        [dictionary setObject:@(YES) forKey:kWMJailbreakKey];
        return [dictionary copy];
    }
    // iOS 7.1之后盘古越狱会有这两个文件（只要越狱后就会有）
    if (([[NSURL fileURLWithPath:@"/panguaxe"] checkResourceIsReachableAndReturnError:nil] || [[NSURL fileURLWithPath:@"/panguaxe.installed"] checkResourceIsReachableAndReturnError:nil]) ||
        ([[NSFileManager defaultManager] fileExistsAtPath:@"/panguaxe"] || [[NSFileManager defaultManager] fileExistsAtPath:@"/panguaxe.installed"])) {
        [dictionary setObject:@(YES) forKey:kWMJailbreakKey];
        return [dictionary copy];
    }
    // iOS 8盘古越狱会有这两个文件（只要越狱后就会有）
    if (([[NSURL fileURLWithPath:@"/xuanyuansword"] checkResourceIsReachableAndReturnError:nil] || [[NSURL fileURLWithPath:@"/xuanyuansword.installed"] checkResourceIsReachableAndReturnError:nil]) ||
        ([[NSFileManager defaultManager] fileExistsAtPath:@"/xuanyuansword"] || [[NSFileManager defaultManager] fileExistsAtPath:@"/xuanyuansword.installed"])) {
        [dictionary setObject:@(YES) forKey:kWMJailbreakKey];
        return [dictionary copy];
    }
    // 读取dylibs的image name
    
     NSString * dylibs = [UIDevice checkDylibs];

    if (dylibs.length > 0) {
        [dictionary setObject:@(YES) forKey:kWMJailbreakKey];
        return [dictionary copy];
    }
    
    return [dictionary copy];
}

//static NSString* checkDylibs()
+ (NSString *)checkDylibs
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];
    NSString *executableName = info[@"CFBundleExecutable"];
    NSMutableString *names = [NSMutableString string];
    uint32_t count = _dyld_image_count();
    for (uint32_t i = 0 ; i < count; ++i) {
        NSString *name = [[NSString alloc] initWithUTF8String:_dyld_get_image_name(i)];
        if ([name rangeOfString:@"/usr/lib/"].location != NSNotFound ||
            [name rangeOfString:@"/System/Library/"].location != NSNotFound ||
            [name rangeOfString:executableName].location != NSNotFound) {
            continue;
        }
        [names appendFormat:@"%@\n", [[NSURL fileURLWithPath:name] lastPathComponent]];
    }
    return [names copy];
}

- (NSString *)__wm_platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

// maybe json or xml config file is better
- (NSString *)__wm_platformString
{
    // @see http://theiphonewiki.com/wiki/Models
    NSString *platform = [self __wm_platform];
    
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4 (GSM Rev A)";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (Global)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (Global)";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6S";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6S Plus";

    // iPod
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    // iPad
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi Rev A)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    
    // iPad Mini
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini Retina (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini Retina (Cellular)";
    
    // Xcode iOS Simulator
    if ([platform isEqualToString:@"i386"])         return @"iOS i386 Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"iOS x86_64 Simulator";
    return platform;
}

- (NSString *)wm_platformString
{
    if (WM_UIDevice_platfrom == nil) {
        WM_UIDevice_platfrom = [self __wm_platformString];
    }
    return WM_UIDevice_platfrom;
}

+ (CGFloat)wm_getDeviceScale
{
    CGFloat scale = 1.0f;
    if (SCREEN_WIDTH > 375) {
        scale = 1.2f;
    }
    return scale;
}

+ (CGFloat)wm_getDeviceDetailScale
{
    CGFloat scale = 1.0f;
    if (SCREEN_WIDTH > 375) {
        scale = 1.29f;
    }
    return scale;
}

@end
