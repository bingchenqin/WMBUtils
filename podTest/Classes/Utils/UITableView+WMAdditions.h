//
//  UITableView+WMAdditions.h
//  waimaibiz
//
//  Created by aochuih on 15/6/8.
//  Copyright (c) 2015年 meituan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (WMAdditions)

+ (UITableView *)wmbTableView;

- (void)scrollToEnd:(BOOL)animated;

@end
