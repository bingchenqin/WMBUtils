//
//  MKPolygon+WMBAdditions.m
//  waimaibiz
//
//  Created by bailu on 5/30/16.
//  Copyright © 2016 meituan. All rights reserved.
//

#import "MKPolygon+WMBAdditions.h"
#import <objc/runtime.h>

@implementation MKPolygon (WMBAdditions)

- (NSUInteger)index
{
    return [objc_getAssociatedObject(self, @selector(index)) unsignedIntegerValue];
}

- (void)setIndex:(NSUInteger)index
{
    objc_setAssociatedObject(self, @selector(index), @(index), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isValid
{
    return [objc_getAssociatedObject(self, @selector(isValid)) boolValue];
}

- (void)setIsValid:(BOOL)isValid
{
    objc_setAssociatedObject(self, @selector(isValid), @(isValid), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
