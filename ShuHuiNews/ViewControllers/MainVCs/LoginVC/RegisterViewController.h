//
//  RegisterViewController.h
//  Wanyuanbao
//
//  Created by 耿一 on 2017/10/23.
//  Copyright © 2017年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "ProvidePickerV.h"
@interface RegisterViewController : BaseViewController<UITextFieldDelegate,BasicPickerDelegate>


@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyNumTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UIButton *getVerifyNumBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *protocolBtn;
@property (weak, nonatomic) IBOutlet UIButton *protocalDetailBtn;

@property (weak, nonatomic) IBOutlet UILabel *areaLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;



@property (weak, nonatomic) IBOutlet UIView *personBV;
@property (weak, nonatomic) IBOutlet UIImageView *personImgV;

@property (weak, nonatomic) IBOutlet UIView *companyBV;
@property (weak, nonatomic) IBOutlet UIImageView *companyImgV;


@property (copy,nonatomic)NSString * userType;

@property (copy,nonatomic)NSString * thridType;

@property (copy,nonatomic)NSString * openId;


@end
