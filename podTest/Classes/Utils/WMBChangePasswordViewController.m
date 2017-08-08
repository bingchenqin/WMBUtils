//
//  MTChangePasswordViewController.m
//  iMeituan
//
//  Created by Chon on 13-6-26.
//  Copyright (c) 2013年 Meituan.com. All rights reserved.
//

#import "WMBChangePasswordViewController.h"
#import "DSActivityView.h"
#import "UIButton+Custom.h"
#import "UIButton+WaimaiBizCustom.h"
#import "WMBAccountCenter.h"
#import "WMBAccountService.h"
#import "TKAlertCenter.h"

#define MARGIN 16

@interface WMBChangePasswordViewController () <UITextFieldDelegate>

@property (nonatomic, assign) BOOL needCurrentPassword;
@property (nonatomic, strong) WMBAccountService *accountService;
@property (nonatomic,assign) CGPoint originalContentOffset;

@end

@implementation WMBChangePasswordViewController

- (id)init
{
    self = [super init];
    if (self) {
        _userName = [WMBAccountCenter defaultCenter].account.userName;
        _accountService = [[WMBAccountService alloc] init];
    }
    return self;
}

- (void)loadView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.alwaysBounceVertical = YES;
    scrollView.contentSize = scrollView.bounds.size;
    self.view = scrollView;
}

- (void)dealloc
{
    _currentPasswordTextField.delegate = nil;
    _targetPasswordTextField.delegate = nil;
    _repeatTargetPasswordTextField.delegate = nil;
}

- (UILabel *)comaLabel
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(106, 0, 10, 46)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @":";
    return label;
}

- (UILabel *)hintLabelWithText:(NSString *)text
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 90, 46)];
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    return label;
}

