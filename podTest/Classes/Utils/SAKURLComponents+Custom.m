//
//  SAKURLComponents+Custom.m
//  waimaibiz
//
//  Created by aochuih on 15/12/1.
//  Copyright © 2015年 meituan. All rights reserved.
//

#ifdef DEBUG

#import "SAKURLComponents+Custom.h"
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
@implementation SAKURLComponents (Custom)

+ (void)load
{
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(setQuery:)),
                                   class_getInstanceMethod([self class], @selector(customSetQuery:)));
}

- (void)customSetQuery:(NSString *)query
{
    @try {
        [self customSetQuery:query];
    }
    @catch (NSException *exception) {
        // https://s0.meituan.com/waimai_reuse_product_api/565c161b//css/page/H5/H5/fonts/icomoon.ttf?ozlngu
        // causes the SAKInvalidQueryString exception
    }
}

@end
#pragma clang diagnostic pop

#endif
