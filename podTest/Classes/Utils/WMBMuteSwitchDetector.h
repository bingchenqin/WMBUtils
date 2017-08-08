//
//  WMBMuteSwitchDetector.h
//
//  Created by aochuih 1/11/16.
//  Copyright (c) 2016 meituan. All rights reserved.
//  Borrow from http://sharkfood.com/content/Developers/content/Sound%20Switch/
//

#import <Foundation/Foundation.h>

@interface WMBMuteSwitchDetector : NSObject

+ (void)checkWithCompletion:(void (^)(BOOL silent))completion;

@end
