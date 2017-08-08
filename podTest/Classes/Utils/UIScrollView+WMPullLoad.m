//
//  UIScrollView+WMPullLoad.m
//  UIScrollViewCatergory
//
//  Created by Aslan on 27/6/14.
//  Copyright (c) 2014 meituan. All rights reserved.
//

#import "UIScrollView+WMPullLoad.h"
#import <objc/runtime.h>
#import <SAKPortal/SAKWeakObjectContainer.h>

#define LOADVIEW_HEIGHT         60.0f

static const char *pullDelegate = "pullDelegate";
static const char *interceptor = "interceptor";
static const char *canPullUp = "canPullUp";
static const char *canPullDown = "canPullDown";
static const char *scrollInsetBottomKey = "scrollInsetBottomKey";
static const char *scrollInsetTopKey = "scrollInsetTopKey";

//加载界面状态
typedef enum {
    PullStateNormal = 0,            //正常状态
    PullStateUpPulling = 1,         //上拉状态
    PullStateUpHitTheEnd = 2,       //上拉越界状态
    PullStateDownPulling = 3,       //下拉状态
    PullStateDownHitTheEnd = 4,     //下拉越界状态
    PullStateLoading = 5,           //加载状态
} PullState;


@interface PullLoadActivityView: UIView

- (void)startAnimating;
- (void)stopAnimating;

@end

@implementation PullLoadActivityView {
    UIImageView *_centerImageView;
    UIImageView *_circleImageView;
    NSTimer *_animationTimer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *circleImage = [UIImage imageNamed:@"icon_refresh_circle"];
        self.width = circleImage.size.width;
        self.height = circleImage.size.height;

        UIImage *centerImage = [UIImage imageNamed:@"icon_refresh_center"];
        _centerImageView = [[UIImageView alloc] initWithImage:centerImage];
        _centerImageView.center = self.center;
        [self addSubview:_centerImageView];
        
        _circleImageView = [[UIImageView alloc] initWithImage:circleImage];
        _centerImageView.center = self.center;
        [self addSubview:_circleImageView];
    }
    return self;
}

- (void)startAnimating
{
    if (!_animationTimer) {
        _animationTimer = [NSTimer timerWithTimeInterval:0.2f target:self selector:@selector(resumeAnimating) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_animationTimer forMode:NSRunLoopCommonModes];
    }
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 * 1 * 0.2];
    rotationAnimation.duration = 0.1f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 100;
    
    [_circleImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)resumeAnimating
{
    [self startAnimating];
}

- (void)stopAnimating
{
    [_animationTimer invalidate];
    _animationTimer = nil;
    [_circleImageView.layer removeAllAnimations];
}

@end

/****************************************************************************/
//上拉下拉视图
@interface PullRefreshView : UIView

@property PullState state;

- (void)setTextColor:(UIColor*)color;
//根据加载状态更新加载界面
- (void)refreshDateLabel:(LoadState)loadState;
@end

@implementation PullRefreshView
{
    UILabel *_stateLabel;
    UILabel *_dateLabel;
    UIImageView *_arrowView;
    PullLoadActivityView *_activityView;
    PullState state;
}

@dynamic state;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = HEXCOLOR(0xefeff4);
        _stateLabel = [[UILabel alloc] init ];
        _stateLabel.font = [UIFont fontWithName:@"ArialMT" size:14.f];
        _stateLabel.textColor = [UIColor colorWithRed:181.0/255.0 green:181.0/255.0 blue:181.0/255.0 alpha:1.0];
        _stateLabel.textAlignment = NSTextAlignmentLeft;
        _stateLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_stateLabel];

        _activityView = [[PullLoadActivityView alloc] init];
        [self addSubview:_activityView];
    }
    return self;
}

