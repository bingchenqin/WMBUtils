//
//  UIView+TapGestureRecognizer.m
//  waimaibiz
//
//  Created by liuyanming on 6/2/16.
//  Copyright © 2016 meituan. All rights reserved.
//

#import "UIView+TapGestureRecognizer.h"

@implementation UIView (TapGestureRecognizer)

- (UITapGestureRecognizer *)addTarget:(id)target tapAction:(SEL)tapAction
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:tapAction];
    [self addGestureRecognizer:tapGestureRecognizer];

    return tapGestureRecognizer;
}

@end
