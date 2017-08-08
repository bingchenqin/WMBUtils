//
//  SAKNetworkManager+WMBNetworkType.m
//  waimaibiz
//
//  Created by Yang Chao on 2017/3/23.
//  Copyright © 2017年 meituan. All rights reserved.
//

#import "SAKNetworkManager+WMBNetworkType.h"

@implementation SAKNetworkManager (WMBNetworkType)

- (NSString *)wmbNetworkType
{
    if (self.networkStatus == MTNetworkStatusUnavailable) {
        return @"none";
    } else if (self.networkStatus == MTNetworkStatusWiFi) {
        return @"wifi";
    } else {
        switch (self.mobileNetworkStatus) {
            case SAKMobileNetworkStatus2G:
                return @"2g";
            case SAKMobileNetworkStatus3G:
                return @"3g";
            case SAKMobileNetworkStatus4G:
                return @"4g";
            default:
                return @"unknown";
        }
    }
}

@end
