//
//  EditRegulationVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/23.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "MainCenterModel.h"
@interface EditEnvironmentVC : BaseViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet UIView *addBV;

@property (weak, nonatomic) IBOutlet UIView *deleteBV;
@property (nonatomic,assign)BOOL isEdit;
@property (nonatomic,copy)NSString * theId;
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *varietiesTF;
@property (weak, nonatomic) IBOutlet UITextField *speedTF;
@property (weak, nonatomic) IBOutlet UITextField *typeTF;
@property (weak, nonatomic) IBOutlet UITextField *minNumTF;
@property (weak, nonatomic) IBOutlet UITextField *minMoneyTF;


@property(nonatomic,strong)CenterEnvironmentModel * enModel;
@end
