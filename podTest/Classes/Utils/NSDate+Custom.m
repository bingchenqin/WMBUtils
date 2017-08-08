//
//  NSDate+Custom.m
//  waimai
//
//  Created by Penuel on 13-12-23.
//  Copyright (c) 2013年 meituan. All rights reserved.
//

#import "NSDate+Custom.h"
#import "WMBClient.h"
#import "WMBShippingTimeSegment.h"

@implementation NSDate (Custom)

+ (NSDate *)serverDate
{
    return [[NSDate date] dateByAddingTimeInterval:[WMBClient sharedClient].timeCalibration];
}

- (NSUInteger)dayAfterNumberOfDays:(NSInteger)numberOfDays
{
    NSDate *date = [self dateAfterDays:numberOfDays];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:date];
    return components.day;
}

- (NSString *)userFriendlyOrderDateTimeString
{
    NSString *date = [self userFriendlyOrderDateString];
    NSString *time = [self userFriendlyOrderTimeString];
    return [date stringByAppendingString:time];
}

- (NSString *)userFriendlyOrderDateString
{
    if ([self compare:[NSDate date]] == NSOrderedDescending) {
        return [[self dateStringWithFormat:MTDateFormatyyyyMMdd] stringByAppendingString:@" "];
    }
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:self toDate:[NSDate date] options:0];
    if (dayComponents.day >= 0 && dayComponents.day < 4) {
        return [@[@"今天", @"昨天", @"前天", @"大前天"] objectAtIndex:dayComponents.day];
    } else {
        NSDate *now = [NSDate date];
        
        NSDateComponents *thisWeekComponents = [gregorian components:NSCalendarUnitYearForWeekOfYear | NSCalendarUnitWeekOfYear fromDate:now];
        NSDate *beginningOfThisWeek = [gregorian dateFromComponents:thisWeekComponents];
        
        thisWeekComponents.weekOfYear -= 1;
        NSDate *beginningOfLastWeek = [gregorian dateFromComponents:thisWeekComponents];
        
        NSDateComponents *selfWeekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:self];
        NSString *weekday = [@[@"", @"日", @"一", @"二", @"三", @"四", @"五", @"六"] objectAtIndex:selfWeekdayComponents.weekday];
        
        if ([self compare:beginningOfLastWeek] == NSOrderedDescending &&
            [self compare:beginningOfThisWeek] == NSOrderedAscending) {
            return [@"上周" stringByAppendingString:weekday];
        } else if ([self compare:beginningOfThisWeek] == NSOrderedDescending) {
            return [@"本周" stringByAppendingString:weekday];
        } else {
            return [[self dateStringWithFormat:MTDateFormatyyyyMMdd] stringByAppendingString:@" "];
        }
    }
}

- (NSString *)userFriendlyOrderTimeString
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [gregorian components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:self];
    NSInteger hour = [dateComponents hour];

    if (hour <= 4) {
        return @"深夜";
    } else if (hour <= 10) {
        return @"早晨";
    } else if (hour <= 14) {
        return @"中午";
    } else if (hour <= 17) {
        return @"下午";
    } else {
        return @"晚上";
    }
}

- (BOOL)timeComponentsEarlierThanAnother:(NSDate *)anotherDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *selfComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self];
    NSInteger selfHour = [selfComponents hour];
    NSInteger selfMinute = [selfComponents minute];
    
    NSDateComponents *anotherComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:anotherDate];
    NSInteger anotherHour = [anotherComponents hour];
    NSInteger anotherMinute = [anotherComponents minute];

    if (selfHour < anotherHour || (selfHour == anotherHour && selfMinute < anotherMinute)) {
        return YES;
    } else {
        return NO;
    }
}

- (NSDate *)beginningOfTheDay
{
    //这里先使用之前的方法
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                               fromDate:self];
    NSDate *beginningOfToday = [calendar dateFromComponents:components];
    return beginningOfToday;
}

