//
//  WMBDeliveryInfoUtil.m
//  waimaibiz
//
//  Created by yuxr on 2017/7/28.
//  Copyright © 2017年 meituan. All rights reserved.
//

#import "WMBDeliveryInfoUtil.h"
#import "WMBOrder.h"
#import "WMBDeliveryInfo.h"
#import "WMBDeliveryUnit.h"
#import "WMBAccountCenter.h"
#import "NSDate+Custom.h"

@implementation WMBDeliveryInfoUtil

+ (NSString *)deliverStatusTextWithOrder:(WMBOrder *)order
{
    NSString *statusText = @"";
    BOOL isHybridDelivery = [WMBAccountCenter currentPoiDetail].isHybridDeliveryTeam;
    NSString *riderTypeName = isHybridDelivery ? order.deliveryInfo.deliveryRider.typeName : @"";
    if (riderTypeName.length == 0) {
        riderTypeName = @"骑手";
    }
    if ([WMBAccountCenter currentPoiDetail].hasDeliveryTeam) {
        if ([order hasSentDeliveryBySelf]) {
            statusText = [NSString stringWithFormat:@"商家%@" , wmbProperString(@"已送餐")];
        } else {
            switch (order.deliveryInfo.status) {
                case WMBDeliveryStatusNotSent:
                    if (order.canDispatchOrderToDeliveryTeam) {
                        if (order.canDispatchOrderBySelf) {
                            statusText = @"请选择配送方式";
                        } else {
                            statusText = @"点击右侧按钮发起配送";
                        }
                    }
                    break;
                case WMBDeliveryStatusRequestSent:
                    statusText = @"等待配送员接单";
                    break;
                case WMBDeliveryStatusRequestAccepted:
                case WMBDeliveryStatusFetchOrder:
                case WMBDeliveryStatusArrivedShop:
                case WMBDeliveryStatusArrived:
                    statusText = [NSString stringWithFormat:@"%@：%@", riderTypeName, order.deliveryInfo.deliveryRider.name];
                    break;
                case WMBDeliveryStatusCancelled:
                    if (order.deliveryInfo.hasRiderInfo) {
                        statusText = [NSString stringWithFormat:@"%@：%@", riderTypeName, order.deliveryInfo.deliveryRider.name];
                    } else {
                        if (order.orderStatusType == WMBOrderStatusTypeCancelled) {
                            statusText = @"由于订单取消，取消配送";
                        } else {
                            statusText = @"已取消配送";
                        }
                    }
                    break;
                default:
                    break;
            }
        }
    }
    return statusText;
}

+ (NSDate *)waitedTimeSinceRequestSentWithOrder:(WMBOrder *)order
{
    if ([order.deliveryInfo.requestSendTime compare:[NSDate serverDate]] == NSOrderedAscending) {
        NSTimeInterval waitedTimeInterval = [[NSDate serverDate] timeIntervalSinceDate:order.deliveryInfo.requestSendTime];
        NSDate *waitedTime = [NSDate dateWithTimeIntervalSince1970:waitedTimeInterval];
        return waitedTime;
    }
    return nil;
}

+ (BOOL)needsShowWaitedTimeSinceSentRequestWithOrder:(WMBOrder *)order
{
    if ([WMBAccountCenter currentPoiDetail].hasDeliveryTeam &&
        ![order hasSentDeliveryBySelf] &&
        order.deliveryInfo.status == WMBDeliveryStatusRequestSent) {
        
        WMBPoiDetail *poiDetail = [WMBAccountCenter currentPoiDetail];
        if (!(order.isPreOrder &&
              (poiDetail.isMeituanDeliveryTeam ||
               poiDetail.onlyFastDeliveryTeam ||
               poiDetail.isHybridDeliveryTeam))) {
                  return YES;
              }
    }
    return NO;
}

+ (NSAttributedString *)formattedArrivalTimeStringWithOrder:(WMBOrder *)order
{
    if (order.isCustomerPickOrder) {
        return [self formattedUserArrivalTimeWithOrder:order];
    } else if (order.isPreOrder) {
        return [self formattedReservedArrivalTimeStringWithOrder:order];
    } else {
        return [self formattedInstantArrivalTimeStringWithOrder:order];
    }
}

