//
//  SAKError+WMBAdditions.h
//  waimaibiz
//
//  Created by jianghaowen on 16/7/1.
//  Copyright © 2016年 meituan. All rights reserved.
//

#import "SAKError.h"

#define WMBBusinessLogicErrorDomain @"com.meituan.waimai.e.errordomain.businesslogic"

@interface SAKError (WMBAdditions)

+ (nullable instancetype)businiessLogicErrorWithCode:(NSInteger)code userDescription:(nullable NSString *)description;

@end