//设置加载状态
- (void)setState:(PullState)pullstate
{
    state = pullstate;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    
    switch (state) {
        case PullStateNormal:
        {
            [_activityView stopAnimating];
        }
            break;
        case PullStateUpPulling:
            _stateLabel.textAlignment = NSTextAlignmentCenter;
            _stateLabel.frame = CGRectMake(0, 15, self.frame.size.width, 20);
            _stateLabel.text = @"努力加载中...";
            _activityView.hidden = YES;
            break;
        case PullStateDownHitTheEnd:
            _stateLabel.text = @"松开即可更新...";
            break;
        case PullStateUpHitTheEnd:
            _arrowView.transform = CGAffineTransformIdentity;
            break;
        case PullStateDownPulling:
            _activityView.hidden = NO;
            _stateLabel.textAlignment = NSTextAlignmentLeft;
            _activityView.frame = CGRectMake(self.width / 2 - 42, self.frame.size.height - 40.0f, _activityView.width, _activityView.height);
            _stateLabel.frame = CGRectMake(_activityView.right + 8, self.frame.size.height - 35, self.frame.size.width, 15);
            _stateLabel.text = @"下拉刷新...";
            break;
        case PullStateLoading:
        {
            UIScrollView *scrollView = (UIScrollView*)self.superview;
            if (scrollView.contentOffset.y < 0) {
                UIEdgeInsets insets = scrollView.contentInset;
                insets = UIEdgeInsetsMake(insets.top + LOADVIEW_HEIGHT, 0, insets.bottom, 0);
                [scrollView setContentInset:insets];
            } else {
                UIEdgeInsets insets = scrollView.contentInset;
                insets = UIEdgeInsetsMake(insets.top, 0, insets.bottom+LOADVIEW_HEIGHT, 0);
                [scrollView setContentInset:insets];
            }
            _stateLabel.text = @"加载中...";
            [_activityView startAnimating];
        }
            break;
        default:
            break;
    }
    [UIView commitAnimations];
}

- (PullState)state
{
    return state;
}

- (void)setTextColor:(UIColor*)color
{
    _stateLabel.textColor = color;
}