#pragma mark - private method
// 到店取餐时间
+ (NSAttributedString *)formattedUserArrivalTimeWithOrder:(WMBOrder *)order
{
    // 10:00 到店
    NSString *headerPart1 = [NSString stringWithFormat:@"%@ 到店", order.expectedDeliveryTimeFormatted];
    NSDictionary *headerPart1Attr = @{ NSForegroundColorAttributeName: order.isLargeOrder ? UIColor.redColor : HEXCOLOR(0xf5a623),
                                       NSFontAttributeName: Font(14) };
    NSMutableAttributedString *attributedHeaderString = [[NSMutableAttributedString alloc] initWithString:headerPart1 attributes:headerPart1Attr];
    
    // “取餐”
    NSDictionary *headerPart2Attr = @{ NSForegroundColorAttributeName: HEXCOLOR(0x909090),
                                       NSFontAttributeName: Font(12) };
    NSAttributedString *attributedHeaderPart2 = [[NSAttributedString alloc] initWithString:@" 取餐" attributes:headerPart2Attr];
    
    // “10:00 到店 取餐”
    [attributedHeaderString appendAttributedString:attributedHeaderPart2];
    
    return attributedHeaderString;
}

// 预定送达时间
+ (NSAttributedString *)formattedReservedArrivalTimeStringWithOrder:(WMBOrder *)order
{
    // “预定明日 13:00”
    NSString *headerPart1 = [NSString stringWithFormat:@"预定%@", order.expectedDeliveryTimeFormatted];
    NSDictionary *headerPart1Attr = @{ NSForegroundColorAttributeName: order.isLargeOrder ? UIColor.redColor : HEXCOLOR(0xf5a623),
                                       NSFontAttributeName: Font(14) };
    NSMutableAttributedString *attributedHeaderString = [[NSMutableAttributedString alloc] initWithString:headerPart1 attributes:headerPart1Attr];
    
    // “送达”
    NSDictionary *headerPart2Attr = @{ NSForegroundColorAttributeName: HEXCOLOR(0x909090),
                                       NSFontAttributeName: Font(12) };
    NSAttributedString *attributedHeaderPart2 = [[NSAttributedString alloc] initWithString:@" 送达" attributes:headerPart2Attr];
    
    // “预定明日 13:00 送达”
    [attributedHeaderString appendAttributedString:attributedHeaderPart2];
    
    return attributedHeaderString;
}

// 立即送达时间
+ (NSAttributedString *)formattedInstantArrivalTimeStringWithOrder:(WMBOrder *)order
{
    // “立即送达”
    NSDictionary *headerPart1Attr = @{ NSForegroundColorAttributeName: order.isLargeOrder ? UIColor.redColor : HEXCOLOR(0xf5a623),
                                       NSFontAttributeName: Font(14) };
    NSMutableAttributedString *attributedHeaderString = [[NSMutableAttributedString alloc] initWithString:@"立即送达" attributes:headerPart1Attr];
    
    // “建议13:00送达”
    NSDate *estimatedArrivalDate = [NSDate dateWithTimeIntervalSince1970:order.estimateArrivalTime];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"HH:mm";
    NSString *timeString = [formatter stringFromDate:estimatedArrivalDate];
    NSString *headerPart2 = [NSString stringWithFormat:@" 建议%@送达", timeString];
    NSDictionary *headerPart2Attr = @{ NSForegroundColorAttributeName: order.isLargeOrder ? UIColor.redColor : HEXCOLOR(0x909090),
                                       NSFontAttributeName: Font(12) };
    NSAttributedString *attributedHeaderPart2 = [[NSAttributedString alloc] initWithString:headerPart2 attributes:headerPart2Attr];
    
    
    // “立即送达 建议13:00送达”
    [attributedHeaderString appendAttributedString:attributedHeaderPart2];
    
    return attributedHeaderString;
}

@end
