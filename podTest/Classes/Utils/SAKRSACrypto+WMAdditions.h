//
//  SAKRSACrypto+WMAdditions.h
//  BBRSACryptor-ios
//
//  Created by wangjiangjiao on 15/9/22.
//  Copyright (c) 2015年 liukun. All rights reserved.
//

#import "SAKRSACrypto.h"

@interface SAKRSACrypto (WMAdditions)

/*!
 @function   decrypt:key
 @param      data      待解密的二进制流
 @param      pubKey    公钥key
 @return               解密后的数据，如果为nil,则解密失败
 */
- (NSData *)mwm_decrypt:(NSData *)data publicKey:(NSString *)pubKey;

@end
