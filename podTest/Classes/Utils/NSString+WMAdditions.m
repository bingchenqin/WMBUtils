//
//  NSString+WMAdditions.m
//  waimai
//
//  Created by xiaoyangsheng on 3/19/14.
//  Copyright (c) 2014 meituan. All rights reserved.
//

#import "NSString+WMAdditions.h"
#import "NSNumber+WMFormat.h"
#import <NSDateAdditions.h>

#pragma mark - NSString+WMAdditions

@implementation NSString (WMAdditions)

- (NSString *)imageURLStringWithHeight:(int)height
{
    if ([self length] == 0) {
        return @"";
    } else {
        return [self stringByReplacingOccurrencesOfString:@"meituan.net" withString:[NSString stringWithFormat:@"meituan.net/0.%d", height]];
    }
}

- (NSString *)imageURLStringWithWidth:(int)width
{
    if ([self length] == 0) {
        return @"";
    } else {
        return [self stringByReplacingOccurrencesOfString:@"meituan.net" withString:[NSString stringWithFormat:@"meituan.net/%d.0", width]];
    }
}

- (NSNumber *)transformIntoNumber
{
    if (self.length == 0) {
        return nil;
    }
    
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    [numFormatter setNumberStyle:NSNumberFormatterNoStyle];
    NSNumber *targetNumber = [numFormatter numberFromString:self];
    return targetNumber;
}

- (NSUInteger)lengthOfGBKString
{
    NSUInteger gbkStringEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [self dataUsingEncoding:gbkStringEncoding];
    return data.length;
}

- (NSString *)insertSpaceAtStartWithCount:(NSUInteger)spaceCount
{
    return [self insertSpaceAtStart:YES spaceCount:spaceCount];
}

- (NSString *)appendSpaceWithCount:(NSUInteger)spaceCount
{
    return [self insertSpaceAtStart:NO spaceCount:spaceCount];
}

- (NSString *)insertSpaceAtStart:(BOOL)atStart spaceCount:(NSUInteger)spaceCount
{
    NSString *originalString = [self copy];
    for (int i = 0; i < spaceCount; i++) {
        if (atStart) {
            originalString = [@" " stringByAppendingString:originalString];
        } else {
            originalString = [originalString stringByAppendingString:@" "];
        }
    }
    
    return originalString;
}

- (NSDate *)transformIntoDateWithDateFormat:(MTDateFormat)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    switch (dateFormat) {
        case MTDateFormatyyyyMMddHHmm:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
        case MTDateFormatyyyyMMdd:
            [dateFormatter setDateFormat:@"yyyy.MM.dd"];
            break;
        default:
            [dateFormatter setDateFormat:@"MM-dd HH:mm"];
            break;
    }
    
    NSDate *destDate = [dateFormatter dateFromString:self];
    return destDate;
}

- (BOOL)stringIsAllNumbers
{
    NSError * __autoreleasing error;
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"^\\d+$" options:0 error:&error];
    return [regexp numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)] > 0;
}

- (NSString *)messageOfInvalidPhoneNumber
{
    if (self.length == 0) {
        return @"请输入手机号";
    } else if (self.length != 11) {
        return @"手机号不正确";
    } else {
        return @"";
    }
}

+ (NSString *)getNetworkString:(id)networkString
{
    NSString *value = nil;
    if ([networkString isKindOfClass:[NSNumber class]]) {
        value = [networkString stringValue];
    } else if ([networkString isKindOfClass:[NSNull class]]) {
        value = nil;
    } else if ([networkString isKindOfClass:[NSString class]]) {
        value = networkString;
    } else {
        value = @"";
    }
    if (!value || ![value length]) {
        value = @"";
    }
    return value;
}

- (CGSize)boundingRectSizeWithFont:(UIFont *)font
{
    return [self boundingRectSizeWithFont:font limitedWidth:MAXFLOAT];
}

- (CGSize)boundingRectSizeWithFont:(UIFont *)font limitedWidth:(CGFloat)width
{
    if (self.length <= 0) {
        return CGSizeZero;
    }
    
    CGSize __block size = CGSizeZero;
    
    if ([NSThread isMainThread]) {
        size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName : font}
                                        context:nil].size;
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:@{NSFontAttributeName : font}
                                              context:nil].size;
        });
    }
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

- (CGFloat)boundingRectHeightWithFont:(UIFont *)font limitByWidth:(CGFloat)width
{
    return [self boundingRectSizeWithFont:font limitedWidth:width].height;
}

- (BOOL)onlyContainsWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0;
}

- (BOOL)isValidPhoneNumber
{
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"^1\\d{10}$" options:0 error:nil];
    if ([regularExpression numberOfMatchesInString:self options:0 range:self.range] == 1) {
        return YES;
    }
    return NO;
}

- (NSRange)range
{
    return NSMakeRange(0, self.length);
}

- (NSString *)singleLineString
{
    return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
}

