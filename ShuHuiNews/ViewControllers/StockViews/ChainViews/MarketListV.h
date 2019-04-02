//
//  HomeNewsV.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/9.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChainDetailModel.h"
#import "ChainTableViewCell.h"
#import "ChainStockVC.h"
@interface MarketListV : UIView<UITableViewDelegate,UITableViewDataSource>



@property(nonatomic,copy)NSString * theId;

@property(nonatomic,strong)UITableView * tableView;
-(void)getListData;

- (void)loadRefreshData;
@end
