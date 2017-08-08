//
//  SDWebImageDownloader+WMBCandyURL.m
//  waimaibiz
//
//  Created by Yang Chao on 2017/2/15.
//  Copyright © 2017年 meituan. All rights reserved.
//

#import "SDWebImageDownloader+WMBCandyURL.h"
#import "SAKBaseModel+WaiMaiBizBackend.h"

@implementation SDWebImageDownloader (WMBCandyURL)

+ (void)load
{
    __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [[self sharedDownloader] wmb_registerHeaderFilter];
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
        observer = nil;
    }];
}

- (void)wmb_registerHeaderFilter
{
    self.headersFilter = ^NSDictionary *(NSURL *url, NSDictionary *headers) {
        NSString *host = url.host;
        BOOL isWMBBackendURL = NO;
        if (host) {
            isWMBBackendURL = [[SAKBaseModel wmbBackendCheckSignatureURLs] wmb_containsObjectPassingTest:^BOOL(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                return [obj containsString:host];
            }];
        }
        if (isWMBBackendURL) {
            NSMutableDictionary *mutableHeaders = headers.mutableCopy ?: [NSMutableDictionary dictionary];
            [mutableHeaders addEntriesFromDictionary:WMBCandyRequestHeader()];
            return mutableHeaders;
        } else {
            return headers;
        }
    };
}

@end
