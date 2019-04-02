//
//  NoPWLoginVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/8.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "ProvidePickerV.h"
@interface NoPWLoginVC : BaseViewController<BasicPickerDelegate>



@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyNumTF;

@property (weak, nonatomic) IBOutlet UIButton *getVerifyNumBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (weak, nonatomic) IBOutlet UILabel *areaLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;

@end
