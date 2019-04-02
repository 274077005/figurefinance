//
//  MainSetVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/19.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseWebVC.h"
@interface MainSetVC : BaseViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet UIView *cleanBV;
@property (weak, nonatomic) IBOutlet UILabel *cleanLab;
@property (weak, nonatomic) IBOutlet UIView *aboutBV;
@property (weak, nonatomic) IBOutlet UIView *adviceBV;
@property (weak, nonatomic) IBOutlet UIView *quitBV;

@end
