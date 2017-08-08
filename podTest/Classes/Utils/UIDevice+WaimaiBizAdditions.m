//
//  UIDevice+WaimaiBizAdditions.m
//  waimaibiz
//
//  Created by jianghaowen on 15/3/16.
//  Copyright (c) 2015年 meituan. All rights reserved.
//

#import "UIDevice+WaimaiBizAdditions.h"
#import <AVFoundation/AVFoundation.h>

@implementation UIDevice (WaimaiBizAdditions)

- (BOOL)isOpenNotifications
{
    UIUserNotificationSettings *noticationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (!noticationSettings || !(noticationSettings.types & UIUserNotificationTypeAlert) || !(noticationSettings.types & UIUserNotificationTypeSound)) {
        return NO;
    }
    return YES;
}

- (BOOL)isOpenSoundNotification
{
    UIUserNotificationSettings *noticationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    return (noticationSettings.types & UIUserNotificationTypeSound);
}

- (BOOL)isOpenAlertNotification
{
    UIUserNotificationSettings *noticationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    return (noticationSettings.types & UIUserNotificationTypeAlert);
}

- (BOOL)isOpenBadgeNotification
{
    UIUserNotificationSettings *noticationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    return (noticationSettings.types & UIUserNotificationTypeBadge);
}

- (BOOL)isSilence
{
#if !(TARGET_IPHONE_SIMULATOR)
    if ([AVAudioSession sharedInstance].outputVolume < 0.0001) {
        return YES;
    }
#endif
    return NO;
}

- (float)audioOutputVolume
{
    return [AVAudioSession sharedInstance].outputVolume;
}

@end
