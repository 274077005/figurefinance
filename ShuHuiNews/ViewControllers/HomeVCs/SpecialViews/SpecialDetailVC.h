//
//  SpecialDetailVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/18.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "HomeRecommendV.h"
@interface SpecialDetailVC : BaseViewController

@property(nonatomic,copy)NSString * specialId;
@property(nonatomic,strong)HomeRecommendV * recommendV;

@end
