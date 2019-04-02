//
//  SpecialDetailVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/18.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "HomeRecommendV.h"
@interface ColumnListVC : BaseViewController

@property(nonatomic,copy)NSString * titleStr;
@property(nonatomic,copy)NSString * choiceId;
@property(nonatomic,strong)HomeRecommendV * recommendV;

@end
