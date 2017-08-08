//
//  WMBCaptchaSourceProvider.h
//  waimaibiz
//
//  Created by Yang Chao on 2017/1/9.
//  Copyright © 2017年 meituan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WMBCaptchaSourceProvider <NSObject>

- (NSURL *)generateImageCaptchaURL;

@end

@interface WMBCaptchaSourceProviderForSigningIn : NSObject<WMBCaptchaSourceProvider>

@end

@interface WMBCaptchaSourceProviderForRiskControl : NSObject<WMBCaptchaSourceProvider>

@end
