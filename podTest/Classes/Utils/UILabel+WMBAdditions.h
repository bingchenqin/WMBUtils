//
//  UILabel+KeywordHighlight.h
//  waimaibiz
//
//  Created by jianghaowen on 15/4/20.
//  Copyright (c) 2015年 meituan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (KeywordHighlight)

- (void)highlightKeyWord:(NSString *)keyword;
- (void)highlightKeyWord:(NSString *)keyword withAttributes:(NSDictionary<NSString *, id> *)attributes;

@end

@interface UILabel (HeightToFit)

- (CGFloat)heightToFit;

@end
