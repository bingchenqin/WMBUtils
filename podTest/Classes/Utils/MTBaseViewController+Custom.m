//
//  MTBaseViewController+Custom.m
//  imeituan
//
//  Created by 陈晓亮 on 13-6-5.
//  Copyright (c) 2013年 Meituan.com. All rights reserved.
//

#import "MTBaseViewController+Custom.h"
#import <objc/runtime.h>

#define TITLE_VIEW_TAG 1100
#define TITLE_LABEL_TAG 1101
#define SUBTITLE_LABEL_TAG 1102

@implementation MTBaseViewController (Custom)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(defaultBackgroundColor)),
                                   class_getInstanceMethod([self class], @selector(customDefaultBackgroundColor)));
}

- (void)enableTitle:(NSString *)title andSubTitle:(NSString *)subTitle
{
    UILabel *titleView = [UILabel labelWithFrame:CGRectMake(0, 0, 170, 44) font:Font(14) andTextColor:HEXCOLOR(0xFFFFFF)];
    titleView.tag = TITLE_VIEW_TAG;
    titleView.autoresizesSubviews = YES;

    UILabel *titleLabel = [UILabel labelWithFrame:CGRectMake(0, 2, titleView.width, 24) font:BoldFont(20) andTextColor:HEXCOLOR(0xFFFFFF)];
    titleLabel.tag = TITLE_LABEL_TAG;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    [titleView addSubview:titleLabel];

    UILabel *subTitleLabel = [UILabel labelWithFrame:CGRectMake(0, 24, titleView.width, 20) font:Font(12) andTextColor:HEXCOLOR(0xFFFFFF)];
    subTitleLabel.tag = SUBTITLE_LABEL_TAG;
    subTitleLabel.adjustsFontSizeToFitWidth = YES;
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.text = subTitle;
    [titleView addSubview:subTitleLabel];

    self.navigationItem.titleView = titleView;
}

- (void)updateTitle:(NSString *)title andSubTitle:(NSString *)subTitle
{
    if (self.navigationItem.titleView.tag == TITLE_VIEW_TAG) {
        UILabel *titleView = (UILabel *)self.navigationItem.titleView;
        UILabel *titleLabel = (UILabel *)[titleView viewWithTag:TITLE_LABEL_TAG];
        titleLabel.text = title;
        UILabel *subtitleLabel = (UILabel *)[titleView viewWithTag:SUBTITLE_LABEL_TAG];
        subtitleLabel.text = subTitle;
    } else {
        [self enableTitle:title andSubTitle:subTitle];
    }
}

- (UIColor *)customDefaultBackgroundColor
{
    return HEXCOLOR(0xFFFFFF);
}

- (BOOL)rightSwipeEnabled
{
    return YES;
}

- (void)resetState
{
    // do nothing
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
