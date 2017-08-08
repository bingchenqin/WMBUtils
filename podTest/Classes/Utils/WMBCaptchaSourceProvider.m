//
//  WMBCaptchaSourceProvider.m
//  waimaibiz
//
//  Created by Yang Chao on 2017/1/9.
//  Copyright © 2017年 meituan. All rights reserved.
//

#import "WMBCaptchaSourceProvider.h"

#import <SAKEnvironment/SAKEnvironment.h>
#import <SAKPerformance/SAKPerformanceNetworkErrorMonitor.h>

#import "WMBAccountCenter.h"
#import "SAKBaseModel+WaiMaiBizBackend.h"
#import "NSString+WMAdditions.h"

@implementation WMBCaptchaSourceProviderForSigningIn

- (NSURL *)generateImageCaptchaURL
{
    NSString *uuidString = [SAKEnvironment environment].UUID;
    NSString *captchaURL = [NSString stringWithFormat:@"%@/api/account/setting/imgCaptcha/refresh?appType=%@&uuid=%@", [SAKBaseModel wmbBackendURL], @(WMBAppType), uuidString];
    if (!uuidString) {
        //没有uuid，无法验证通过验证码，上报这种错误
        [[SPFErrorMonitor sharedNetworkErrorMonitor] handleNetworkBusinessErrorWithModule:NSStringFromClass([self class]) errorMessage:@"required UUID is not ready when download captcha image" URL:@"http://www.meituan.com/account/appcaptcha"];
    }
    return [NSURL URLWithString:captchaURL];
}

@end


@implementation WMBCaptchaSourceProviderForRiskControl

- (NSURL *)generateImageCaptchaURL
{
    NSString *uuidString = [SAKEnvironment environment].UUID;
    if (!uuidString) {
        //没有uuid，无法验证通过验证码，上报这种错误
        [[SPFErrorMonitor sharedNetworkErrorMonitor] handleNetworkBusinessErrorWithModule:NSStringFromClass([self class]) errorMessage:@"required UUID is not ready when download captcha image" URL:@"http://www.meituan.com/account/appcaptcha"];
    }
    WMBAccount *account = [WMBAccountCenter defaultCenter].account;
    
    NSString *basePath = [NSString stringWithFormat:@"%@/api/account/setting/imgCaptcha/get", [SAKBaseModel wmbBackendURL]];
    NSMutableString *url = basePath.mutableCopy;
    NSArray<NSURLQueryItem *> *queryItems = @[[NSURLQueryItem queryItemWithName:@"appType" value:@(WMBAppType).stringValue],
                                              [NSURLQueryItem queryItemWithName:@"token" value:account.token],
                                              [NSURLQueryItem queryItemWithName:@"acctId" value:@(account.accountID).stringValue],
                                              [NSURLQueryItem queryItemWithName:@"wmPoiId" value:@(account.poiID).stringValue],
                                              [NSURLQueryItem queryItemWithName:@"uuid" value:uuidString]];
    [url appendQueryItems:queryItems];
    
    return [NSURL URLWithString:url];
}

@end
