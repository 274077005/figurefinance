//
//  HomeCVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/9.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeRecommendV.h"
#import "HomeFlashV.h"
#import "NotLoginV.h"
#import "LoveStockListVC.h"
@interface HomeCVCell : UICollectionViewCell


@property (nonatomic,strong)LoveStockListVC * listVC;


@property (nonatomic,strong)HomeFlashV * flashV;

@property (nonatomic,strong)HomeRecommendV * recommendV;

@property (nonatomic,strong)NotLoginV * notLoginV;
- (void)createContentView;

@property(nonatomic,copy)NSString * theId;
@end
