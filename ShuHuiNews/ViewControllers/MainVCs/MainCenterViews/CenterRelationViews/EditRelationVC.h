//
//  EditRelationVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/23.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "MainCenterModel.h"
#import "ProvidePickerV.h"
@interface EditRelationVC : BaseViewController<BasicPickerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet UILabel *fAreaLab;
@property (weak, nonatomic) IBOutlet UILabel *sAreaLab;

@property (weak, nonatomic) IBOutlet UITextField *fPhoneTF;

@property (weak, nonatomic) IBOutlet UITextField *sPhoneTF;

@property (weak, nonatomic) IBOutlet UITextField *wechatTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;


@property(nonatomic,strong)CenterContactModel * contactModel;

@end