- (void)setupUI
{
    CGFloat top = 14;
    if (!self.needCurrentPassword) {
        self.navigationItem.title = @"设置密码";
    } else {
        self.navigationItem.title = @"修改密码";
        self.currentPasswordTextField = [[MTTextField alloc] initWithFrame:CGRectMake(10, top, self.view.width-20, 46)];
        self.currentPasswordTextField.font = Font(14);
        self.currentPasswordTextField.placeholder = @"当前密码";
        self.currentPasswordTextField.secureTextEntry = YES;
        self.currentPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.currentPasswordTextField.insets = UIEdgeInsetsMake(0, 10, 0, 10);
        self.currentPasswordTextField.returnKeyType = UIReturnKeyNext;
        self.currentPasswordTextField.delegate = self;
        [self.view addSubview:self.currentPasswordTextField];
        top += self.currentPasswordTextField.height + 14;
        [self.currentPasswordTextField addTarget:self action:@selector(updateSubmitButtonState:) forControlEvents:UIControlEventEditingChanged];
    }
    
    self.targetPasswordTextField = [[MTTextField alloc] initWithFrame:CGRectMake(10, top, self.view.width-20, 46)];
    self.targetPasswordTextField.font = Font(14);
    self.targetPasswordTextField.placeholder = @"新密码";
    self.targetPasswordTextField.secureTextEntry = YES;
    self.targetPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.targetPasswordTextField.insets = UIEdgeInsetsMake(0, 10, 0, 10);
    self.targetPasswordTextField.returnKeyType = UIReturnKeyNext;
    self.targetPasswordTextField.delegate = self;
    [self.view addSubview:self.targetPasswordTextField];
    top += self.targetPasswordTextField.height + 14;
    [self.targetPasswordTextField addTarget:self action:@selector(updateSubmitButtonState:) forControlEvents:UIControlEventEditingChanged];
    
    
    self.repeatTargetPasswordTextField = [[MTTextField alloc] initWithFrame:CGRectMake(10, top, self.view.width-20, 46)];
    self.repeatTargetPasswordTextField.font = Font(14);
    self.repeatTargetPasswordTextField.placeholder = @"确认新密码";
    self.repeatTargetPasswordTextField.secureTextEntry = YES;
    self.repeatTargetPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.repeatTargetPasswordTextField.insets = UIEdgeInsetsMake(0, 10, 0, 10);
    self.repeatTargetPasswordTextField.returnKeyType = UIReturnKeyGo;
    self.repeatTargetPasswordTextField.delegate = self;
    [self.view addSubview:self.repeatTargetPasswordTextField];
    top += self.repeatTargetPasswordTextField.height + 14;
    
    [self.repeatTargetPasswordTextField addTarget:self action:@selector(updateSubmitButtonState:) forControlEvents:UIControlEventEditingChanged];
    
    UIButton *submitButton = [UIButton themeColorButton];
    submitButton.frame = CGRectMake(10, top, self.view.width-20, 46);
    [submitButton setTitle:@"确认提交" forState:UIControlStateNormal];
    submitButton.enabled = NO;
    self.submitButton = submitButton;
    [self.submitButton addTarget:self action:@selector(didClickSubmitButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.needCurrentPassword = YES;
    
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.currentPasswordTextField becomeFirstResponder];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (CGPointEqualToPoint(self.originalContentOffset, CGPointZero)) {
        self.originalContentOffset = ((UIScrollView *)self.view).contentOffset;
    }
}

- (void)submit
{
    NSString *currentPassword = self.currentPasswordTextField.text;
    NSString *targetPassword = self.targetPasswordTextField.text;
    NSString *repeatTargetPassword = self.repeatTargetPasswordTextField.text;
    
    if (currentPassword.length == 0 ||
        targetPassword.length == 0 ||
        repeatTargetPassword.length == 0) {
        [UIAlertView showAlertViewWithMessage:@"请填写完全后提交"];
        return;
    }
    if ([targetPassword compare:repeatTargetPassword] != NSOrderedSame) {
        [UIAlertView showAlertViewWithMessage:@"密码不一致"];
        [self.repeatTargetPasswordTextField becomeFirstResponder];
        return;
    }
    if (self.needCurrentPassword) {
        [DSBezelActivityView activityViewForView:self.view withLabel:@"正在修改密码"];
    } else {
        [DSBezelActivityView activityViewForView:self.view withLabel:@"正在设置密码"];
    }
    
    [self.accountService changePassword:currentPassword newPassword:targetPassword completion:^(BOOL succeeded, SAKError *error) {
        [DSBezelActivityView removeView];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if (!succeeded) {
            if (error.userDescription) {
                [UIAlertView showAlertViewWithMessage:error.userDescription];
            } else {
                [UIAlertView showAlertViewWithMessage:@"服务器异常"];
            }
        } else {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"密码已修改"];
            
            if ([self completedBlock]) {
                self.completedBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
#pragma clang diagnostic pop
    }];
}

- (void)updateSubmitButtonState:(id)sender
{
    if (!self.needCurrentPassword) {
        if (self.targetPasswordTextField.text.length != 0) {
            self.submitButton.enabled = YES;
        } else {
            self.submitButton.enabled = NO;
        }
    } else {
        if (self.currentPasswordTextField.text.length != 0 && self.targetPasswordTextField.text.length != 0) {
            self.submitButton.enabled = YES;
        } else {
            self.submitButton.enabled = NO;
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIScrollView *scrollView = (UIScrollView *)self.view;
    CGPoint contentOffset = self.originalContentOffset;
    if (textField == self.currentPasswordTextField) {
        // original content offset
    } else if (textField == self.targetPasswordTextField ||
               textField == self.repeatTargetPasswordTextField) {
        contentOffset = CGPointMake(0, -5);
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        scrollView.contentOffset = contentOffset;
    }];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.currentPasswordTextField]) {
        [self.targetPasswordTextField becomeFirstResponder];
    } else if ([textField isEqual:self.targetPasswordTextField]) {
        [self.repeatTargetPasswordTextField becomeFirstResponder];
    } else {
        [self submit];
    }
    return NO;
}

- (void)didClickSubmitButton
{
    [self submit];
}

@end
