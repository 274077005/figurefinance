//
//  LaunchAdvertVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/28.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "AdvertModel.h"
@interface LaunchAdvertVC : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *jumpBtn;
@property (weak, nonatomic) IBOutlet UIImageView *advertImgV;
@property (weak, nonatomic) IBOutlet UIView *advertBV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property(nonatomic,strong)AdvertModel * adModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTop;

@end
