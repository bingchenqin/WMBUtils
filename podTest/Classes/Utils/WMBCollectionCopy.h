//
//  WMBCollectionCopy.h
//  waimaibiz
//
//  Created by liuyanming on 3/29/16.
//  Copyright © 2016 meituan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (WMBCollectionCopy)

- (BOOL)isCollectionType;

@end

@interface NSArray (WMBCollectionCopy)

- (NSMutableArray *)mutableShallowCopy;
- (NSMutableArray *)mutableDeepCopy;

@end

@interface NSDictionary (WMBCollectionCopy)

- (NSMutableDictionary *)mutableShallowCopy;
- (NSMutableDictionary *)mutableDeepCopy;

@end
