//
//  MTChangePasswordViewController.h
//  iMeituan
//
//  Created by Chon on 13-6-26.
//  Copyright (c) 2013年 Meituan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTTextField.h"
#import "MTBaseViewController.h"

typedef void (^WMBChangePasswordCompletedBlock)();

// borrowed from MTChangePasswordViewController
@interface WMBChangePasswordViewController : MTBaseViewController

@property (nonatomic, assign) BOOL isFromSafetyVerify; //是否从安全验证过来的
@property (nonatomic, copy) NSString *userName;

@property (strong, nonatomic) MTTextField *currentPasswordTextField;
@property (strong, nonatomic) MTTextField *targetPasswordTextField;
@property (strong, nonatomic) MTTextField *repeatTargetPasswordTextField;

@property (strong, nonatomic) UIButton *submitButton;

@property (nonatomic, copy) WMBChangePasswordCompletedBlock completedBlock;
@end
