//
//  EiditCompanyInfoVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/23.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "MainCenterModel.h"
#import "ChooseIndustryVC.h"
@interface EditCompanyInfoVC : BaseViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet UITextView *abstractTV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tvHeight;
@property (weak, nonatomic) IBOutlet UIView *tvBV;
@property(nonatomic,strong)CenterBasicModel * basicModel;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *industryTF;
@property (weak, nonatomic) IBOutlet UIView *industryBV;

@end
