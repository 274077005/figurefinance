//
//  CenterCompanyTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/22.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TheCompanyTVCell.h"
#import "MainCenterModel.h"
@interface CenterCompanyTVCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *shadowBV;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *countryLab;


@property(nonatomic,strong)MainCenterModel * centerModel;
-(void)updateWithModel;

@end
