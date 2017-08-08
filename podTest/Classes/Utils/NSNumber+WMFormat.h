//
//  NSNumberAdditions.h
//  waimai
//
//  Created by xiaoyangsheng on 12/5/13.
//  Copyright (c) 2013 meituan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (WMFormat)

- (NSString *)userFriendlyPriceString;
- (NSString *)userFriendFormatPriceString;
- (NSString *)userFriendlyNumberString;
- (NSString *)userFriendlyNumberStringWithoutGroupingSeparator;

// F**king stupid
// 106.343421 => 106343421
- (int)toServerLatitudeLongitude;
// 106343421 => 106.343421
- (double)toRealLatitudeLongitude;

- (instancetype)roundingWithMaxFractionDigits:(NSUInteger)maxFractionDigits;//四舍五入

@end
