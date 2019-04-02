//
//  TheEnvironmentCVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/21.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCenterModel.h"
#import "TheEnvironmentTVCell.h"
@interface TheEnvironmentICVCell : UIView<UITableViewDelegate,UITableViewDataSource>

    @property (weak, nonatomic) IBOutlet UITableView *tableView;
    
@property(nonatomic,strong)CenterEnvironmentModel * enModel;
-(void)updateWithModel;
@end
