//
//  CenterRegulationTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/21.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TheRegulationTVCell.h"
#import "MainCenterModel.h"

@interface CenterRegulationTVCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *shadowBV;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
-(void)updateWithModel;

@property(nonatomic,strong)MainCenterModel * centerModel;
@end
