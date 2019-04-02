//
//  ChooseInstitutionV.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/29.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCenterModel.h"
#import "AgencyTVCell.h"
@interface ChooseAgencyV : UIView<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)MainCenterModel * centerModel;

@property(nonatomic,copy)void(^submitBlock)(CenterAgencyModel * agencyModel);
@end
