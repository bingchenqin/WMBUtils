//
//  NSObject+WMJSONValidator.m
//  RPJSONDemo
//
//  Created by jason on 15/4/24.
//  Copyright (c) 2015年 meituan.com. All rights reserved.
//

#import "NSObject+WMJSONValidator.h"

@interface RPValidatorPredicate(Protected)
- (void)validateValue:(id)value withKey:(NSString *)key;
- (NSMutableArray *)failedRequirementDescriptions;
@end

@implementation NSObject (WMJSONValidator)

#pragma mark - public

- (id)isArray
{
    if ([self isKindOfClass:[NSArray class]]) {
        return self;
    }
    
    return nil;
}

- (id)isDictionary
{
    if ([self isKindOfClass:[NSDictionary class]]) {
        return self;
    }
    
    return nil;
}

- (WMValidatorBlock)validatorKey
{
    WMValidatorBlock block = ^id(NSString *key, RPValidatorPredicate *predicate){
        if (!self.isDictionary) {
            return nil;
        }
        
        id jsonValue = [self valueForKey:key];
        [predicate validateValue:jsonValue withKey:key];
        
        if([[predicate failedRequirementDescriptions] count]) {
            return nil;
        }
        
        return jsonValue;
    };
    return block;
}

#pragma mark - id key


- (NSString *)stringKey:(NSString *)key
{
    WMIdKeyBlock keyBlock = [self keyBlockWithPredicate:RPValidatorPredicate.isString.isNotNull];
    NSString *string = keyBlock(key);
    return string;
}

- (NSNumber *)numberKey:(NSString *)key
{
    WMIdKeyBlock keyBlock = [self keyBlockWithPredicate:RPValidatorPredicate.isNumber.isNotNull];
    NSNumber *number = keyBlock(key);
    return number;
}

- (id)numberOrStringKey:(NSString *)key
{
    if (!self.isDictionary) {
        return nil;
    }
    
    if ([self stringKey:key] != nil || [self numberKey:key] != nil) {
        id jsonValue = [self valueForKey:key];
        return jsonValue;
    }
    return nil;
}

- (NSDictionary *)dictionaryKey:(NSString *)key
{
    WMIdKeyBlock keyBlock = [self keyBlockWithPredicate:RPValidatorPredicate.isDictionary.isNotNull];
    NSDictionary *dictionary = keyBlock(key);
    return dictionary;
}

- (NSArray *)arrayKey:(NSString *)key
{
    WMIdKeyBlock keyBlock = [self keyBlockWithPredicate:RPValidatorPredicate.isArray.isNotNull];
    NSArray *array = keyBlock(key);
    return array;
}

- (NSNumber *)booleanKey:(NSString *)key
{
    WMIdKeyBlock keyBlock = [self keyBlockWithPredicate:RPValidatorPredicate.isBoolean.isNotNull];
    NSNumber *number = keyBlock(key);
    return number;
}

- (NSNull *)nullKey:(NSString *)key
{
    WMIdKeyBlock keyBlock = [self keyBlockWithPredicate:RPValidatorPredicate.isNull];
    NSNull *null = keyBlock(key);
    return null;
}

#pragma mark - basic

#define WM_BASIC_TYPE_FUNCTION_KEY(TYPE, TYPE_METHOD) id value = [self numberOrStringKey:key];\
TYPE result = defaultValue;\
if (value) {\
    result = [value TYPE_METHOD];\
}\
return result;

- (NSInteger)integerKey:(NSString *)key
{
    return [[self numberOrStringKey:key] integerValue];
}

- (NSInteger)integerKey:(NSString *)key defaultValue:(NSInteger)defaultValue
{
    WM_BASIC_TYPE_FUNCTION_KEY(NSInteger, integerValue);
}

- (NSUInteger)unsignedIntegerKey:(NSString *)key
{
    return [[self numberOrStringKey:key] unsignedIntegerValue];
}
- (NSUInteger)unsignedIntegerKey:(NSString *)key defaultValue:(NSUInteger)defaultValue
{
    WM_BASIC_TYPE_FUNCTION_KEY(NSUInteger, unsignedIntegerValue);
}

- (double)doubleKey:(NSString *)key
{
    return [[self numberOrStringKey:key] doubleValue];
}

- (double)doubleKey:(NSString *)key defaultValue:(double)defaultValue
{
    WM_BASIC_TYPE_FUNCTION_KEY(double, doubleValue);
}

- (float)floatKey:(NSString *)key
{
    return [[self numberOrStringKey:key] floatValue];
}

- (float)floatKey:(NSString *)key defaultValue:(float)defaultValue
{
    WM_BASIC_TYPE_FUNCTION_KEY(float, floatValue);
}

- (int)intKey:(NSString *)key
{
    return [[self numberOrStringKey:key] intValue];
}

- (int)intKey:(NSString *)key defaultValue:(int)defaultValue
{
    WM_BASIC_TYPE_FUNCTION_KEY(int, intValue);
}

- (long long)longLongKey:(NSString *)key
{
    return [[self numberOrStringKey:key] longLongValue];
}

- (long long)longLongKey:(NSString *)key defaultValue:(long long)defaultValue
{
    WM_BASIC_TYPE_FUNCTION_KEY(long long, longLongValue);
}

- (BOOL)boolKey:(NSString *)key
{
    return [[self numberOrStringKey:key] boolValue];
}


- (BOOL)boolKey:(NSString *)key defaultValue:(BOOL)defaultValue
{
    WM_BASIC_TYPE_FUNCTION_KEY(BOOL, boolValue);
}

#pragma mark - helper


- (WMIdKeyBlock)keyBlockWithPredicate:(RPValidatorPredicate *)predicate
{
    WMIdKeyBlock keyBlock = ^id(NSString *key){
        return self.validatorKey(key, predicate);
    };
    return keyBlock;
}

@end

