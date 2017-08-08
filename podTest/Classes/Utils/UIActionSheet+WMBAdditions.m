//
//  UIActionSheet+WMBAdditions.m
//  waimaibiz
//
//  Created by jianghaowen on 15/5/28.
//  Copyright (c) 2015年 meituan. All rights reserved.
//

#import "UIActionSheet+WMBAdditions.h"
#import "WMBAccountCenter.h"
#import "WMBPoiDetail.h"
#import <objc/runtime.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImagePickerController+WMBCustom.h"
#import "WMBSettingPermissionAlertView.h"

@implementation WMBActionSheetOptions
@end

static char WMBActionSheetDismissBlockKey;
static char WMBActionSheetCancelBlockKey;

@implementation UIActionSheet (WMBAdditions)

+ (instancetype)actionSheetWithClickBlock:(WMBActionSheetClickBlock)clickBlock title:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitleArray:(NSArray *)buttonTitleArray
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSString *buttonTitle in buttonTitleArray) {
        [actionSheet addButtonWithTitle:buttonTitle];
    }
    
    if (destructiveButtonTitle) {
        [actionSheet setDestructiveButtonIndex:[actionSheet addButtonWithTitle:destructiveButtonTitle]];
    }
    
    if (cancelButtonTitle) {
        [actionSheet setCancelButtonIndex:[actionSheet addButtonWithTitle:cancelButtonTitle]];
    }
    
    actionSheet.delegate = actionSheet;
    [actionSheet setClickBlock:clickBlock];
    return actionSheet;
}

- (id)clickBlock
{
    return objc_getAssociatedObject(self, &WMBActionSheetDismissBlockKey);
}

- (void)setClickBlock:(void (^)(NSInteger index))clickBlock
{
    objc_setAssociatedObject(self, &WMBActionSheetDismissBlockKey, clickBlock, OBJC_ASSOCIATION_COPY);
}

- (id)cancelBlock
{
    return objc_getAssociatedObject(self, &WMBActionSheetCancelBlockKey);
}

- (void)setCancelBlock:(void (^)(NSInteger index))cancelBlock
{
    objc_setAssociatedObject(self, &WMBActionSheetCancelBlockKey, cancelBlock, OBJC_ASSOCIATION_COPY);
}

#pragma mark - photo & camera

+ (instancetype)showPhotoActionSheetWithController:(UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> *)controller
{
    return [self showPhotoActionSheetWithController:controller options:nil];
}

+ (instancetype)showPhotoActionSheetWithController:(UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate> *)controller options:(WMBActionSheetOptions *)options
{
    void (^clickBlock)(NSInteger) = ^(NSInteger buttonIndex) {
        if (options.addtionalHandler && options.addtionalHandler(buttonIndex)) {
            return;
        }
        
        UIImagePickerController *imagePickerViewController = [UIImagePickerController createCustomImagePickerViewController];
        imagePickerViewController.delegate = controller;
        imagePickerViewController.allowsEditing = NO;
        if (buttonIndex == 0) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied) {
                    [WMBSettingPermissionAlertView showAlertViewWithPermissionType:WMBSettingPermissionTypeCamera];
                    return;
                }
                
                imagePickerViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
                [imagePickerViewController showHorizonalToast:options ? options.showHorizonalToast : NO];
            } else {
                [UIAlertView showAlertViewWithMessage:@"请检查您的摄像头是否可用"];
                return;
            }
        } else if (buttonIndex == 1) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
                    [WMBSettingPermissionAlertView showAlertViewWithPermissionType:WMBSettingPermissionTypeAlbum];
                    return;
                }
                
                imagePickerViewController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            } else {
                [UIAlertView showAlertViewWithMessage:@"请检查您的照片是否可用"];
                return;
            }
        }
        
        [controller presentViewController:imagePickerViewController animated:YES completion:nil];
    };
    
    
    NSArray *titles = [@[@"拍照", @"从照片选择"] arrayByAddingObjectsFromArray:options.addtionalButtonTitles];
    UIActionSheet *actionSheet = [UIActionSheet actionSheetWithClickBlock:clickBlock title:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitleArray:titles];
    [actionSheet showInView:controller.view];
    return actionSheet;
}

#pragma mark call BD

+ (instancetype)callBDActionSheet
{
    WMBPoiDetail *poiDetail = [WMBAccountCenter defaultCenter].account.currentPoiDetail;
    NSString *actionSheetTitle;
    NSString *phone;
    if (poiDetail && [poiDetail.bdPhone length] > 0) {
        if ([poiDetail.bdFirstName length] > 0) {
            actionSheetTitle = [NSString stringWithFormat:@"我的专属业务经理：%@经理", poiDetail.bdFirstName];
        } else {
            actionSheetTitle = @"我的专属业务经理";
        }
        phone = poiDetail.bdPhone;
    } else {
        actionSheetTitle = @"没有查到业务经理，电话将转给客服";
        phone = WM_CUSTOMER_SERVICE_PHONE;
    }
    
    void (^clickBlock)(NSInteger) = ^(NSInteger buttonIndex){
        if (buttonIndex == 0) {
            WMBPoiDetail *poiDetail = [WMBAccountCenter defaultCenter].account.currentPoiDetail;
            NSString *phone = [poiDetail.bdPhone length] > 0 ? poiDetail.bdPhone : WM_CUSTOMER_SERVICE_PHONE;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phone]]];
        }
    };
    
    UIActionSheet *actionSheet = [UIActionSheet actionSheetWithClickBlock:clickBlock title:actionSheetTitle cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitleArray:@[phone]];
    return actionSheet;
}

#pragma mark UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        void (^cancelBlock)(NSInteger index) = [self cancelBlock];
        if (cancelBlock) {
            cancelBlock(buttonIndex);
        }
        return;
    }
    
    void (^clickBlock)(NSInteger index) = [self clickBlock];
    if (clickBlock) {
        clickBlock(buttonIndex);
    }
}

@end
