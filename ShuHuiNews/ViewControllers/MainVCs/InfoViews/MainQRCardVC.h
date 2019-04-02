//
//  MainQRCardVC.h
//  WEMEX
//
//  Created by 耿一 on 2018/3/28.
//  Copyright © 2018年 Zach. All rights reserved.
//

#import "BaseViewController.h"
#import "MainCenterModel.h"
@interface MainQRCardVC : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *QRImgV;
@property (weak, nonatomic) IBOutlet UIImageView *appImgV;


@property(nonatomic,copy)NSString * headerStr;


@property(nonatomic,copy)NSString * CodeStr;

@property(nonatomic,copy)NSString * nameStr;

@property(nonatomic,strong)MainCenterModel * centerModel;
@end
