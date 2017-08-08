//
//  UIView+TapGestureRecognizer.h
//  waimaibiz
//
//  Created by liuyanming on 6/2/16.
//  Copyright © 2016 meituan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TapGestureRecognizer)

- (UITapGestureRecognizer *)addTarget:(id)target tapAction:(SEL)tapAction;

@end
