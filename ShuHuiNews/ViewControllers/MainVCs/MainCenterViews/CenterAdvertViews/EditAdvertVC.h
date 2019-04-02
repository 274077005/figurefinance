//
//  EditRegulationVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/23.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "MainCenterModel.h"
@interface EditAdvertVC : BaseViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet UIView *addBV;

@property (weak, nonatomic) IBOutlet UIView *deleteBV;
@property (nonatomic,assign)BOOL isEdit;
@property (nonatomic,copy)NSString * theId;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *linkTF;
@property (weak, nonatomic) IBOutlet UIImageView *advertImgV;

@property(nonatomic,strong)CenterAdvertModel * adModel;

@end
