//
//  SAKRSACrypto+WMAdditions.m
//  BBRSACryptor-ios
//
//  Created by wangjiangjiao on 15/9/22.
//  Copyright (c) 2015年 liukun. All rights reserved.
//

#import "SAKRSACrypto+WMAdditions.h"
#import <openssl/rsa.h>
#import <openssl/pem.h>
#include <openssl/md5.h>
#include <openssl/bio.h>
#include <openssl/sha.h>
#include <string.h>
#import <CommonCrypto/CommonDigest.h>
#import "SAKError+Crypto.h"

@interface SAKRSACrypto (WMAdditionsInternal)

//for calling a method in .m file
- (RSA)rsaPublicForKey:(NSString *)keyString error:(SAKError **)error;

@end

@implementation SAKRSACrypto (WMAdditions)

- (NSData *)mwm_decrypt:(NSData *)cipherData
              publicKey:(NSString *)pubKey
{
    if(!cipherData || !pubKey){
        return nil;
    }
    if ([pubKey length]) {
        [self setValue:pubKey forKey:@"keyString"];
    }
    
    if (![self respondsToSelector:@selector(rsaPublicForKey:error:)]) {
        return nil;
    }
    SAKError *error = nil;
    RSA rsa = [self rsaPublicForKey:pubKey error:&error];
    if (error) {
        return nil;
    }
    size_t plainBufferSize = RSA_size(&rsa);
    
    uint8_t *plainBuffer = malloc(plainBufferSize * sizeof(uint8_t));
    // 计算数据段最大长度及数据段的个数
    double totalLength = [cipherData length];
    size_t blockSize = plainBufferSize;
    size_t blockCount = (size_t)ceil(totalLength / blockSize);
    NSMutableData *decryptedData = [NSMutableData data];
    
    // 分段解密
    for (int i = 0; i < blockCount; i++) {
        NSUInteger loc = i * blockSize;
        // 数据段的实际大小。最后一段可能比blockSize小。
        int dataSegmentRealSize = MIN(blockSize, totalLength - loc);
        // 截取需要解密的数据段
        NSData *dataSegment = [cipherData subdataWithRange:NSMakeRange(loc, dataSegmentRealSize)];
        
        int len = RSA_public_decrypt(dataSegmentRealSize, (const uint8_t *)[dataSegment bytes], plainBuffer, &rsa, RSA_PKCS1_PADDING);
        NSData *decryptedDataSegment = [[NSData alloc] initWithBytes:(const void *)plainBuffer length:len];
        [decryptedData appendData:decryptedDataSegment];
        
    }
    if (plainBuffer) {
        free(plainBuffer);
    }
    return decryptedData;
}

@end
