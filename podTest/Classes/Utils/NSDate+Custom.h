//
//  NSDate+Custom.h
//  waimai
//
//  Created by Penuel on 13-12-23.
//  Copyright (c) 2013年 meituan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSDateAdditions.h>

@interface NSDate (Custom)

+ (NSDate *)serverDate;

- (NSUInteger)dayAfterNumberOfDays:(NSInteger)numberOfDays;
- (NSString *)userFriendlyOrderDateTimeString;
- (BOOL)timeComponentsEarlierThanAnother:(NSDate *)date;
- (NSDate *)beginningOfTheDay;
- (BOOL)withinToday;
- (BOOL)withinDateBeforeDays:(NSUInteger)days;
- (NSDate *)dateWithMonthInterval:(NSInteger)monthInterval;
- (BOOL)isSameMonthWithDate:(NSDate *)date;
- (BOOL)isSameWeekWithDate:(NSDate *)date;
- (BOOL)isSameDayWithDate:(NSDate *)date;
- (BOOL)withinStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate;
+ (NSInteger)hoursBetweenStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate;
- (BOOL)isAfterDate:(NSDate *)date;
//距离当天的天数
- (NSInteger)numberOfDaysFromToday;

// borrowed from waimai-ios for XFWMRiskMananger
//与当前时间相差多少天，参数为时间戳
+ (NSInteger)getTimeIntervalDayCurrentDateAndLastTime:(NSString *)lastTime;

- (NSString *)stringFromFormat:(NSString *)format;

@end