- (void)refreshDateLabel:(LoadState)loadState
{
    NSString *dateKey = nil;
    NSString *text = nil;
    if (loadState == PullUpLoadState) {
        dateKey = @"PullUp_LastRefresh";
        text = @"最后加载";
    } else {
        dateKey = @"PullDown_LastRefresh";
        text = @"最后更新";
    }
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    _dateLabel.text = [NSString stringWithFormat:@"%@: %@",text,[formatter stringFromDate:date]];
    
    [[NSUserDefaults standardUserDefaults] setObject:_dateLabel.text forKey:dateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
/****************************************************************************/


/****************************************************************************/
//函数拦截器，用于拦截UIScrollView的代理函数调用
@interface Interceptor:NSObject

@property (nonatomic, assign) id receiver;
@property (nonatomic, assign) UIScrollView *scrollView;
@property (strong, nonatomic) PullRefreshView *upView;
@property (strong, nonatomic) PullRefreshView *downView;

@end
/****************************************************************************/

/****************************************************************************/
//扩展私有函数，本扩展类内部使用
@interface UIScrollView (Private)
//函数拦截器
@property (assign, nonatomic) Interceptor *interceptor;
//根据加载状态回调外部函数
- (void)loadWithState:(LoadState)state;
@end

@implementation UIScrollView (Private)
@dynamic interceptor;

- (void)setInterceptor:(NSString *)messageInterceptor
{
    //使用associative来扩展属性
    objc_setAssociatedObject(self, &interceptor, messageInterceptor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString*)interceptor
{
    //获取属性
    return objc_getAssociatedObject(self, &interceptor);
}

- (void)loadWithState:(LoadState)state
{
    if (self.pullDelegate && [self.pullDelegate respondsToSelector:@selector(scrollView:loadWithState:)]) {
        [self.pullDelegate scrollView:self loadWithState:state];
    }
}

@end
/****************************************************************************/

/****************************************************************************/
@implementation Interceptor

//快速转发函数，在此实现函数拦截，实现自己功能后再转发给原代理
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    NSString *selectorName = NSStringFromSelector(aSelector);
    
    if ([selectorName isEqualToString:NSStringFromSelector(@selector(scrollViewDidScroll:))]) {
        CGFloat viewOffset = _scrollView.contentOffset.y + _scrollView.frame.size.height - _scrollView.contentSize.height;
        //当scrollView上拉到内容完全显示还继续上拉，并且内容视图高度大于视图高度时，上拉界面设为上拉状态
        if (viewOffset > - LOADVIEW_HEIGHT && _scrollView.contentSize.height > _scrollView.frame.size.height) {
            if (_scrollView.canPullUp && _downView.state == PullStateNormal) {
                //上拉在上拉状态进行上拉界面位置设定，这个时候scrollView的contentSize已经确定
                [_downView setState:PullStateUpPulling];
                _downView.hidden = NO;
                CGRect frame = CGRectMake(0, _scrollView.contentSize.height, _scrollView.frame.size.width, 300);
                _downView.frame = frame;
            }
        }
        //当上拉越过限定高度并且上拉界面处于上拉状态，将上拉界面设置为越界状态
        if (viewOffset > 0 && _downView.state == PullStateUpPulling) {
            [_downView setState:PullStateUpHitTheEnd];
        }
        //当上拉返回限定高度并且上拉界面处于越界状态，将上拉界面设置为上拉状态
        else if (viewOffset > - LOADVIEW_HEIGHT && viewOffset < 0 && _downView.state == PullStateUpHitTheEnd) {
            [_downView setState:PullStateUpPulling];
        }
        //下拉原理同上
        viewOffset = _scrollView.contentOffset.y;
        if (viewOffset < 0) {
            if (_scrollView.canPullDown && _upView.state == PullStateNormal && _scrollView.tracking) {
                [_upView setState:PullStateDownPulling];
            }
        }
        if (viewOffset < - LOADVIEW_HEIGHT - _scrollView.scrollInsetTop && _upView.state == PullStateDownPulling) {
            [_upView setState:PullStateDownHitTheEnd];
        }
        else if (viewOffset > - LOADVIEW_HEIGHT - _scrollView.scrollInsetTop && viewOffset < 0 && _upView.state == PullStateDownHitTheEnd) {
            if (_scrollView.tracking) {
                [_upView setState:PullStateDownPulling];
            } else {
                [_upView setState:PullStateNormal];
            }
        } else if (viewOffset > - LOADVIEW_HEIGHT - _scrollView.scrollInsetTop) {
            if (_scrollView.tracking) {
                [_upView setState:PullStateDownPulling];
            } else {
                [_upView setState:PullStateNormal];
            }
        }
    }
    //拖拽放开根据位置进行是否刷新操作
    if ([selectorName isEqualToString:NSStringFromSelector(@selector(scrollViewDidScroll:))]) {
        CGFloat viewOffset = _scrollView.contentOffset.y + _scrollView.frame.size.height - _scrollView.contentSize.height;
        if (viewOffset > 0 && _downView.state == PullStateUpHitTheEnd) {
            [_downView setState:PullStateLoading];
            [_scrollView loadWithState:PullUpLoadState];
        }
    }
    if ([selectorName isEqualToString:NSStringFromSelector(@selector(scrollViewDidEndDragging:willDecelerate:))]) {
        CGFloat viewOffset = _scrollView.contentOffset.y;;
        if (viewOffset < - LOADVIEW_HEIGHT - _scrollView.scrollInsetTop && _upView.state == PullStateDownHitTheEnd) {
            [_upView setState:PullStateLoading];
            [_scrollView loadWithState:PullDownLoadState];
        }
    }
    
    if ([_receiver respondsToSelector:aSelector]) {
        return _receiver;
    }
    if ([_scrollView respondsToSelector:aSelector]) {
        return _scrollView;
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([_receiver respondsToSelector:aSelector]) {
        return YES;
    }
    if ([_scrollView respondsToSelector:aSelector]) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}

@end
/****************************************************************************/

/****************************************************************************/
@implementation UIScrollView (WMPullLoad)

@dynamic canPullUp;
@dynamic canPullDown;
@dynamic pullDelegate;
@dynamic scrollInsetBottom;
@dynamic scrollInsetTop;

- (void)setPullDelegate:(id)delegate
{
    sak_objc_setNonatomicAssociatedWeakObject(self, &pullDelegate, delegate);
}

- (id)pullDelegate
{
    return sak_objc_getAssociatedWeakObject(self, &pullDelegate);
}

- (void)setRefreshViewColor:(UIColor*)color
{
    if (self.canPullDown) {
        self.interceptor.upView.backgroundColor = color;
    }
    if (self.canPullUp) {
        self.interceptor.downView.backgroundColor = color;
    }
}

- (void)setRefreshViewTextColor:(UIColor *)color
{
    if (self.canPullDown) {
        [self.interceptor.upView setTextColor:color];
    }
    if (self.canPullUp) {
        [self.interceptor.downView setTextColor:color];
    }
}

//初始化拦截器
- (void)InitInterceptor
{
    if (!self.interceptor) {
        Interceptor *tmpInterceptor = [[Interceptor alloc] init];
        self.interceptor = tmpInterceptor;
        __weak UIScrollView *weakSelf = self;
        self.interceptor.scrollView = weakSelf;
        if (self.delegate) {
            self.interceptor.receiver = self.delegate;
        }
        self.delegate = (id)self.interceptor;
    }
}

- (void)setCanPullUp:(BOOL)canPull
{
    if (canPull) {
        [self InitInterceptor];
        if (!self.interceptor.downView) {
            PullRefreshView *view = [[PullRefreshView alloc] init];
            view.hidden = YES;
            [self addSubview:view];
            self.interceptor.downView = view;
        } else {
            [self addSubview:self.interceptor.downView];
        }
    } else {
        if (self.interceptor.downView.superview) {
            [self.interceptor.downView removeFromSuperview];
            self.interceptor.downView = nil;
        }
    }
    objc_setAssociatedObject(self, &canPullUp, @(canPull), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)canPullUp
{
    NSNumber *number = objc_getAssociatedObject(self, &canPullUp);
    return [number boolValue];
}

- (void)setCanPullDown:(BOOL)canPull
{
    if (canPull) {
        [self InitInterceptor];
        if (!self.interceptor.upView) {
            PullRefreshView *view = [[PullRefreshView alloc] initWithFrame:CGRectMake(0, -300, self.frame.size.width, 300)];
            [self addSubview:view];
            self.interceptor.upView = view;
        } else {
            [self addSubview:self.interceptor.upView];
        }
    } else {
        if (self.interceptor.upView.superview) {
            [self.interceptor.upView removeFromSuperview];
            self.interceptor.upView = nil;
        }
    }
    objc_setAssociatedObject(self, &canPullDown, @(canPull), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)canPullDown
{
    NSNumber *number = objc_getAssociatedObject(self, &canPullDown);
    return [number boolValue];
}

- (void)setScrollInsetBottom:(float)insetBottom
{
    NSNumber *number = [NSNumber numberWithFloat:insetBottom];
    objc_setAssociatedObject(self, &scrollInsetBottomKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (float)scrollInsetBottom
{
    NSNumber *number = objc_getAssociatedObject(self, &scrollInsetBottomKey);
    return [number floatValue];
}

- (void)setScrollInsetTop:(float)insetTop
{
    NSNumber *number = [NSNumber numberWithFloat:insetTop];
    objc_setAssociatedObject(self, &scrollInsetTopKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (float)scrollInsetTop
{
    NSNumber *number = objc_getAssociatedObject(self, &scrollInsetTopKey);
    return [number floatValue];
}

- (void)stopLoadWithState:(LoadState)state
{
    if (state == PullDownLoadState && self.interceptor.upView.state == PullStateLoading) {
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [UIView animateWithDuration:0.2 animations:^{
                UIEdgeInsets insets = self.contentInset;
                insets = UIEdgeInsetsMake(self.scrollInsetTop, 0, insets.bottom, 0);
                [self setContentInset:insets];
            }];
            [self.interceptor.upView setState:PullStateNormal];
        });
    } else if (state == PullUpLoadState && self.interceptor.downView.state == PullStateLoading) {
        [UIView animateWithDuration:0.2 animations:^{
            UIEdgeInsets insets = self.contentInset;
            insets = UIEdgeInsetsMake(insets.top, 0, self.scrollInsetBottom, 0);
            [self setContentInset:insets];
        }];
        [self.interceptor.downView setState:PullStateNormal];
    }
    if (self.interceptor.downView) {
        [self.interceptor.downView setFrame:CGRectMake(0, self.contentSize.height, self.frame.size.width, 300)];
    }
}

- (void)scrollViewDidScroll:(UIScrollView*)scView
{
    //    NSLog(@"scrollViewDidScroll");
}

- (void)scrollViewDidEndDragging:(UIScrollView*)scView willDecelerate:(BOOL)decelerate
{
    //    NSLog(@"scrollViewDidEndDragging");
}

@end
