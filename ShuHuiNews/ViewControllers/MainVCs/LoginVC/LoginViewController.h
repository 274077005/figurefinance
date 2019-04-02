//
//  LoginViewController.h
//  Wanyuanbao
//
//  Created by 耿一 on 2017/10/24.
//  Copyright © 2017年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoPWLoginVC.h"
#import "ProvidePickerV.h"
@interface LoginViewController : UIViewController<BasicPickerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *hidePasswordBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet UILabel *areaLab;





@end
