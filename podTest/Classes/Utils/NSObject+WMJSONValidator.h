//
//  NSObject+WMJSONValidator.h
//  RPJSONDemo
//
//  Created by jason on 15/4/24.
//  Copyright (c) 2015年 meituan.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RPValidatorPredicate.h>

typedef id (^WMValidatorBlock)(NSString *key, RPValidatorPredicate *predicate);
typedef id (^WMIdKeyBlock)(NSString *key);


@interface NSObject (WMJSONValidator)

- (id)isArray;
- (id)isDictionary;

- (WMValidatorBlock)validatorKey;

- (NSString *)stringKey:(NSString *)key;
- (NSNumber *)numberKey:(NSString *)key;
- (id)numberOrStringKey:(NSString *)key;
- (NSDictionary *)dictionaryKey:(NSString *)key;
- (NSArray *)arrayKey:(NSString *)key;
- (NSNumber *)booleanKey:(NSString *)key;
- (NSNull *)nullKey:(NSString *)key;

- (NSInteger)integerKey:(NSString *)key;
- (NSInteger)integerKey:(NSString *)key defaultValue:(NSInteger)defaultValue;
- (NSUInteger)unsignedIntegerKey:(NSString *)key;
- (NSUInteger)unsignedIntegerKey:(NSString *)key defaultValue:(NSUInteger)defaultValue;
- (double)doubleKey:(NSString *)key;
- (double)doubleKey:(NSString *)key defaultValue:(double)defaultValue;
- (float)floatKey:(NSString *)key;
- (float)floatKey:(NSString *)key defaultValue:(float)defaultValue;
- (int)intKey:(NSString *)key;
- (int)intKey:(NSString *)key defaultValue:(int)defaultValue;
- (long long)longLongKey:(NSString *)key;
- (long long)longLongKey:(NSString *)key defaultValue:(long long)defaultValue;
- (BOOL)boolKey:(NSString *)key;
- (BOOL)boolKey:(NSString *)key defaultValue:(BOOL)defaultValue;

@end
