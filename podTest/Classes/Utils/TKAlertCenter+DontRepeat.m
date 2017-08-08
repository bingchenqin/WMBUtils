//
//  TKAlertCenter+DontRepeat.m
//  waimaibiz
//
//  Created by Yang Chao on 2017/5/24.
//  Copyright © 2017年 meituan. All rights reserved.
//

#import "TKAlertCenter+DontRepeat.h"
#import <SAKFoundation/SAKSwizzle.h>

@implementation TKAlertCenter (DontRepeat)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self sak_SwizzleMethod:@selector(postAlertWithMessage:image:) withMethod:@selector(wmb_postAlertWithMessage:image:) error:nil];
    });
}

- (void)wmb_postAlertWithMessage:(NSString *)message image:(UIImage *)image
{
    NSDictionary *dict;
    if (message.length > 0) {
        if (image) {
            dict = @{@"message":message,@"image":image};
        } else {
            dict = @{@"message":message};
        }
    }
    if (!dict || [_alerts.lastObject isEqual:dict]) {
        return;
    }
    [self wmb_postAlertWithMessage:message image:image];
}

@end
