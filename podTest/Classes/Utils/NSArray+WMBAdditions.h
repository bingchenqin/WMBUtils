//
//  NSArray+WMBAdditions.h
//  waimaibiz
//
//  Created by jianghaowen on 16/2/25.
//  Copyright © 2016年 meituan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (WMBAdditions)

- (nullable NSString *)jsonString;

@end

@interface NSArray<ObjectType> (Safe)

- (nullable ObjectType)wmb_objectAtIndex:(NSUInteger)index;

@end

@interface NSMutableArray<ObjectType> (WMBAdditions)

- (void)safeAddObject:(nullable id)object;
- (void)safeRemoveObjectsAtIndexes:(NSIndexSet *)indexSet;
- (void)safeReplaceObjectAtIndex:(NSUInteger)index withObject:(ObjectType)anObject;

@end

@interface NSArray<ObjectType> (WMBConvenience)

- (BOOL)wmb_containsObjectPassingTest:(BOOL (NS_NOESCAPE ^)(ObjectType obj, NSUInteger idx, BOOL *stop))predicate;

@end

NS_ASSUME_NONNULL_END
