//
//  UITableView+TableViewCrashFix.m
//  waimaibiz
//
//  Created by Yang Chao on 2017/2/4.
//  Copyright © 2017年 meituan. All rights reserved.
//

#import "UITableView+TableViewCrashFix.h"
#import <objc/runtime.h>
#import <SAKFoundation/SAKSwizzle.h>

#define ShouldFixTableViewCrash (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_8_x_Max)

typedef NS_ENUM(NSInteger, WMBTableViewDelegateType)
{
    WMBTableViewDelegate,
    WMBTableViewDataSource
};

@interface WMBTableViewDelegateDeallocationTracker : NSObject

- (void)addTableView:(id<WMBTableViewDelegateDeallocationTracking>)tableView withDelegateType:(WMBTableViewDelegateType)type;

- (void)removeTableView:(id<WMBTableViewDelegateDeallocationTracking>)tableView withDelegateType:(WMBTableViewDelegateType)type;

@end

@implementation WMBTableViewDelegateDeallocationTracker
{
    // key: table view or collection view,
    // value: whether delegate and/or data source should be cleared when deallocated
    NSMapTable<id<WMBTableViewDelegateDeallocationTracking>, NSMutableSet<NSNumber *> *> *_map;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _map = [NSMapTable weakToStrongObjectsMapTable];
    }
    return self;
}

- (void)dealloc
{
    for (id<WMBTableViewDelegateDeallocationTracking> tableView in _map.keyEnumerator) {
        AutoType set = [_map objectForKey:tableView];
        if ([set containsObject:@(WMBTableViewDelegate)]) {
            [tableView wmb_clearDelegate];
        }
        if ([set containsObject:@(WMBTableViewDataSource)]) {
            [tableView wmb_clearDataSource];
        }
    }
}

- (void)addTableView:(id<WMBTableViewDelegateDeallocationTracking>)tableView withDelegateType:(WMBTableViewDelegateType)type
{
    AutoType set = [_map objectForKey:tableView];
    if (!set) {
        set = [NSMutableSet set];
        [_map setObject:set forKey:tableView];
    }
    [set addObject:@(type)];
}

- (void)removeTableView:(id<WMBTableViewDelegateDeallocationTracking>)tableView withDelegateType:(WMBTableViewDelegateType)type
{
    AutoType set = [_map objectForKey:tableView];
    if (set) {
        [set removeObject:@(type)];
    }
}

@end


static const void *DeallocationTrackerKey = &DeallocationTrackerKey;

FOUNDATION_STATIC_INLINE WMBTableViewDelegateDeallocationTracker *GetDeallocationTracker(id object)
{
    if (!object) {
        return nil;
    }
    
    WMBTableViewDelegateDeallocationTracker *tracker = objc_getAssociatedObject(object, DeallocationTrackerKey);
    if (!tracker) {
        tracker = [WMBTableViewDelegateDeallocationTracker new];
        objc_setAssociatedObject(object, DeallocationTrackerKey, tracker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tracker;
}


@implementation UITableView (TableViewCrashFix)

+ (void)load
{
    if (ShouldFixTableViewCrash) {
        [self sak_SwizzleMethod:@selector(setDelegate:) withMethod:@selector(wmbcf_setDelegate:) error:nil];
        [self sak_SwizzleMethod:@selector(setDataSource:) withMethod:@selector(wmbcf_setDataSource:) error:nil];
    }
}

- (void)wmb_clearDelegate
{
    [self wmbcf_setDelegate:nil];
}

- (void)wmb_clearDataSource
{
    [self wmbcf_setDataSource:nil];
}

- (void)wmbcf_setDelegate:(id<UITableViewDelegate>)delegate
{
    if (ShouldFixTableViewCrash) {
        AutoType oldTracker = GetDeallocationTracker(self.delegate);
        [oldTracker removeTableView:self withDelegateType:WMBTableViewDelegate];
        
        AutoType newTracker = GetDeallocationTracker(delegate);
        [newTracker addTableView:self withDelegateType:WMBTableViewDelegate];
        
        [self wmbcf_setDelegate:delegate];
    } else {
        self.delegate = delegate;
    }
}

- (void)wmbcf_setDataSource:(id<UITableViewDataSource>)dataSource
{
    if (ShouldFixTableViewCrash) {
        AutoType oldTracker = GetDeallocationTracker(self.dataSource);
        [oldTracker removeTableView:self withDelegateType:WMBTableViewDataSource];
        
        AutoType newTracker = GetDeallocationTracker(dataSource);
        [newTracker addTableView:self withDelegateType:WMBTableViewDataSource];
        
        [self wmbcf_setDataSource:dataSource];    
    } else {
        self.dataSource = dataSource;
    }
}

@end


@implementation UICollectionView (TableViewCrashFix)

+ (void)load
{
    if (ShouldFixTableViewCrash) {
        [self sak_SwizzleMethod:@selector(setDelegate:) withMethod:@selector(wmbcf_setDelegate:) error:nil];
        [self sak_SwizzleMethod:@selector(setDataSource:) withMethod:@selector(wmbcf_setDataSource:) error:nil];
    }
}

- (void)wmb_clearDelegate
{
    [self wmbcf_setDelegate:nil];
}

- (void)wmb_clearDataSource
{
    [self wmbcf_setDataSource:nil];
}

- (void)wmbcf_setDelegate:(id<UICollectionViewDelegate>)delegate
{
    if (ShouldFixTableViewCrash) {
        AutoType oldTracker = GetDeallocationTracker(self.delegate);
        [oldTracker removeTableView:self withDelegateType:WMBTableViewDelegate];
        
        AutoType newTracker = GetDeallocationTracker(delegate);
        [newTracker addTableView:self withDelegateType:WMBTableViewDelegate];
        
        [self wmbcf_setDelegate:delegate];       
    } else {
        self.delegate = delegate;
    }
}

- (void)wmbcf_setDataSource:(id<UICollectionViewDataSource>)dataSource
{
    if (ShouldFixTableViewCrash) {
        AutoType oldTracker = GetDeallocationTracker(self.dataSource);
        [oldTracker removeTableView:self withDelegateType:WMBTableViewDataSource];
        
        AutoType newTracker = GetDeallocationTracker(dataSource);
        [newTracker addTableView:self withDelegateType:WMBTableViewDataSource];
        
        [self wmbcf_setDataSource:dataSource];    
    } else {
        self.dataSource = dataSource;
    }
}

@end