- (NSString *)stringByInsertCurrencySymbol
{
    if ([self hasPrefix:@"-"]) {
        NSString *priceString = [self substringFromIndex:1];
        return [@"-" stringByAppendingString:[@([priceString floatValue]) userFriendFormatPriceString]];
    } else {
        return [@([self floatValue]) userFriendFormatPriceString];
    }
}

- (NSString *)stringByAppendChineseCurrencySymbol
{
    if ([self hasPrefix:@"-"]) {
        NSString *priceString = [self substringFromIndex:1];
        return [@"-" stringByAppendingString:[@([priceString floatValue]) userFriendlyPriceString]];
    } else {
        return [@([self floatValue]) userFriendlyPriceString];
    }
}

- (NSDictionary *)transformToJSONDictionary
{
    if (self.length == 0) {
        return nil;
    }
    NSError *jsonError;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                                        options:NSJSONReadingAllowFragments
                                                          error:&jsonError];
    if (jsonError || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return dic;
}

@end

#pragma mark - NSMutableString+URLAddition

@implementation NSMutableString (URLAddition)

- (void)prependQueryItems:(NSArray<NSURLQueryItem *> *)queryItemsToInsert
{
    [self insertQueryItems:queryItemsToInsert atStart:YES];
}

- (void)appendQueryItems:(NSArray<NSURLQueryItem *> *)queryItemsToInsert
{
    [self insertQueryItems:queryItemsToInsert atStart:NO];
}

- (void)insertQueryItems:(NSArray<NSURLQueryItem *> *)queryItemsToInsert atStart:(BOOL)insertAtStart
{
    queryItemsToInsert = [queryItemsToInsert filter:^BOOL(NSURLQueryItem *object, NSUInteger index) {
        return object.value.length > 0;
    }];
    //remove duplicated query items
    NSArray<NSString *> *queryNames = [queryItemsToInsert sak_map:^id(NSURLQueryItem *object, NSUInteger index) {
        return object.name;
    }];
    [self removeQueryItemsByNames:queryNames];
    
    // Calculate end inset position
    NSRange hashRange = [self rangeOfString:@"#"];
    NSUInteger endPosition = (hashRange.location != NSNotFound) ? hashRange.location : self.length;

    // Calculate start insert position
    NSRange questionMarkRange = [self rangeOfString:@"?"];
    BOOL hasQuestionMark = (questionMarkRange.location != NSNotFound && questionMarkRange.location < hashRange.location);
    NSUInteger startPosition = hasQuestionMark ? (questionMarkRange.location + 1) : endPosition;

    // Compose query
    NSString *queryToInsert = [self queryStringFromQueryItems:queryItemsToInsert];
    if (hasQuestionMark) {
        if (insertAtStart) {
            queryToInsert = [queryToInsert stringByAppendingString:@"&"];
        } else {
            queryToInsert = [@"&" stringByAppendingString:queryToInsert];
        }
    } else {
        queryToInsert = [@"?" stringByAppendingString:queryToInsert];
    }

    // Insert
    [self insertString:queryToInsert atIndex:(insertAtStart ? startPosition : endPosition)];
}

- (NSString *)queryStringFromQueryItems:(NSArray<NSURLQueryItem *> *)queryItems
{
    NSMutableArray *queryStrings = [NSMutableArray array];
    for (NSURLQueryItem *item in queryItems) {
        if (item.value.length == 0) {
            continue;
        }
        NSString *queryString = [NSString stringWithFormat:@"%@=%@", item.name, item.value];
        [queryStrings safeAddObject:queryString];
    }
    return [queryStrings componentsJoinedByString:@"&"];
}

- (void)removeQueryItemsByNames:(NSArray<NSString *> *)queryNames
{
    if (queryNames.count < 1) {
        return;
    }
    NSString *template = [queryNames componentsJoinedByString:@"|"];
    NSString *pattern = [NSString stringWithFormat:@"[\?&](%@)=[^&#]*", template];
    AutoType regexp = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:nil];
    AutoType matches = [regexp matchesInString:self options:kNilOptions range:NSMakeRange(0, self.length)];
    for (NSTextCheckingResult *match in matches.reverseObjectEnumerator) {
        [self replaceCharactersInRange:match.range withString:@""];
    }
    if ([self rangeOfString:@"?"].location == NSNotFound) {
        NSRange ampersandPos = [self rangeOfString:@"&"];
        if (ampersandPos.location != NSNotFound) {
            [self replaceCharactersInRange:ampersandPos withString:@"?"];
        }
    }
}

@end

@implementation NSAttributedString (WMBAdditions)

- (CGSize)boundingRectSizeLimitByWidth:(CGFloat)width
{
    if (self.length <= 0) {
        return CGSizeZero;
    }
    
    CGSize __block size = CGSizeZero;
    
    if ([NSThread isMainThread]) {
        size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  context:nil].size;
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      context:nil].size;
        });
    }
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

- (CGFloat)boundingRectHeightLimitByWidth:(CGFloat)width
{
    return [self boundingRectSizeLimitByWidth:width].height;
}

@end
