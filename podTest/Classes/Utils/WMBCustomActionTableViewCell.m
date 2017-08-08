//
//  WMBCustomActionTableViewCell.m
//  waimaibiz
//
//  Created by jianghaowen on 15/4/24.
//  Copyright (c) 2015年 meituan. All rights reserved.
//

#import "WMBCustomActionTableViewCell.h"

@interface WMBCustomActionTableViewCell () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *contextMenuView;
@property (strong, nonatomic) UIView *actualContentView;
@property (assign, nonatomic) BOOL shouldDisplayContextMenuView;
@property (assign, nonatomic) CGFloat initialTouchPositionX;

@property (assign, nonatomic) BOOL customEditingAnimationInProgress;

@end

@implementation WMBCustomActionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier customSlideAction:(BOOL)customSlideAction
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (customSlideAction) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.contextMenuView = [UIView new];
    self.contextMenuView.backgroundColor = self.contentView.backgroundColor;
    
    self.actualContentView = [UIView new];
    self.actualContentView.backgroundColor = self.contentView.backgroundColor;
    
    self.shouldDisplayContextMenuView = NO;
    self.menuOptionsAnimationDuration = 0.3;
    self.bounceValue = 30.;
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panRecognizer.delegate = self;
    [_actualContentView addGestureRecognizer:panRecognizer];
}

- (void)showEditButton:(BOOL)isEditing completion:(void(^)())completion
{
    self.isInEditingMode = isEditing;

    self.selectButton.hidden = !self.isInEditingMode;
    self.sortButton.hidden = !self.isInEditingMode;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self adjustActionButtons];
    
    self.sortButton.hidden = !self.isInEditingMode;
    self.selectButton.hidden = !self.isInEditingMode;
    
    self.selectButton.centerY = self.height / 2;
    self.sortButton.centerY = self.selectButton.centerY;
    
    self.contextMenuView.frame = self.bounds;
    self.actualContentView.frame = self.contextMenuView.frame;
    
    for (UIView *view in _buttonArray) {
        view.height = self.height;
    }
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    [self.selectButton setSelected:_isSelected];
}

- (void)setUpActionButtons
{
    for (UIView *view in _buttonArray) {
        [self.contextMenuView addSubview:view];
    }
}

#pragma mark - Public

- (void)transforContentToActualContentView
{
    for (UIView *sub in [self.contentView subviews]) {
        if (sub != _actualContentView) {
            [_actualContentView addSubview:sub];
        }
    }
    
    [self.contentView addSubview:_actualContentView];
    [self.contentView insertSubview:self.contextMenuView belowSubview:_actualContentView];
}

- (CGFloat)contextMenuWidth
{
    CGFloat width = 0;
    for (UIView *view in _buttonArray) {
        width += view.width;
    }
    return width;
}

- (void)adjustActionButtons
{
    CGFloat widthOffset = 0;
    for (UIView *view in _buttonArray) {
        view.right = self.width - widthOffset;
        widthOffset += view.width;
    }
}

- (void)setHasShowContextMenu:(BOOL)hasShowContextMenu
{
    _hasShowContextMenu = hasShowContextMenu;

    if (_hasShowContextMenu) {
        _actualContentView.left = - [self contextMenuWidth];
    } else {
        _actualContentView.left = 0;
    }
}

- (void)setMenuOptionsViewHidden:(BOOL)hidden animated:(BOOL)animated completionHandler:(void (^)(void))completionHandler
{
    if (self.selected) {
        [self setSelected:NO animated:NO];
    }
    CGRect frame = CGRectMake((hidden) ? 0 : -[self contextMenuWidth], 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    [UIView animateWithDuration:(animated) ? self.menuOptionsAnimationDuration : 0.
                          delay:0.
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         _actualContentView.frame = frame;
                     } completion:^(BOOL finished) {
                         self.shouldDisplayContextMenuView = !hidden;
                         if (!hidden) {
                             [self contextMenuDidShowInCell:self];
                         } else {
                             [self contextMenuDidHideInCell:self];
                         }
                         if (completionHandler) {
                             completionHandler();
                         }
                     }];
}

