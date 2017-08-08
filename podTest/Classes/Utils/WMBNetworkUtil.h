//
//  WMBNetworkUtil.h
//  waimaibiz
//
//  Created by jianghaowen on 2016/11/4.
//  Copyright © 2016年 meituan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMBNetworkUtil : NSObject

+ (NSArray<NSString *> *)resolveHost:(NSString *)host;
+ (NSString *)convertSockaddrToString:(struct sockaddr_in)sockaddr;

@end
