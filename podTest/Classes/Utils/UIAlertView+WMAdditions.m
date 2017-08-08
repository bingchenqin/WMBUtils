//
//  UIAlertView+MTFramework.m
//  MTFramework
//
//  Created by 陈晓亮 on 13-7-6.
//  Copyright (c) 2013年 Sankuai. All rights reserved.
//

#import "UIAlertViewAdditions.h"
#import "UIAlertView+WMAdditions.h"
#import <objc/runtime.h>

static char dismissBlockKey;
static char cancelBlockKey;

@implementation UIAlertView (WMAdditions)

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title message:(NSString *)message
{
    return [self showAlertViewWithTitle:title
                                message:message
                      cancelButtonTitle:@"知道了"
                      otherButtonTitles:nil
                              dismissed:NULL
                               canceled:NULL];
}

+ (UIAlertView *)showPlainTextAlertViewWithTitle:(NSString *)title
                                         message:(NSString *)message
                               cancelButtonTitle:(NSString *)cancelButtonTitle
                               otherButtonTitles:(NSArray *)titleArray
                                       dismissed:(WMBAlertViewDismissWithObjectBlock)dismissBlock
                                        canceled:(MTAlertViewCancelBlock)cancelBlock
{
    if (!title) {
        title = @"";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    for (NSString *buttonTitle in titleArray) {
        [alertView addButtonWithTitle:buttonTitle];
    }
    alertView.delegate = alertView;
    
    @weakify(alertView)
    [alertView setCancelBlock:cancelBlock];
    [alertView setDismissBlock:^(NSInteger buttonIndex){
        @strongify(alertView)
        if ([alertView textFieldAtIndex:0]) {
            NSString *text = [alertView textFieldAtIndex:0].text;
            @wmb_safe_block(dismissBlock, buttonIndex, text);
        }
    }];
    
    [alertView show];
    return alertView;
}

- (id)cancelBlock
{
    return objc_getAssociatedObject(self, &cancelBlockKey);
}

- (void)setCancelBlock:(void (^)())cancelBlock
{
    objc_setAssociatedObject(self, &cancelBlockKey, cancelBlock, OBJC_ASSOCIATION_COPY);
}

- (id)dismissBlock
{
    return objc_getAssociatedObject(self, &dismissBlockKey);
}

- (void)setDismissBlock:(void (^)(NSInteger index))dismissBlock
{
    objc_setAssociatedObject(self, &dismissBlockKey, dismissBlock, OBJC_ASSOCIATION_COPY);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex]) {
        void (^cancelBlock)() = [self cancelBlock];
        if (cancelBlock) {
            cancelBlock();
        }
    } else {
        void (^dismissBlock)(NSInteger buttonIndex) = [self dismissBlock];
        if (dismissBlock) {
            dismissBlock(buttonIndex);
        }
    }
}


@end
