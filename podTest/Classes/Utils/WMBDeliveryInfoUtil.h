//
//  WMBDeliveryInfoUtil.h
//  waimaibiz
//
//  Created by yuxr on 2017/7/28.
//  Copyright © 2017年 meituan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WMBOrder;

@interface WMBDeliveryInfoUtil : NSObject

+ (NSString *)deliverStatusTextWithOrder:(WMBOrder *)order;
+ (NSDate *)waitedTimeSinceRequestSentWithOrder:(WMBOrder *)order;
+ (BOOL)needsShowWaitedTimeSinceSentRequestWithOrder:(WMBOrder *)order;
+ (NSAttributedString *)formattedArrivalTimeStringWithOrder:(WMBOrder *)order;

@end
