//
//  NSNumberAdditions.m
//  waimai
//
//  Created by xiaoyangsheng on 12/5/13.
//  Copyright (c) 2013 meituan. All rights reserved.
//

#import "NSNumberAdditions.h"

@implementation NSNumber (WMFormat)

- (NSString *)userFriendlyPriceString
{
    return [NSString stringWithFormat:@"%@元", [self userFriendlyNumberString]];
}

- (NSString *)userFriendFormatPriceString
{
    return [NSString stringWithFormat:@"￥%@",[self userFriendlyNumberString]];
}

- (NSString *)userFriendlyNumberString
{
    static NSNumberFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSNumberFormatter alloc] init];
        formatter.maximumFractionDigits = 2;
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return [formatter stringFromNumber:self];
}

- (NSString *)userFriendlyNumberStringWithoutGroupingSeparator
{
    static NSNumberFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSNumberFormatter alloc] init];
        formatter.maximumFractionDigits = 2;
        formatter.usesGroupingSeparator = NO;
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return [formatter stringFromNumber:self];
}

- (instancetype)roundingWithMaxFractionDigits:(NSUInteger)maxFractionDigits
{
    static NSNumberFormatter *formatter = nil;
    if (!formatter) {
        formatter = [NSNumberFormatter new];
        formatter.usesGroupingSeparator = NO;
        formatter.maximumFractionDigits = maxFractionDigits;
        formatter.roundingMode = NSNumberFormatterRoundHalfUp;
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return @([formatter stringFromNumber:self].floatValue);
}

- (int)toServerLatitudeLongitude
{
    // 四舍五入，避免把32.9358069999这样的数字错误转换成32935806
    return round([self doubleValue] * 1000000);
}

- (double)toRealLatitudeLongitude
{
    // 从服务器返回的数据可能是浮点型
    return [self doubleValue] / 1000000;
}

@end
