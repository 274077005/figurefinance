//
//  StockRevolveVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/10.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "GYStockKPIModel.h"
#import "GYUrlSession.h"
#import "AppDelegate.h"
#import "EverChart.h"
#import "GYStockKPIModel.h"
#import "MAKPISetView.h"
#import "DrawingBoardViewController.h"
#import "StockDetailModel.h"
#import "GYStockLineIndicators.h"
#import <UserNotifications/UserNotifications.h>
@interface StockRevolveVC : BaseViewController
    
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *marginLab;
@property (weak, nonatomic) IBOutlet UILabel *mpLab;
@property (weak, nonatomic) IBOutlet UILabel *topLab;
@property (weak, nonatomic) IBOutlet UILabel *lowLab;
@property (weak, nonatomic) IBOutlet UILabel *lastLab;

    
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
    
@property (weak, nonatomic) IBOutlet UIScrollView *menuScrollV;
    
@property (weak, nonatomic) IBOutlet UIView *primeKPIV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *primeVLeading;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *primeKPIVWidth;

@property (weak, nonatomic) IBOutlet UIView *KPIV;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;

@property (weak, nonatomic) IBOutlet UIView *stockV;
    
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
    
@property(nonatomic, strong)StockDetailModel *detailModel;

@property (copy,nonatomic) NSString * primeType;
@property (nonatomic) NSInteger  nowOrDay;
@property (copy,nonatomic) NSString * minorType;

//拼链接的时间戳字串
@property (copy,nonatomic) NSString * timeBucketStr;
    
@end
