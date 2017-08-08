//
//  WMBUtility.m
//  waimaibiz
//
//  Created by aochuih on 16/5/20.
//  Copyright © 2016年 meituan. All rights reserved.
//

#import <Foundation/Foundation.h>

CGRect WMBRectMultiply(CGRect rect, CGFloat multiplier)
{
    return CGRectMake(rect.origin.x * multiplier,
                      rect.origin.y * multiplier,
                      rect.size.width * multiplier,
                      rect.size.height * multiplier);
}