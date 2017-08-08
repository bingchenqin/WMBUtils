//
//  WMBCollectionCopy.m
//  waimaibiz
//
//  Created by liuyanming on 3/29/16.
//  Copyright © 2016 meituan. All rights reserved.
//

#import "WMBCollectionCopy.h"

@implementation NSObject (WMBCollectionCopy)

- (BOOL)isCollectionType
{
    return [self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSDictionary class]] || [self isKindOfClass:[NSSet class]];
}

@end

@implementation NSArray (WMBCollectionCopy)

- (NSMutableArray *)mutableShallowCopy
{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:self.count];

    for (id oneValue in self) {
        id oneCopy = nil;

        if (![oneValue isCollectionType]) {
            oneCopy = oneValue;
        } else if ([oneValue respondsToSelector:@selector(mutableShallowCopy)]) {
            oneCopy = [oneValue mutableShallowCopy];
        } else if ([oneValue respondsToSelector:@selector(mutableCopyWithZone:)]) {
            oneCopy = [oneValue mutableCopy];
        } else {
            oneCopy = oneValue;
        }

        [mutableArray safeAddObject:oneCopy];
    }

    return mutableArray;
}

- (NSMutableArray *)mutableDeepCopy
{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:self.count];

    for (id oneValue in self) {
        id oneCopy = nil;

        if ([oneValue respondsToSelector:@selector(mutableDeepCopy)]) {
            oneCopy = [oneValue mutableDeepCopy];
        } else if ([oneValue respondsToSelector:@selector(mutableCopyWithZone:)]) {
            oneCopy = [oneValue mutableCopy];
        } else if ([oneValue respondsToSelector:@selector(copyWithZone:)]) {
            oneCopy = [oneValue copy];
        } else {
            oneCopy = oneValue;
        }

        [mutableArray safeAddObject:oneCopy];
    }

    return mutableArray;
}

@end

@implementation NSDictionary (WMBCollectionCopy)

- (NSMutableDictionary *)mutableShallowCopy
{
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithCapacity:self.count];

    for (id key in self.allKeys) {
        id oneValue = self[key];
        id oneCopy = nil;

        if (![oneValue isCollectionType]) {
            oneCopy = oneValue;
        } else if ([oneValue respondsToSelector:@selector(mutableShallowCopy)]) {
            oneCopy = [oneValue mutableShallowCopy];
        } else if ([oneValue respondsToSelector:@selector(mutableCopyWithZone:)]) {
            oneCopy = [oneValue mutableCopy];
        } else {
            oneCopy = oneValue;
        }

        mutableDictionary[key] = oneCopy;
    }
    
    return mutableDictionary;
}

- (NSMutableDictionary *)mutableDeepCopy
{
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithCapacity:self.count];

    for (id key in self.allKeys) {
        id oneValue = self[key];
        id oneCopy = nil;

        if ([oneValue respondsToSelector:@selector(mutableDeepCopy)]) {
            oneCopy = [oneValue mutableDeepCopy];
        } else if ([oneValue respondsToSelector:@selector(mutableCopyWithZone:)]) {
            oneCopy = [oneValue mutableCopy];
        } else if ([oneValue respondsToSelector:@selector(copyWithZone:)]) {
            oneCopy = [oneValue copy];
        } else {
            oneCopy = oneValue;
        }

        mutableDictionary[key] = oneCopy;
    }

    return mutableDictionary;
}

@end
