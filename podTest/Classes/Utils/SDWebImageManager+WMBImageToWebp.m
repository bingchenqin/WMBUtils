
//
//  SDWebImageManager+WMBImageToWebp.m
//  waimaibiz
//
//  Created by qinbingchen on 28/07/2017.
//  Copyright © 2017 meituan. All rights reserved.
//

#import "SDWebImageManager+WMBImageToWebp.h"
#import "SAKSwizzle.h"

@implementation SDWebImageManager (WMBImageToWebp)

+ (void)load
{
    [self sak_SwizzleMethod:@selector(downloadImageWithURL:options:progress:completed:) withMethod:@selector(WMBDownloadImageWithUrl:options:progress:completed:) error:nil];
}

- (id <SDWebImageOperation>)WMBDownloadImageWithUrl:(NSURL *)url options:(SDWebImageOptions *)options progress:(SDWebImageDownloaderProgressBlock*)progressBlock completed:(SDWebImageCompletionWithFinishedBlock *)completedBlock
{
    if ([url isKindOfClass:[NSString class]]) {
        url= [NSURL URLWithString:(NSString *)url];
    }
    if (![url isKindOfClass:[NSURL class]]) {
        url= nil;
    }
    BOOL isInP1Domain= [url.host rangeOfString:@"p1.meituan.net"].location != NSNotFound;
    BOOL isInP0Domain= [url.host rangeOfString:@"p0.meituan.net"].location != NSNotFound;
    BOOL isInDomain= isInP0Domain || isInP1Domain;
    BOOL isNotWebP= ![url.absoluteString hasSuffix:@".webp"];
    BOOL needConvert=  url && isInDomain && isNotWebP;
    if (needConvert) {
        NSString *newURLStr= [url.absoluteString stringByAppendingString:@".webp"];
        url= [NSURL URLWithString:newURLStr];
    }
    return [self WMBDownloadImageWithUrl:url options:options progress:progressBlock completed:completedBlock];
}

@end
