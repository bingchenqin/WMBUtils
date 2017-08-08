//
//  UIDevice+WaimaiBizAdditions.h
//  waimaibiz
//
//  Created by jianghaowen on 15/3/16.
//  Copyright (c) 2015年 meituan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (WaimaiBizAdditions)

- (BOOL)isOpenNotifications;
- (BOOL)isOpenSoundNotification;
- (BOOL)isOpenAlertNotification;
- (BOOL)isOpenBadgeNotification;

- (BOOL)isSilence;
- (float)audioOutputVolume;

@end
