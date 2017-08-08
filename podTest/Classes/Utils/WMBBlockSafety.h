//
//  WMBBlockSafety.h
//  waimaibiz
//
//  Created by Yang Chao on 2017/2/3.
//  Copyright © 2017年 meituan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define wmb_safe_block(block,...) \
try {} @finally {} \
do { \
if (block) { \
block(__VA_ARGS__); \
} \
} while(0)
