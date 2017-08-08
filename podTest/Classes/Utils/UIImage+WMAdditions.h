//
//  UIImage+WMAdditions.h
//  waimai
//
//  Created by xiaoyangsheng on 12/23/13.
//  Copyright (c) 2013 meituan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WMAdditions)

+ (UIImage *)imageWithColor:(UIColor *)color;
- (UIImage *)renderAtSize:(const CGSize)size;
- (UIImage *)maskWithImage:(const UIImage *)maskImage;
- (UIImage *)cropToSize:(CGSize)cropSize;
- (UIImage *)cropWithRect:(CGRect)rect;
- (UIImage *)resizewithScalex:(CGFloat)scalex scaley:(CGFloat)scaley;

@end
