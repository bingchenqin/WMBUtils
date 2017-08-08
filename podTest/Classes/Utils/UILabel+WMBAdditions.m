//
//  UILabel+KeywordHighlight.m
//  waimaibiz
//
//  Created by jianghaowen on 15/4/20.
//  Copyright (c) 2015年 meituan. All rights reserved.
//

#import "UILabel+WMBAdditions.h"
#import "NSString+WMAdditions.h"

@implementation UILabel (KeywordHighlight)

- (NSArray *)rangesOfKeyWord:(NSString *)keyword
{
    if (!keyword || keyword.length == 0 || !self.text || self.text.length == 0) {
        return nil;
    }
    
    NSMutableArray *rangeArray = [NSMutableArray array];
    
    NSRange searchRange = NSMakeRange(0, self.text.length);
    NSRange range;
    while ((range = [self.text rangeOfString:keyword options:0 range:searchRange]).location != NSNotFound) {
        [rangeArray safeAddObject:[NSValue valueWithRange:range]];
        searchRange = NSMakeRange(NSMaxRange(range), self.text.length - NSMaxRange(range));
    }
    
    return rangeArray;
}

- (void)highlightKeyWord:(NSString *)keyword;
{
    [self highlightKeyWord:keyword withAttributes:[NSDictionary dictionaryWithObject:[UIColor yellowColor] forKey:(NSString *) NSBackgroundColorAttributeName]];
}

- (void)highlightKeyWord:(NSString *)keyword withAttributes:(NSDictionary<NSString *, id> *)attributes
{
    NSArray *rangeArray = [self rangesOfKeyWord:keyword];
    
    NSMutableAttributedString *attributedString = [self.attributedText mutableCopy];
    if (rangeArray && [rangeArray count] > 0) {
        [attributedString setAttributes:attributes range:[rangeArray[0] rangeValue]];
    }
    self.attributedText = attributedString;
}

@end

@implementation UILabel (HeightToFit)

- (CGFloat)heightToFit
{
    CGFloat textHeight;
    if (self.width > 0) {
        textHeight = [self.text boundingRectHeightWithFont:self.font limitByWidth:self.width];
        CGRect labelRect = self.frame;
        labelRect.size.height = textHeight;
        self.frame = labelRect;
    } else {
       [self sizeToFit];
        textHeight = self.height;
    }
    return textHeight;
}

@end
