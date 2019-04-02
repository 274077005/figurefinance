//
//  MAView.m
//  Treasure
//
//  Created by 蓝蓝色信子 on 16/9/12.
//  Copyright © 2016年 GY. All rights reserved.
//

#import "MAKPISetView.h"

@implementation MAKPISetView


- (void)createViews
{
//    //236 95 97
//    //允许剪切边角
//    self.confirmBtn.layer.masksToBounds = YES;
//    
//    //设置圆角半径
//    self.confirmBtn.layer.cornerRadius = 6;
    
    //设置边框的宽度
    self.cancelBtn.layer.borderWidth = 1;
    
    //设置边框的颜色）（默认黑色）
    self.cancelBtn.layer.borderColor = [[UIColor colorWithRed:236/255.0 green:95/255.0 blue:97/255.0 alpha:1.0] CGColor];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.M1Slider addTarget:self action:@selector(M1SliderChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self.M2Slider addTarget:self action:@selector(M2SliderChangeValue) forControlEvents:UIControlEventValueChanged];
    [self.M3Slider addTarget:self action:@selector(M3SliderChangeValue) forControlEvents:UIControlEventValueChanged];
    
    
}
-(void)M1SliderChangeValue:(UISlider *)slider{
    NSInteger value = slider.value;
    self.M1Lab.text = [NSString stringWithFormat:@"%@%ld",_KPI1Str,value];
}
- (void)M2SliderChangeValue
{
    NSInteger value = self.M2Slider.value;
    self.M2Lab.text = [NSString stringWithFormat:@"%@%ld",_KPI2Str,value];
}
- (void)M3SliderChangeValue
{
    NSInteger value = self.M3Slider.value;
    self.M3Lab.text = [NSString stringWithFormat:@"%@%ld",_KPI3Str,value];
}


- (IBAction)confirmBtnClick:(id)sender {
    if (self.valueBlock) {
        self.valueBlock(self.M1Slider.value,self.M2Slider.value,self.M3Slider.value);
    }
    [self removeFromSuperview];
}
- (IBAction)cancelBtnClick:(id)sender {
    
    [self removeFromSuperview];
}

- (IBAction)resumeBtnClick:(id)sender {
    self.M1Slider.value = [_slider1OV integerValue];
    self.M2Slider.value = [_slider2OV integerValue];
    self.M3Slider.value = [_slider3OV integerValue];
    self.M1Lab.text = [NSString stringWithFormat:@"%@%ld",_KPI1Str,[_slider1OV integerValue]];
    self.M2Lab.text = [NSString stringWithFormat:@"%@%ld",_KPI2Str,[_slider2OV integerValue]];
    self.M3Lab.text = [NSString stringWithFormat:@"%@%ld",_KPI3Str,[_slider3OV integerValue]];
    
}



- (void)setLablesWithKPIValue:(NSString*)kpi1Value kpi2Value:(NSString*)kpi2Value kpi3Value:(NSString*)kpi3Value
{
    self.M1Slider.value = [kpi1Value integerValue];
    self.M2Slider.value = [kpi2Value integerValue];
    self.M3Slider.value = [kpi3Value integerValue];
    self.M1Lab.text = [NSString stringWithFormat:@"%@%ld",_KPI1Str,[kpi1Value integerValue]];
    self.M2Lab.text = [NSString stringWithFormat:@"%@%ld",_KPI2Str,[kpi2Value integerValue]];
    self.M3Lab.text = [NSString stringWithFormat:@"%@%ld",_KPI3Str,[kpi3Value integerValue]];
}


- (void)setMALables
{
    self.KPINameLab.text = @"指标:MA";
    self.KPI1Str = @"M1(1-100) : ";
    self.KPI2Str = @"M2(1-100) : ";
    self.KPI3Str = @"M3(1-100) : ";
    self.slider1OV = @"5";
    self.slider2OV = @"10";
    self.slider3OV = @"20";
    [self createViews];
    
}

- (void)setBOLLLables
{
    self.KPINameLab.text = @"指标:BOLL";
    self.KPI1Str = @"N(2-100) : ";
    self.KPI2Str = @"标准差(1-10) : ";
    self.slider1OV = @"20";
    self.slider2OV = @"2";
    
    self.M1Slider.minimumValue = 2;
    self.M1Slider.maximumValue = 100;
    
    self.M2Slider.minimumValue = 1;
    self.M2Slider.maximumValue = 10;
    
    self.M3Lab.hidden = YES;
    self.M3Slider.hidden = YES;
    
    [self createViews];
    
}

- (void)setENVLables
{
    self.KPINameLab.text = @"指标:ENV";
    self.KPI1Str = @"N(2-100) : ";
    self.slider1OV = @"14";
    
    self.M1Slider.minimumValue = 2;
    self.M1Slider.maximumValue = 100;
    
    self.M2Lab.hidden = YES;
    self.M2Slider.hidden = YES; 
    
    self.M3Lab.hidden = YES;
    self.M3Slider.hidden = YES;
    
    [self createViews];
    
}



- (void)setMACDLables
{
    self.KPINameLab.text = @"指标:MACD";
    self.KPI1Str = @"SHORT (2-100) : ";
    self.KPI2Str = @"LONG (2-100) : ";
    self.KPI3Str = @"MID (2-100) : ";
    self.slider1OV = @"12";
    self.slider2OV = @"26";
    self.slider3OV = @"9";
    
    self.M1Slider.minimumValue = 2;
    self.M1Slider.maximumValue = 100;
    
    self.M2Slider.minimumValue = 2;
    self.M2Slider.maximumValue = 100;
    self.M3Slider.minimumValue = 2;
    self.M3Slider.maximumValue = 100;
    
    [self createViews];
    
}
- (void)setRSILables
{
    self.KPINameLab.text = @"指标:RSI";
    self.KPI1Str = @"N1 (2-100) : ";
    self.KPI2Str = @"N2 (2-100) : ";
    self.KPI3Str = @"N3 (2-100) : ";
    self.slider1OV = @"6";
    self.slider2OV = @"12";
    self.slider3OV = @"24";
    
    self.M1Slider.minimumValue = 2;
    self.M1Slider.maximumValue = 100;
    
    self.M2Slider.minimumValue = 2;
    self.M2Slider.maximumValue = 100;
    self.M3Slider.minimumValue = 2;
    self.M3Slider.maximumValue = 100;
    [self createViews];
}


- (void)setKDJLables
{
    self.KPINameLab.text = @"指标:KDJ";
    self.KPI1Str = @"N (2-100) : ";
    self.KPI2Str = @"M1 (2-40) : ";
    self.KPI3Str = @"M2 (2-40) : ";
    self.slider1OV = @"9";
    self.slider2OV = @"3";
    self.slider3OV = @"3";
    
    self.M1Slider.minimumValue = 2;
    self.M1Slider.maximumValue = 100;
    
    self.M2Slider.minimumValue = 2;
    self.M2Slider.maximumValue = 40;
    self.M3Slider.minimumValue = 2;
    self.M3Slider.maximumValue = 40;
    [self createViews];
}

- (void)setWRLables
{
    self.KPINameLab.text = @"指标:WR";
    self.KPI1Str = @"N (2-100) : ";
    self.slider1OV = @"14";
    
    self.M1Slider.minimumValue = 2;
    self.M1Slider.maximumValue = 100;
    
    self.M2Lab.hidden = YES;
    self.M2Slider.hidden = YES;
    
    self.M3Lab.hidden = YES;
    self.M3Slider.hidden = YES;
    
    [self createViews];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
////    [self createViews];
//}


@end
