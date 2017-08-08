//
//  WMBMuteSwitchDetector.h
//
//  Created by aochuih 1/11/16.
//  Copyright (c) 2016 meituan. All rights reserved.
//  Borrow from http://sharkfood.com/content/Developers/content/Sound%20Switch/
//

#import "WMBMuteSwitchDetector.h"
#import <AudioToolbox/AudioToolbox.h>

static SystemSoundID soundId = -1;
static NSMutableArray *clientDataArray;
static NSTimeInterval startTime = -1;

void WMBSoundMuteNotificationCompletionProc(SystemSoundID  ssID, void* null) {
    if (clientDataArray.count >= 1) {
        void (^completion)(BOOL) = clientDataArray[0];
        NSTimeInterval elapsed = [NSDate timeIntervalSinceReferenceDate] - startTime;
        BOOL isMute = elapsed < 0.1; // Should have been 0.5 sec, but it seems to return much faster (0.3something)
        completion(isMute);
    }
}

@implementation WMBMuteSwitchDetector

+ (void)checkWithCompletion:(void (^)(BOOL silent))completion
{
    if (clientDataArray == nil) {
        clientDataArray = [[NSMutableArray alloc] initWithCapacity:2];
    }
    [clientDataArray removeAllObjects];
    [clientDataArray safeAddObject:[completion copy]];
    
    if (soundId == -1) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"Mute" withExtension:@"caf"];
        if (AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundId) == kAudioServicesNoError) {
            AudioServicesAddSystemSoundCompletion(soundId,
                                                  CFRunLoopGetMain(),
                                                  kCFRunLoopDefaultMode,
                                                  WMBSoundMuteNotificationCompletionProc,
                                                  NULL);
            UInt32 yes = 1;
            AudioServicesSetProperty(kAudioServicesPropertyIsUISound, sizeof(soundId), &soundId, sizeof(yes), &yes);
        } else {
            soundId = -1;
        }
    }
    startTime = [NSDate timeIntervalSinceReferenceDate];
    AudioServicesPlaySystemSound(soundId);
}

@end
