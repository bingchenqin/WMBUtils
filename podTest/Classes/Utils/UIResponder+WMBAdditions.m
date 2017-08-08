//
//  UIResponder+WMBAdditions.m
//  waimaibiz
//
//  Created by jianghaowen on 2016/11/29.
//  Copyright © 2016年 meituan. All rights reserved.
//

#import "UIResponder+WMBAdditions.h"

static __weak id currentFirstResponder;

@implementation UIResponder (WMBAdditions)

// http://stackoverflow.com/a/14135456/6517635
+ (instancetype)wmb_currentFirstResponder
{
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

- (void)findFirstResponder:(id)sender
{
    currentFirstResponder = self;
}

@end
