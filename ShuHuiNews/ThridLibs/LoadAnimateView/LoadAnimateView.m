//
//  LoadAnimateView.m
//  beniOS
//
//  Created by Ben on 16/8/18.
//  Copyright © 2016年 bengroup. All rights reserved.
//

#import "LoadAnimateView.h"

@implementation LoadAnimateView

+ (LoadAnimateView *)loadHUD:(UIView *)view{
    static LoadAnimateView * loadHUD;
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        loadHUD = [[LoadAnimateView alloc] initWithFrame:view.bounds];
    });
    return loadHUD;
}

+ (void)showHUDToView:(UIView *)view {
    [[self loadHUD:view] showHUDToView:view];
}
- (void)showHUDToView:(UIView *)view {
//    UIColor *color = [UIColor whiteColor];
//    self.backgroundColor = [color colorWithAlphaComponent:0.5];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (!_imgV) {
        _imgV = [[UIImageView alloc] initWithFrame:CGRectMake((size.width-80)/2, (size.height-79)/2, 80, 80)];
        if (![view isKindOfClass:[UIWindow class]]) {
            _imgV.frame = CGRectMake((size.width-80)/2, (size.height-79)/2, 80, 80);
        }
        [self addSubview:_imgV];
        NSMutableArray *mArr = [[NSMutableArray alloc] init];
        for (NSInteger i=0; i<5; i++) {
            NSString *name = [NSString stringWithFormat:@"loading_%ld", (long)i];
            UIImage *dove = [UIImage imageNamed:name];
            [mArr addObject:dove];
        }
        //设置动画持续时间
        _imgV.animationDuration = 0.5;
        //设置动画重复次数，0为不限制
        _imgV.animationRepeatCount = 0;
        //设置动画使用的图片
        _imgV.animationImages = mArr;
        //开始动画
        [_imgV startAnimating];
    }

    //将当前视图放在需要的视图上
    [view addSubview:self];
}

+ (void)hiddenHUD:(UIView *)view {
    [[self loadHUD:view] removeFromSuperview];
}

+ (void)dismissHUD {
    UIView * view;
    [[self loadHUD:view] removeFromSuperview];
}

@end
