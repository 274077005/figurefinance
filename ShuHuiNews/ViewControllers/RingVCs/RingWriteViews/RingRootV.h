//
//  RingRootV.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/27.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RingTagTVCell.h"
#import "RingNormalTVCell.h"
#import "PersonTagTVCell.h"
#import "RingRootModel.h"
#import "RingBannerV.h"
#import "RingDetailVC.h"
@interface RingRootV : UIView<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,copy)NSString * theId;

@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)RingRootModel * ringModel;

@property(nonatomic,strong)RingStatusModel * statusModel;

@property(nonatomic,strong)RingBannerV * bannerV;

@property(nonatomic,assign)NSInteger cellIndex;

@property(nonatomic,assign)BOOL notFirstToHere;
- (void)setUpContentView;
@end
