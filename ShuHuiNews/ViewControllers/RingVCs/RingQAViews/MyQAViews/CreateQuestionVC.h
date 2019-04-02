//
//  CreateQuestionVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/21.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "MainWalletVC.h"
@interface CreateQuestionVC : BaseViewController<UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;

@property (weak, nonatomic) IBOutlet UILabel *holdLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UITextView *questionTV;
@property (weak, nonatomic) IBOutlet UILabel *categoryLab;
@property (weak, nonatomic) IBOutlet UIView *categoryBV;

@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;


@property(nonatomic,copy)NSString * typeId;


@end
