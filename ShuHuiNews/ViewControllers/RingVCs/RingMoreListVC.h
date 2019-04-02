//
//  RingMoreListVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/28.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "RingNormalTVCell.h"
#import "RingRootModel.h"
#import "RingDetailVC.h"
@interface RingMoreListVC : BaseViewController
//用来标识是个人还是公司列表
@property(nonatomic,copy)NSString * listType;

@property(nonatomic,strong)RingStatusModel * statusModel;

@end
