//
//  EditAddressVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/26.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "SubmitOrderModel.h"

@interface EditAddressVC : BaseViewController


@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *cityTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet UIView *cityBV;


@property(nonatomic,strong)SAddressModel * addModel;


@end
