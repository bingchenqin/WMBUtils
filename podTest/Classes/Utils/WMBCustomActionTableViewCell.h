//
//  WMBCustomActionTableViewCell.h
//  waimaibiz
//
//  Created by jianghaowen on 15/4/24.
//  Copyright (c) 2015年 meituan. All rights reserved.
//

#import "WMBTableViewCell.h"

@class WMBCustomActionTableViewCell;

@protocol WMBCustomActionCellDelegate <NSObject>

@optional

- (void)editRow:(NSIndexPath *)rowIndex;
- (void)selectRow:(NSIndexPath *)rowIndex;
- (void)dragRow:(NSIndexPath *)rowIndex recognizer:(UIGestureRecognizer *)recognizer;

- (void)didTapSlideActionButtonWithTag:(NSInteger)tag rowIndex:(NSIndexPath *)rowIndex;

- (void)contextMenuWillShowInCell:(WMBCustomActionTableViewCell *)cell;
- (void)contextMenuDidShowInCell:(WMBCustomActionTableViewCell *)cell;
- (void)contextMenuWillHideInCell:(WMBCustomActionTableViewCell *)cell;
- (void)contextMenuDidHideInCell:(WMBCustomActionTableViewCell *)cell;
- (BOOL)shouldShowMenuOptionsViewInCell:(WMBCustomActionTableViewCell *)cell;

@end

@interface WMBCustomActionTableViewCell : WMBTableViewCell

@property (nonatomic, strong) NSIndexPath *rowIndex;
@property (nonatomic, assign) BOOL isInEditingMode;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIButton *sortButton;

@property (nonatomic, assign) CGFloat menuOptionsAnimationDuration;
@property (nonatomic, assign) CGFloat bounceValue;
@property (nonatomic, assign) BOOL hasShowContextMenu;
@property (nonatomic, strong) NSArray *buttonArray;

@property (nonatomic, weak) id<WMBCustomActionCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier customSlideAction:(BOOL)customSlideAction;

- (void)showEditButton:(BOOL)isEditing completion:(void(^)())completion;

- (void)transforContentToActualContentView;
- (void)setUpActionButtons;

@end
