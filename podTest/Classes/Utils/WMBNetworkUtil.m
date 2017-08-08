//
//  WMBNetworkUtil.m
//  waimaibiz
//
//  Created by jianghaowen on 2016/11/4.
//  Copyright © 2016年 meituan. All rights reserved.
//

#import "WMBNetworkUtil.h"
#include <arpa/inet.h>
#include <resolv.h>

@implementation WMBNetworkUtil

+ (NSArray<NSString *> *)resolveHost:(NSString *)host
{
    /**
     *  resolve domains
     *  refer: https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/NetworkingTopics/Articles/ResolvingDNSHostnames.html
     */
    CFHostRef hostRef = CFHostCreateWithName(kCFAllocatorDefault, (__bridge CFStringRef)host);
    NSArray *addresses = nil;
    Boolean lookup = false;
    if (hostRef) {
        lookup = CFHostStartInfoResolution(hostRef, kCFHostAddresses, NULL);
        if (lookup == true) {
            addresses = (__bridge NSArray *)CFHostGetAddressing(hostRef, &lookup);
        }
        CFRelease(hostRef);
    }
    
    if (lookup == false) {
        return nil;
    }
    
    NSMutableArray<NSString *> *ipsArray = [[NSMutableArray alloc] init];
    [addresses enumerateObjectsUsingBlock: ^(NSData *obj, NSUInteger idx, BOOL *stop) {
        // obj was CFDataRef and convert to NSData by '__bridge';
        struct sockaddr_in *data = (struct sockaddr_in *)[obj bytes];
        NSString *ip = [self convertSockaddrToString:*data];
        if (ip) {
            [ipsArray safeAddObject:ip];
        }
    }];
    return ipsArray;
}

+ (NSString *)convertSockaddrToString:(struct sockaddr_in)sockaddr
{
    NSString *ipStr = nil;
    sa_family_t family = sockaddr.sin_family;
    if (family == AF_INET) { // IPV4 address
        char str[INET_ADDRSTRLEN]; // String representation of address
        inet_ntop(AF_INET, &(sockaddr.sin_addr.s_addr), str, INET_ADDRSTRLEN);
        ipStr = [NSString stringWithFormat:@"%s", str];
    } else if (family == AF_INET6) { // IPV6 address
        char str[INET6_ADDRSTRLEN]; // String representation of address
        inet_ntop(AF_INET6, &(sockaddr.sin_addr.s_addr), str, INET6_ADDRSTRLEN);
        ipStr = [NSString stringWithFormat:@"%s", str];
    }
    return ipStr;
}

@end
