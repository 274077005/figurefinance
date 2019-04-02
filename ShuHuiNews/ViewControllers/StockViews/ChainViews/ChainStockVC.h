//
//  StockViewController.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/6/21.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "GYStockKPIModel.h"
#import "AppDelegate.h"
#import "EverChart.h"
#import "GYStockKPIModel.h"
#import "MAKPISetView.h"
#import "DrawingBoardViewController.h"
#import "ChainDetailModel.h"
#import <UserNotifications/UserNotifications.h>
#import "StockRevolveVC.h"
@interface ChainStockVC : BaseViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;

@property (weak, nonatomic) IBOutlet UIView *labelsOfV;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *marginLab;
@property (weak, nonatomic) IBOutlet UILabel *mpLab;
@property (weak, nonatomic) IBOutlet UILabel *lastLab;
@property (weak, nonatomic) IBOutlet UILabel *openLab;
@property (weak, nonatomic) IBOutlet UILabel *topLab;
@property (weak, nonatomic) IBOutlet UILabel *lowLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UIScrollView *menuScrollV;
@property (weak, nonatomic) IBOutlet UIView *KPIV;
@property (weak, nonatomic) IBOutlet UIView *stockV;
@property (weak, nonatomic) IBOutlet UIView *primeKPIV;

@property (strong, nonatomic) EverChart *stockChart;
@property(nonatomic,copy)CABasicAnimation *animation;

@property (strong, nonatomic) MAKPISetView * maSetView;

@property (strong, nonatomic) MAKPISetView * bollSetView;

@property (strong, nonatomic) MAKPISetView * envSetView;

@property (strong, nonatomic) MAKPISetView * macdSetView;

@property (strong, nonatomic) MAKPISetView * rsiSetView;

@property (strong, nonatomic) MAKPISetView * kdjSetView;

@property (strong, nonatomic) MAKPISetView * wrSetView;


@property(nonatomic, strong)GYStockKPIModel *kpiModel;

//追加数据用

@property (copy,nonatomic) NSMutableDictionary *nowKDataDic;

@property (assign,nonatomic)BOOL isOrNotGetKLineData;



@property(nonatomic, strong)ChainDetailModel *detailModel;

@end
