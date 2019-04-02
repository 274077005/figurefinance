//
//  EditCompanyURLCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/27.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProvidePickerV.h"
#import "MainCenterModel.h"
@interface EditCompanyURLCell : UITableViewCell<BasicPickerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UITextField *urlTF;
@property (weak, nonatomic) IBOutlet UIView *typeBV;

@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@property(nonatomic,strong)TheCompanyModel * coModel;
-(void)updateWithModel;
@end
