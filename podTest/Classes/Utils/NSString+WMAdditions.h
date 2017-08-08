//
//  NSString+WMAdditions.h
//  waimai
//
//  Created by xiaoyangsheng on 3/19/14.
//  Copyright (c) 2014 meituan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WMAdditions)

/*
 * http://p0.meituan.net/xianfu/__32611290__1370275.jpg
 * => http://p0.meituan.net/0.140/xianfu/__32611290__1370275.jpg
 */
- (NSString *)imageURLStringWithHeight:(int)height;

/*
 * http://p0.meituan.net/xianfu/__32611290__1370275.jpg
 * => http://p0.meituan.net/140.0/xianfu/__32611290__1370275.jpg
 */
- (NSString *)imageURLStringWithWidth:(int)width;
- (NSNumber *)transformIntoNumber;
- (NSUInteger)lengthOfGBKString;
- (NSString *)insertSpaceAtStartWithCount:(NSUInteger)spaceCount;
- (NSString *)appendSpaceWithCount:(NSUInteger)spaceCount;
- (NSDate *)transformIntoDateWithDateFormat:(MTDateFormat)dateFormat;
- (BOOL)stringIsAllNumbers;
- (NSString *)messageOfInvalidPhoneNumber;//若手机号合法返回空串，否则返回非法信息

// borrowed from waimai-ios for XFWMRiskMananger
+ (NSString *)getNetworkString:(id)networkString;

- (CGSize)boundingRectSizeWithFont:(UIFont *)font;
- (CGSize)boundingRectSizeWithFont:(UIFont *)font limitedWidth:(CGFloat)width;
- (CGFloat)boundingRectHeightWithFont:(UIFont *)font limitByWidth:(CGFloat)width;

- (BOOL)onlyContainsWhitespace;
- (BOOL)isValidPhoneNumber;
- (NSRange)range;
- (NSString *)singleLineString;
//正数直接加￥，负数在负号后加￥
- (NSString *)stringByInsertCurrencySymbol;
//直接在尾部加元
- (NSString *)stringByAppendChineseCurrencySymbol;

- (NSDictionary *)transformToJSONDictionary;

@end

@interface NSMutableString (URLAddition)

// 为了兼容业务方要求不encode的情况，下面这些方法不会对query进行encode操作
// 如需encode，在创建queryItemsToInsert时使用URLEncodedString
- (void)prependQueryItems:(NSArray<NSURLQueryItem *> *)queryItemsToInsert;
- (void)appendQueryItems:(NSArray<NSURLQueryItem *> *)queryItemsToInsert;
- (void)removeQueryItemsByNames:(NSArray<NSString *> *)queryNames;

@end

@interface NSAttributedString (WMBAdditions)

- (CGSize)boundingRectSizeLimitByWidth:(CGFloat)width;
- (CGFloat)boundingRectHeightLimitByWidth:(CGFloat)width;

@end
