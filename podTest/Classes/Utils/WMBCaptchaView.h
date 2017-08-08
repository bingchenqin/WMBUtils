//
//  MTCaptchaView.h
//  iMeituan
//
//  Created by sunhl on 13-11-21.
//  Copyright (c) 2013年 Meituan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTTextField.h"

typedef void (^WMBCaptchaViewReturnBlock)(NSString *verificationCode);

// borrowed from MTCaptchaView
@interface WMBCaptchaView : UIView <UITextFieldDelegate>

@property (nonatomic, strong) MTTextField *captchaTextField;
@property (nonatomic, strong) UIImageView *captchaImageView;

@property (nonatomic, copy) WMBCaptchaViewReturnBlock returnBlock;

- (void)refreshCaptchaImage;

@end
