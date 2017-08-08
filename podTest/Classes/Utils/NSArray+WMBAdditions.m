//
//  NSArray+WMBAdditions.m
//  waimaibiz
//
//  Created by jianghaowen on 16/2/25.
//  Copyright © 2016年 meituan. All rights reserved.
//

#import "NSArray+WMBAdditions.h"

@implementation NSArray (WMBAdditions)

- (nullable NSString *)jsonString
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    if (error) {
        NSAssert(error == nil, @"Convert to data failed");
        return nil;
    }
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return json;
}

@end

@implementation NSArray (Safe)

- (nullable id)wmb_objectAtIndex:(NSUInteger)index
{
    if (index >= self.count) {
        return nil;
    }
    return self[index];
}

@end

@implementation NSMutableArray (WMBAdditions)

- (void)safeAddObject:(id)object
{
    if (object) {
        [self addObject:object];
    }
}

- (void)safeRemoveObjectsAtIndexes:(NSIndexSet *)indexSet
{
    NSMutableIndexSet *mutableIndexSet = [indexSet mutableCopy];
    [mutableIndexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >= self.count) {
            [mutableIndexSet removeIndex:idx];
        }
    }];
    [self removeObjectsAtIndexes:mutableIndexSet];
}

- (void)safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (anObject && index < self.count) {
        [self replaceObjectAtIndex:index withObject:anObject];
    }
}

@end

@implementation NSArray (WMBConvenience)

- (BOOL)wmb_containsObjectPassingTest:(BOOL (^)(id _Nonnull, NSUInteger, BOOL * _Nonnull))predicate
{
    return [self indexOfObjectPassingTest:predicate] != NSNotFound;
}

@end
