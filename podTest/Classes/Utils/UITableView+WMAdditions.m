//
//  UITableView+WMAdditions.m
//  waimaibiz
//
//  Created by aochuih on 15/6/8.
//  Copyright (c) 2015年 meituan. All rights reserved.
//

#import "UITableView+WMAdditions.h"
#import <ReactiveCocoa.h>

@implementation UITableView (WMAdditions)

+ (UITableView *)wmbTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.width = SCREEN_WIDTH;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView = nil;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return tableView;
}

- (void)scrollToEnd:(BOOL)animated
{
    [[RACScheduler mainThreadScheduler] schedule:^{
        if (IOS9_OR_LATER) {
            [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:[self numberOfRowsInSection:self.numberOfSections - 1] - 1 inSection:self.numberOfSections - 1] animated:animated scrollPosition:UITableViewScrollPositionMiddle];
        } else {
            [self setContentOffset:CGPointMake(0, MAX(0, self.contentSize.height - self.height)) animated:animated];
        }
    }];
}

@end
