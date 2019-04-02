//
//  EditRegulationVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/23.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "MainCenterModel.h"
@interface EditPersonalBasicsVC : BaseViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *jobTF;
@property (weak, nonatomic) IBOutlet UITextField *companyTF;

@property (weak, nonatomic) IBOutlet UIImageView *cardImgV;

@property(nonatomic,strong)CenterAttestationModel * atModel;
@end
