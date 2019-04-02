//
//  UIView+Additions.m
//  WeiboProject
//
//  Created by 王静静 on 13-10-25.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

- (UIViewController *)viewController {
    
    //下一个响应者
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        
        next = [next nextResponder];
        
    } while (next != nil);
    
    return nil;
}


- (UIView *)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResponder];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    return nil;
}

@end
