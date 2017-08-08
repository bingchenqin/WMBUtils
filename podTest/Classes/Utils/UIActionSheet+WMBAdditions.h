//
//  UIActionSheet+WMBAdditions.h
//  waimaibiz
//
//  Created by jianghaowen on 15/5/28.
//  Copyright (c) 2015年 meituan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMBActionSheetOptions : NSObject

@property (nonatomic) BOOL showHorizonalToast;
@property (nonatomic) NSArray<NSString *> *addtionalButtonTitles;
@property (nonatomic, copy) BOOL (^addtionalHandler)(NSInteger buttonIndex);

@end

typedef void (^WMBActionSheetClickBlock)(NSInteger index);

@interface UIActionSheet (WMBAdditions) <UIActionSheetDelegate>

+ (instancetype)actionSheetWithClickBlock:(WMBActionSheetClickBlock)clickBlock
                                    title:(NSString *)title
                        cancelButtonTitle:(NSString *)cancelButtonTitle
                   destructiveButtonTitle:(NSString *)destructiveButtonTitle
                    otherButtonTitleArray:(NSArray *)buttonTitleArray;
+ (instancetype)showPhotoActionSheetWithController:(UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate> *)controller;
+ (instancetype)showPhotoActionSheetWithController:(UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate> *)controller
                                           options:(WMBActionSheetOptions *)options;
+ (instancetype)callBDActionSheet;

@end
