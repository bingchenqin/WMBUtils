//
//  MTCaptchaView.m
//  iMeituan
//
//  Created by sunhl on 13-11-21.
//  Copyright (c) 2013年 Meituan.com. All rights reserved.
//

#import "WMBCaptchaView.h"
#import "MTTextField.h"
#import "UIImageView+MTAddition.h"
#import "WMBAccountCenter.h"
#import "SAKEnvironment.h"
#import "SAKBaseModel+WaiMaiBizBackend.h"

@implementation WMBCaptchaView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        UIButton *refreshButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"icon_login_refresh"] forState:UIControlStateNormal];
            button.frame = CGRectMake(0, 0, 40, 44);
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5 / 2);
            [button addTarget:self action:@selector(didClickRefreshButton) forControlEvents:UIControlEventTouchUpInside];
            button.right = self.width;
            [self addSubview:button];
            button;
        });
        
        self.captchaImageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
            imageView.right = refreshButton.left;
            imageView.centerY = self.height / 2;
            UITapGestureRecognizer *captchaImageTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshCaptchaImage)];
            imageView.userInteractionEnabled = YES;
            imageView.layer.borderColor = HEXCOLOR(0xc0c0c0).CGColor;
            imageView.layer.borderWidth = 0.5;
            [imageView addGestureRecognizer:captchaImageTapGesture];
            [self addSubview:imageView];
            imageView;
        });
        
        self.captchaTextField = ({
            MTTextField *textField = [[MTTextField alloc] initWithFrame:CGRectMake(0, 0, self.captchaImageView.left - 20, 44)];
            textField.mtStyle = MTTextFieldStyleCustom;
            textField.returnKeyType = UIReturnKeyGo;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.enablesReturnKeyAutomatically = YES;
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            textField.keyboardType = UIKeyboardTypeASCIICapable;
            textField.placeholder = @"输入图片验证码";
            textField.delegate = self;
            textField.insets = UIEdgeInsetsMake(0, 45, 0, 10);
            textField.font = Font(14);
            textField.textColor = BLACK_COLOR;
            UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_login_imgcaptcha"]];
            leftView.contentMode = UIViewContentModeScaleAspectFit;
            textField.leftView = leftView;
            textField.leftViewMode = UITextFieldViewModeAlways;
            [self addSubview:textField];
            textField;
        });
    }
    
    return self;
}

- (void)didClickRefreshButton
{
    [self refreshCaptchaImage];
}

- (void)refreshCaptchaImage
{
    _captchaTextField.text = @"";
    NSString *UUIDString = [SAKEnvironment environment].UUID;
    NSString *captchaURL = [NSString stringWithFormat:@"%@/api/account/setting/imgCaptcha/refresh?appType=%@&uuid=%@", [SAKBaseModel wmbBackendURL], @(WMBAppType), UUIDString];
    [_captchaImageView setImageWithURLAndForceDownload:[NSURL URLWithString:captchaURL]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self confirm];
    return YES;
}

- (void)confirm
{
    if ([_captchaTextField.text length] == 0) {
        [UIAlertView showAlertViewWithTitle:@"提示"
                                    message:@"请输入验证码"
                          cancelButtonTitle:@"取消"
                          otherButtonTitles:nil
                                  dismissed:NULL
                                   canceled:NULL];
    } else {
        if (self.returnBlock) {
            self.returnBlock(_captchaTextField.text);
        }
    }
}

@end
