//
//  MAView.h
//  Treasure
//
//  Created by 蓝蓝色信子 on 16/9/12.
//  Copyright © 2016年 GY. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^valueBlock)(NSInteger M1Value,NSInteger M2Value,NSInteger M3Value);
@interface MAKPISetView : UIView


@property (weak, nonatomic) IBOutlet UILabel *KPINameLab;

@property (weak, nonatomic) IBOutlet UILabel *M1Lab;
@property (weak, nonatomic) IBOutlet UISlider *M1Slider;
@property (weak, nonatomic) IBOutlet UILabel *M2Lab;
@property (weak, nonatomic) IBOutlet UISlider *M2Slider;
@property (weak, nonatomic) IBOutlet UILabel *M3Lab;
@property (weak, nonatomic) IBOutlet UISlider *M3Slider;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (copy,nonatomic) NSString *KPI1Str;
@property (copy,nonatomic) NSString *KPI2Str;
@property (copy,nonatomic) NSString *KPI3Str;

//原始的值
@property (copy,nonatomic) NSString *slider1OV;
@property (copy,nonatomic) NSString *slider2OV;
@property (copy,nonatomic) NSString *slider3OV;

- (void)setLablesWithKPIValue:(NSString*)kpi1Value kpi2Value:(NSString*)kpi2Value kpi3Value:(NSString*)kpi3Value;

- (void)createViews;
- (void)setMALables;
- (void)setBOLLLables;
- (void)setENVLables;
- (void)setMACDLables;
- (void)setRSILables;
- (void)setKDJLables;
- (void)setWRLables;
@property (nonatomic,copy) valueBlock valueBlock;
@end
