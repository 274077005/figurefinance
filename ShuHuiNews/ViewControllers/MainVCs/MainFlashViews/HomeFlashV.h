//
//  HomeNewsV.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/9.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlashModel.h"
#import "FlashNormalTVCell.h"
#import "FlashImgsTVCell.h"
@interface HomeFlashV : UIView<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong)UITableView * tableView;

//表明是首页快讯还是我的快讯   1、首页 2、我的
@property(nonatomic,copy)NSString * fromStr;
@property(nonatomic,strong)UIView * sofaV;
- (void)loadRefreshData;

- (id)initWithFrame:(CGRect)frame withFrom:(NSString *)from;

@end
