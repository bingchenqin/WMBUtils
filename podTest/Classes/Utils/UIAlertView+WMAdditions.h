//
//  UIAlertView+MTFramework.h
//  MTFramework
//
//  Created by 陈晓亮 on 13-7-6.
//  Copyright (c) 2013年 Sankuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (WMAdditions)

typedef void (^WMBAlertViewDismissWithObjectBlock)(NSInteger buttonIndex, NSString *plainText);

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title message:(NSString *)message;

+ (UIAlertView *)showPlainTextAlertViewWithTitle:(NSString *)title
                                         message:(NSString *)message
                               cancelButtonTitle:(NSString *)cancelButtonTitle
                               otherButtonTitles:(NSArray *)titleArray
                                       dismissed:(WMBAlertViewDismissWithObjectBlock)dismissBlock
                                        canceled:(MTAlertViewCancelBlock)cancelBlock;

@end