- (BOOL)withinToday
{
    NSDate *beginningOfToday = [[NSDate date] beginningOfTheDay];
    NSDate *beginningOfTomorrow = [[NSDate dateAfterDays:1] beginningOfTheDay];
    NSComparisonResult afterTodayResult = [beginningOfToday compare:self];
    NSComparisonResult beforeTomorrowResult = [beginningOfTomorrow compare:self];
    
    return ((afterTodayResult == NSOrderedAscending ||
             afterTodayResult == NSOrderedSame) &&
            beforeTomorrowResult == NSOrderedDescending);
}

- (BOOL)withinDateBeforeDays:(NSUInteger)days
{
    NSDate *beginningOfToday = [[NSDate date] beginningOfTheDay];
    NSDate *beginningOfDateBefore = [NSDate dateBeforeDays:days sinceDate:beginningOfToday];
    NSComparisonResult afterNowResult = [[NSDate date] compare:self];
    NSComparisonResult beforeOldDateResult = [beginningOfDateBefore compare:self];
    
    return ((beforeOldDateResult == NSOrderedAscending ||
             beforeOldDateResult == NSOrderedSame) &&
            afterNowResult == NSOrderedDescending);
}

- (NSDate *)dateWithMonthInterval:(NSInteger)monthInterval
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = monthInterval;
    NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
    return date;
}

- (BOOL)isSameMonthWithDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *componentsA = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:self];
    NSDateComponents *componentsB = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
    
    return componentsA.year == componentsB.year && componentsA.month == componentsB.month;
}

- (BOOL)isSameWeekWithDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *componentsA = [calendar components:NSCalendarUnitYear|NSCalendarUnitWeekOfYear fromDate:self];
    NSDateComponents *componentsB = [calendar components:NSCalendarUnitYear|NSCalendarUnitWeekOfYear fromDate:date];
    
    return componentsA.year == componentsB.year && componentsA.weekOfYear == componentsB.weekOfYear;
}

- (BOOL)isSameDayWithDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *componentsA = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    NSDateComponents *componentsB = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    return componentsA.year == componentsB.year && componentsA.month == componentsB.month && componentsA.day == componentsB.day;
}

+ (NSDate *)dateBeforeDays:(NSUInteger)days sinceDate:(NSDate *)sinceDate
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:sinceDate.timeIntervalSince1970-1*SECONDS_PER_DAY*days];
    return date;
}

- (BOOL)withinStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate
{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSCalendarUnit HHMMUnit = NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *dateComponents = [calender components:HHMMUnit fromDate:startDate toDate:self options:0];
    BOOL leftIn = dateComponents.hour > 0 || (dateComponents.hour == 0 && dateComponents.minute >= 0);
    dateComponents = [calender components:HHMMUnit fromDate:self toDate:endDate options:0];
    BOOL rightIn = dateComponents.hour > 0 || (dateComponents.hour == 0 && dateComponents.minute >= 0);
    return leftIn && rightIn;
}

+ (NSInteger)hoursBetweenStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:startDate toDate:endDate options:0].hour;
}

- (BOOL)isAfterDate:(NSDate *)date
{
    return [self compare:date] == NSOrderedDescending;
}

- (NSInteger)numberOfDaysFromToday
{
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *componets = [calender components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self];
    NSDate *beginningOfDate = [calender dateFromComponents:componets];
    NSTimeInterval interval = [beginningOfDate timeIntervalSinceDate:[self beginningOfTheDay]];
    NSInteger numberOfDays = ((NSInteger)interval)/(3600*24);
    return numberOfDays;
}

+ (NSInteger)getTimeIntervalDayCurrentDateAndLastTime:(NSString *)lastTime
{
    if ([lastTime length] == 0) {
        return 0;
    }
    
    NSDate *date = [NSDate date];
    NSTimeInterval currentTime = [date  timeIntervalSince1970];
    
    long long startSecond = [lastTime doubleValue];
    long long endSecond = currentTime;
    
    NSInteger day = (endSecond - startSecond)/(24 * 60 * 60);
    return day;
}

- (NSString *)stringFromFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}

@end
