//
//  WMBCodeScanner.h
//  waimaibiz
//
//  Created by jianghaowen on 2017/1/17.
//  Copyright © 2017年 meituan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMBScanCoverView;

@interface WMBCodeScanner : NSObject

@property (nonatomic, weak) WMBScanCoverView *coverView;
@property (nonatomic, copy) void (^didCaptureString)(NSString *);

- (instancetype)initWithCoverView:(WMBScanCoverView *)coverView;

- (void)startScanning:(void (^)())completion;
- (void)startScanning;
- (void)stopScanning;
- (void)checkCameraAndAuthorityWithCompletionHandler:(void (^)(BOOL granted))handler;
- (BOOL)setupSession;

@end
