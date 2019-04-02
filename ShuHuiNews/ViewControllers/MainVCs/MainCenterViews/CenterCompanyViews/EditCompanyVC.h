//
//  EditRegulationVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/23.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "MainCenterModel.h"
@interface EditCompanyVC : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (nonatomic,assign)BOOL isEdit;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *timeTF;
@property (weak, nonatomic) IBOutlet UIView *timeBV;
@property (weak, nonatomic) IBOutlet UITextField *countryTF;

@property (weak, nonatomic) IBOutlet UITableView *editTableView;



@property(nonatomic,strong)CenterCompanyModel * comModel;

@end
