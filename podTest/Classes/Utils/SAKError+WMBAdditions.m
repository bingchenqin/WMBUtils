//
//  SAKError+WMBAdditions.m
//  waimaibiz
//
//  Created by jianghaowen on 16/7/1.
//  Copyright © 2016年 meituan. All rights reserved.
//

#import "SAKError+WMBAdditions.h"

@implementation SAKError (WMBAdditions)

+ (instancetype)businiessLogicErrorWithCode:(NSInteger)code userDescription:(NSString *)description
{
    NSString *des = nil;
    if ([description isKindOfClass:[NSString class]]) {
        des = description;
    }
    return [SAKError errorWithDomain:WMBBusinessLogicErrorDomain code:code userDescription:des callstack:[NSThread callStackSymbols]];
}

@end
