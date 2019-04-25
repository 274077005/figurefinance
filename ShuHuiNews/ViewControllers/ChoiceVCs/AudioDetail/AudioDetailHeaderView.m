//
//  AudioDetailHeaderView.m
//  ShuHuiNews
//
//  Created by zhaowei on 2019/4/25.
//  Copyright © 2019 耿一. All rights reserved.
//

#import "AudioDetailHeaderView.h"

@implementation AudioDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = [UIColor whiteColor];
    MusicViewController *musicVC = [MusicViewController sharedInstance];
    //获取当前view对应的controller
    UIViewController *controller = [self getCurrentController];
    [controller addChildViewController:musicVC];
    [self addSubview:musicVC.view];

    [musicVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    
}

- (UIViewController*)getCurrentController{
    //获取当前view的superView对应的控制器
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
    
}

@end
