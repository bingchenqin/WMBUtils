//
//  UITableView+TableViewCrashFix.h
//  waimaibiz
//
//  Created by Yang Chao on 2017/2/4.
//  Copyright © 2017年 meituan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMBTableViewDelegateDeallocationTracking <NSObject>

- (void)wmb_clearDelegate;

- (void)wmb_clearDataSource;

@end

@interface UITableView (TableViewCrashFix) <WMBTableViewDelegateDeallocationTracking>

@end

@interface UICollectionView (TableViewCrashFix) <WMBTableViewDelegateDeallocationTracking>

@end
