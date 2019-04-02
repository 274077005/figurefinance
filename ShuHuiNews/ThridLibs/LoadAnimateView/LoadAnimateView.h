//
//  LoadAnimateView.h
//  beniOS
//
//  Created by Ben on 16/8/18.
//  Copyright © 2016年 bengroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadAnimateView : UIView

@property(nonatomic,strong)UIImageView *imgV;

//将HUD放在所需的视图上
+ (void)showHUDToView:(UIView *)view;

//去除HUD从当前视图
+ (void)hiddenHUD:(UIView *)view;


+ (void)dismissHUD;

@end
