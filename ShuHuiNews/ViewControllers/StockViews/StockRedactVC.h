//
//  StockRedactVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/6/26.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "StockCollectionViewCell.h"
#import "StockDetailModel.h"
#import <AudioToolbox/AudioToolbox.h>
@interface StockRedactVC : BaseViewController<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainCVHeight;

@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionV;

@property (weak, nonatomic) IBOutlet UICollectionView *marketCollectionV;
@property (weak, nonatomic) IBOutlet UIScrollView *menuScrollV;

@property (weak, nonatomic) IBOutlet UILabel *marketHeadLab;

//自选Id的数组
@property(nonatomic,copy)NSArray * loveArr;

//所有外汇行情
@property(nonatomic,copy)NSArray * allDataArr;



@property(nonatomic,strong)UIView * snapMoveCell; //截图cell 用于移动
@property(nonatomic,strong)NSIndexPath * originalIndexPath; //手指所在的cell indexPath
@property(nonatomic,strong)NSIndexPath * moveIndexPath ; //可替换的cell indexPath
@property(nonatomic,assign)CGPoint lastPoint ; //手指所在cell 的Point


@end
