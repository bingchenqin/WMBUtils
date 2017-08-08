//
//  UIFont+WMBAddtions.m
//  waimaibiz
//
//  Created by jianghaowen on 16/7/15.
//  Copyright © 2016年 meituan. All rights reserved.
//

#import "UIFont+WMBAddtions.h"

@implementation UIFont (WMBAddtions)

//数字等宽，用于倒计时
- (instancetype)monospacedNumbersFont
{
    NSArray *monospacedSetting = @[@{UIFontFeatureTypeIdentifierKey : @(kNumberSpacingType),
                                     UIFontFeatureSelectorIdentifierKey : @(kMonospacedNumbersSelector)}];
    UIFontDescriptor *descriptor = [self.fontDescriptor fontDescriptorByAddingAttributes:@{UIFontDescriptorFeatureSettingsAttribute : monospacedSetting}];
    return [UIFont fontWithDescriptor:descriptor size:0];
}

@end
