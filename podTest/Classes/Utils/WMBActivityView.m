//
//  WMBActivityView.m
//  waimaibiz
//
//  Created by jianghaowen on 16/9/19.
//  Copyright © 2016年 meituan. All rights reserved.
//

#import "WMBActivityView.h"

@implementation WMBActivityView

+ (DSActivityView *)activityViewForView:(UIView *)addToView
{
    return [self activityViewForView:addToView withLabel:@""];
}

- (void)setupBackground;
{
    [super setupBackground];
    self.backgroundColor = [UIColor clearColor];
}


- (void)animateShow {}

@end