#pragma mark - Private

- (void)handlePan:(UIPanGestureRecognizer *)recognizer;
{
    if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *panRecognizer = (UIPanGestureRecognizer *)recognizer;
        
        CGPoint currentTouchPoint = [panRecognizer locationInView:_actualContentView];
        CGFloat currentTouchPositionX = currentTouchPoint.x;
        CGPoint velocity = [recognizer velocityInView:_actualContentView];
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            self.initialTouchPositionX = currentTouchPositionX;
            if (velocity.x > 0) {
                [self contextMenuWillHideInCell:self];
            } else {
                [self contextMenuWillShowInCell:self];
            }
        } else if (recognizer.state == UIGestureRecognizerStateChanged) {
            CGPoint velocity = [recognizer velocityInView:_actualContentView];
            if ((velocity.x > 0. || [self shouldShowMenuOptionsViewInCell:self])) {
                if (self.selected) {
                    [self setSelected:NO animated:NO];
                }
                CGFloat panAmount = currentTouchPositionX - self.initialTouchPositionX;
                self.initialTouchPositionX = currentTouchPositionX;
                CGFloat minOriginX = -[self contextMenuWidth] - self.bounceValue;
                CGFloat maxOriginX = 0.;
                CGFloat originX = CGRectGetMinX(_actualContentView.frame) + panAmount;
                originX = MIN(maxOriginX, originX);
                originX = MAX(minOriginX, originX);
                
                if ((originX < -0.5 * [self contextMenuWidth] && velocity.x < 0.) || velocity.x < -100) {
                    self.shouldDisplayContextMenuView = YES;
                } else if ((originX > -0.3 * [self contextMenuWidth] && velocity.x > 0.) || velocity.x > 100) {
                    self.shouldDisplayContextMenuView = NO;
                }
                
                _actualContentView.left = MIN(_actualContentView.left, originX);
            }
        } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
            [self setMenuOptionsViewHidden:!self.shouldDisplayContextMenuView animated:YES completionHandler:nil];
        }
    }
}

- (void)contextMenuWillShowInCell:(WMBCustomActionTableViewCell *)cell
{
    if ([self.delegate respondsToSelector:@selector(contextMenuWillShowInCell:)]) {
        [self.delegate contextMenuWillShowInCell:cell];
    }
    self.customEditingAnimationInProgress = YES;
}

- (void)contextMenuDidShowInCell:(WMBCustomActionTableViewCell *)cell
{
    if ([self.delegate respondsToSelector:@selector(contextMenuDidShowInCell:)]) {
        [self.delegate contextMenuDidShowInCell:cell];
    }
    self.hasShowContextMenu = YES;
    self.customEditingAnimationInProgress = NO;
}

- (void)contextMenuWillHideInCell:(WMBCustomActionTableViewCell *)cell
{
    if ([self.delegate respondsToSelector:@selector(contextMenuWillHideInCell:)]) {
        [self.delegate contextMenuWillHideInCell:cell];
    }
    self.customEditingAnimationInProgress = YES;
}

- (void)contextMenuDidHideInCell:(WMBCustomActionTableViewCell *)cell
{
    if ([self.delegate respondsToSelector:@selector(contextMenuDidHideInCell:)]) {
        [self.delegate contextMenuDidHideInCell:cell];
    }
    self.hasShowContextMenu = NO;
    self.customEditingAnimationInProgress = NO;
}

- (BOOL)shouldShowMenuOptionsViewInCell:(WMBCustomActionTableViewCell *)cell
{
    return self.customEditingAnimationInProgress;
}

#pragma mark - UIPanGestureRecognizer delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
        return (self.hasShowContextMenu ? (translation.x > 0) : (translation.x < 0)) && (fabs(translation.x) > fabs(translation.y));
    }
    return YES;
}

@end
