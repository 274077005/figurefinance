//
//  LineFenShiModel.m
//  TestChart
//
//  Created by Ever on 15/12/18.
//  Copyright © 2015年 Lucky. All rights reserved.
//

#import "EverLineModel.h"
#import "Section.h"
#import "EverChart.h"
#import "YYEverColor.h"

@implementation EverLineModel
-(void)drawSerie:(EverChart *)chart serie:(NSMutableDictionary *)serie cross:(NSInteger)cross{
    if([serie objectForKey:@"data"] == nil || [[serie objectForKey:@"data"] count] == 0){
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, YES);
    CGContextSetLineWidth(context, 0.5f);
    
    NSMutableArray *data          = [serie objectForKey:@"data"];
    int            yAxis          = [[serie objectForKey:@"yAxis"] intValue];
    int            section        = [[serie objectForKey:@"section"] intValue];
    UIColor       *color         = [serie objectForKey:@"color"];
    NSMutableArray *category      = [serie objectForKey:@"category"];
    
    Section *sec = [chart.sections objectAtIndex:section];
//    NSLog(@"data:%@",data);
    //设置选中点 竖线以及小球颜色 十字线开始
    if (1 == cross) {
        
        if(chart.selectedIndex!=-1 && chart.selectedIndex < data.count && [data objectAtIndex:chart.selectedIndex]!=nil){
            
            //设置选中点竖线
            float value = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:0] floatValue];

            CGContextSetShouldAntialias(context, YES);
            CGContextSetLineWidth(context, 0.5);
            CGContextSetStrokeColorWithColor(context, kYFontColor.CGColor);
            
            //画竖线
            CGContextMoveToPoint(context, sec.frame.origin.x+sec.paddingLeft+(chart.selectedIndex-chart.rangeFrom)*chart.plotWidth+chart.plotWidth/2, sec.frame.origin.y+sec.paddingTop);
            CGContextAddLineToPoint(context,sec.frame.origin.x+sec.paddingLeft+(chart.selectedIndex-chart.rangeFrom)*chart.plotWidth+chart.plotWidth/2,sec.frame.size.height+sec.frame.origin.y);
            CGContextStrokePath(context);
            
            //设置选中点小球颜色
            CGContextBeginPath(context);
            CGContextSetFillColorWithColor(context, color.CGColor);
            if(!isnan([chart getLocalY:value withSection:section withAxis:yAxis])){
                CGContextAddArc(context, sec.frame.origin.x+sec.paddingLeft+(chart.selectedIndex-chart.rangeFrom)*chart.plotWidth+chart.plotWidth/2, [chart getLocalY:value withSection:section withAxis:yAxis], 3, 0, 2*M_PI, 1);
            }
            CGContextFillPath(context);
            
            //画横线
            if (chart.touchY > sec.paddingTop && chart.touchY < sec.frame.size.height) {
                //            NSLog(@"touch.Y:%f",chart.touchY);
                //            NSLog(@"sec.paddingTop:%f",sec.paddingTop);
                CGContextMoveToPoint(context, sec.frame.origin.x + sec.paddingLeft, chart.touchY);
                CGContextAddLineToPoint(context, sec.frame.origin.x + sec.frame.size.width, chart.touchY);
                CGContextStrokePath(context);
                
                //计算横线对应刻度
                YAxis *yaxis = sec.yAxises[0];
                CGFloat touchPointValue = (sec.frame.origin.y + sec.frame.size.height - chart.touchY)/(sec.frame.size.height - sec.paddingTop) * (yaxis.max - yaxis.min) + yaxis.min;
                
                //画横线左侧刻度标记
                NSString *text;
                if (yaxis.decimal == 0) {
                    text = [NSString stringWithFormat:@"%d",(int)touchPointValue];
                }else{
                    text = [NSString stringWithFormat:@"%.2f",touchPointValue];
                }
                
                NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
                style.alignment = NSTextAlignmentCenter;
                //设置左侧刻度字体颜色
                NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:kYFontSizeFenShi],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:kYFontColor};
                CGSize textSize = [text sizeWithAttributes:attributes];
                CGRect rect = CGRectMake(sec.paddingLeft + sec.frame.origin.x - textSize.width - 3, chart.touchY - (textSize.height + 2)/2.0, textSize.width + 2, textSize.height + 2);
                //设置抗锯齿效果
                CGContextSetShouldAntialias(context, YES);
                //设置横线左框字体颜色
                CGContextSetStrokeColorWithColor(context, kYFontColor.CGColor);
                //设置横线左框颜色
                CGContextSetFillColorWithColor(context, kYFontColor.CGColor);
                CGContextSetLineWidth(context, 0.5);
                
                //CGContextFillRect(context, rect);
                
                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:4];
                CGContextAddPath(context, path.CGPath);
                CGContextStrokePath(context);
                
                [text drawInRect:rect withAttributes:attributes];
                
            }
            
        }
    }
    //十字线结束
    
    //绘制股票线
    CGContextSetShouldAntialias(context, YES);
//    NSLog(@"rangeFrom:%d",chart.rangeFrom);
//    NSLog(@"rangeTo:%d",chart.rangeTo);
    for(NSInteger i=chart.rangeFrom;i<chart.rangeTo;i++){
        if(i == data.count-1){
            break;
        }
        if([data objectAtIndex:i] == nil){
            continue;
        }
        if (i<chart.rangeTo-1 && [data objectAtIndex:(i+1)] != nil) {
            float value = [[[data objectAtIndex:i] objectAtIndex:0] floatValue];
            float ix  = sec.frame.origin.x+sec.paddingLeft+(i-chart.rangeFrom)*chart.plotWidth;
            float iNx  = sec.frame.origin.x+sec.paddingLeft+(i+1-chart.rangeFrom)*chart.plotWidth;
            float iy = [chart getLocalY:value withSection:section withAxis:yAxis];
            CGContextSetStrokeColorWithColor(context, color.CGColor);
            CGContextMoveToPoint(context, ix+chart.plotWidth/2, iy);
            
            float y = [chart getLocalY:([[[data objectAtIndex:(i+1)] objectAtIndex:0] floatValue]) withSection:section withAxis:yAxis];
            if(!isnan(y)){
   
                CGContextAddLineToPoint(context, iNx+chart.plotWidth/2, y);
            }
            
            CGContextStrokePath(context);
            
            //画出x轴上中间的时间点
            NSString *tipsText = [NSString stringWithFormat:@"%@",[category objectAtIndex:i +1]];

        
            NSArray * allTimesArray = data[0][5];

            if ([allTimesArray containsObject:tipsText]&&allTimesArray.count > 2) {

               NSInteger index = [allTimesArray indexOfObject:tipsText];
                
                if (index != 0) {
                    BOOL indexOddEven = index % 2;
                    if (!indexOddEven) {
                        NSString * timeStr = [NSString stringWithFormat:@"%@/%@",allTimesArray[index - 1],allTimesArray[index]];
                        
                        CGSize textSize = [timeStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kYFontSizeFenShi]}];
                        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
                        style.alignment = NSTextAlignmentCenter;
                        [timeStr drawInRect:CGRectMake(sec.frame.origin.x+sec.paddingLeft+(i+1-chart.rangeFrom)*chart.plotWidth - textSize.width/2, sec.frame.origin.y + sec.frame.size.height + 2, textSize.width, kYFontSizeFenShi*2) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kYFontSizeFenShi],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:kXWorldColor}];
                    }
                }
            }
        }
    }
    
    
//    NSLog(@"--%@",category);
    //标记X轴时间，只标记首尾
    NSArray * allTimesArray = data[0][5];
    
//    NSArray * timeArray = [intervalTime componentsSeparatedByString:@"-"];

    NSString * fromDate = [allTimesArray firstObject];
    NSString * toDate = [allTimesArray lastObject];

//    NSLog(@"%@",data);
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    [fromDate drawInRect:CGRectMake(sec.frame.origin.x + sec.paddingLeft, sec.frame.origin.y + sec.frame.size.height + 2, 30, kYFontSizeFenShi*2) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kYFontSizeFenShi],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:kXWorldColor}];

    style.alignment = NSTextAlignmentRight;
    [toDate drawInRect:CGRectMake(sec.frame.origin.x + sec.frame.size.width - 30, sec.frame.origin.y + sec.frame.size.height + 2, 30, kYFontSizeFenShi*2) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kYFontSizeFenShi],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:kXWorldColor}];
}

-(void)setValuesForYAxis:(EverChart *)chart serie:(NSDictionary *)serie{
    if([[serie objectForKey:@"data"] count] == 0){
        return;
    }
    
    NSMutableArray *data    = [serie objectForKey:@"data"];
    NSString       *yAxis   = [serie objectForKey:@"yAxis"];
    NSString       *yAxisType   = [serie objectForKey:@"yAxisType"];
    NSString       *section = [serie objectForKey:@"section"];
    
    YAxis *yaxis = [[[chart.sections objectAtIndex:[section intValue]] yAxises] objectAtIndex:[yAxis intValue]];
    if([serie objectForKey:@"decimal"] != nil){
        yaxis.decimal = [[serie objectForKey:@"decimal"] intValue];
    }
//    NSLog(@"rangeFrom:%ld",chart.rangeFrom);
//    NSLog(@"data:%ld",data.count);
//    NSLog(@"data:%@",data[chart.rangeFrom - 1]);
    
    if (chart.rangeFrom >= data.count) {
        return;
    }
    float value = [[[data objectAtIndex:chart.rangeFrom] objectAtIndex:0] floatValue];
    
    if(!yaxis.isUsed){
        [yaxis setMax:value];
        [yaxis setMin:value];
        yaxis.isUsed = YES;
    }
    
    //实时价格线:  Y轴区间:昨天收盘价 上下浮动最大涨跌幅； 当前最大涨跌幅 ：（最大/最小 - 昨天收盘价）/ 昨天收盘价
    if ([yAxisType isEqualToString:@"1"]) {
        
        float maxNow = 0,minNow = MAXFLOAT;
        float closeYesterday = [[data[0] objectAtIndex:0] floatValue];
        
        for(int i = 0; i < data.count; i++) {
            NSArray *tmpArray = data[i];
            float now = [tmpArray[0] floatValue];
            if (minNow > now) {
                minNow = now;
            }
            else if (maxNow < now) {
                maxNow = now;
            }
        }
        
        float percentMax = (maxNow - closeYesterday)/closeYesterday;
        float percentMin = (minNow - closeYesterday)/closeYesterday;
        float percent = MAX(fabs(percentMax), fabs(percentMin)) ;
        float maxY = closeYesterday * (1 + percent);
        float minY = closeYesterday * (1 - percent);
        
        [yaxis setMax:maxY];
        [yaxis setMin:minY];
        //NSLog(@"min:%f,max:%f",minY,maxY);
        
        return;
    }
    
    for(NSInteger i=chart.rangeFrom;i<chart.rangeTo;i++){
        if(i == data.count){
            break;
        }
        if([data objectAtIndex:i] == nil){
            continue;
        }
        
        float value = [[[data objectAtIndex:i] objectAtIndex:0] floatValue];
        if(value > [yaxis max])
            [yaxis setMax:value];
        if(value < [yaxis min])
            [yaxis setMin:value];
    }
}
//画出最上方的交易信息
-(void)setLabel:(EverChart *)chart label:(NSMutableArray *)label forSerie:(NSMutableDictionary *) serie{
    if([serie objectForKey:@"data"] == nil || [[serie objectForKey:@"data"] count] == 0){
        return;
    }
    
    NSMutableArray *data          = [serie objectForKey:@"data"];
    //	NSString       *type          = [serie objectForKey:@"type"];
    NSString       *lbl           = [serie objectForKey:@"label"];
    int            yAxis          = [[serie objectForKey:@"yAxis"] intValue];
    NSString       *yAxisType     = [serie objectForKey:@"yAxisType"];
    int            section        = [[serie objectForKey:@"section"] intValue];
    UIColor       *color         = [serie objectForKey:@"color"];
    
    YAxis *yaxis = [[[chart.sections objectAtIndex:section] yAxises] objectAtIndex:yAxis];
    NSString *format = [NSString stringWithFormat:@"%@:%%.%df",lbl,yaxis.decimal];
    
    if(chart.selectedIndex!=-1 && chart.selectedIndex < data.count && [data objectAtIndex:chart.selectedIndex]!=nil){
        float value = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:0] floatValue];
        float openPrice = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:2] floatValue];

        if ([yAxisType isEqualToString:@"1"]) {
            
            float closeYesterday = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:1] floatValue];
            UIColor *lblColor = [UIColor grayColor];
            
            if (value < closeYesterday) { //下跌
                lblColor = kFenShiDownColor;
            }
            else if(value > closeYesterday){ //上涨
                lblColor = kFenShiUpColor;
            }
            else{ //持平
                lblColor = kFenShiEqualColor;
            }
            //NSLog(@"画啊画");
            //实时价格标签
            NSString *text = [NSString stringWithFormat:format,value];
            [label addObject:@{@"text":text,@"color":lblColor}];
            
            //差值
            format = [NSString stringWithFormat:@" %%.%df ",yaxis.decimal];
            //NSLog(@"差值format:%@",format);
            NSString *diffValue = [NSString stringWithFormat:format,value - closeYesterday];
            [label addObject:@{@"text":diffValue,@"color":lblColor}];
            
            //差值百分比
            //NSLog(@"%d",yaxis.decimal);
            format = [NSString stringWithFormat:@"%%.%df",yaxis.decimal];
            //NSLog(@"format:%@",format);
            NSString *diffPercent = [NSString stringWithFormat:@"%.2f%%",(value - closeYesterday)/closeYesterday * 100];
            //NSLog(@"diffPercent：%@",diffPercent);
            [label addObject:@{@"text":diffPercent,@"color":lblColor}];
            
            //实时价格中的最高价/最低价
//            float maxPrice = 0;
//            float minPrice = MAXFLOAT;
//            for (NSArray *array in data) {
//                float nowPrice = [array[0] floatValue];
//                if (maxPrice < nowPrice) {
//                    maxPrice = nowPrice;
//                }
//                if(minPrice > nowPrice){
//                    minPrice = nowPrice;
//                }
//
//            }
//            float maxPrice = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:3] floatValue];
//            float minPrice = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:4] floatValue];
//            //最高
//            [label addObject:@{@"text":@"高",@"color":kFenShiEqualColor}];
//            lblColor = (maxPrice > closeYesterday)? kFenShiUpColor : (maxPrice < closeYesterday ? kFenShiDownColor :kFenShiEqualColor);
//            [label addObject:@{@"text":[NSString stringWithFormat:@"%.2f",maxPrice], @"color":lblColor}];
//            
//            //最低
//            [label addObject:@{@"text":@"低",@"color":kFenShiEqualColor}];
//            lblColor = (minPrice > closeYesterday)? kFenShiUpColor : (minPrice < closeYesterday ? kFenShiDownColor :kFenShiEqualColor);
//            [label addObject:@{@"text":[NSString stringWithFormat:@"%.2f",minPrice], @"color":lblColor}];
//            
//            //开盘价
//            [label addObject:@{@"text":@"开",@"color":kFenShiEqualColor}];
//            lblColor = (openPrice > closeYesterday)?kFenShiUpColor:kFenShiDownColor;
//            [label addObject:@{@"text":[NSString stringWithFormat:@"%.2f",openPrice], @"color":lblColor}];
//            
//            
        }else {
            
//            NSString *text = [NSString stringWithFormat:format,value];
//            
//            NSLog(@"ttt:%@",text);
//            NSDictionary *tmp = @{@"text":text,@"color":color};
//            [label addObject:tmp];
            
        }
        
    }
}
//显示点击时的时间
-(void)drawTips:(EverChart *)chart serie:(NSMutableDictionary *)serie cross:(NSInteger)cross{
    if (1 == cross) {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetShouldAntialias(context, NO);
        CGContextSetLineWidth(context, 0.5f);
        
        NSMutableArray *data          = [serie objectForKey:@"data"];
        NSString       *type          = [serie objectForKey:@"type"];
        int            section        = [[serie objectForKey:@"section"] intValue];
        NSMutableArray *category      = [serie objectForKey:@"category"];
        Section *sec = [chart.sections objectAtIndex:section];
        
        if([type isEqualToString:kFenShiLine]){
            for(NSInteger i=chart.rangeFrom;i<chart.rangeTo;i++){
                if(i == data.count){
                    break;
                }
                if([data objectAtIndex:i] == nil){
                    continue;
                }
                float ix  = sec.frame.origin.x+sec.paddingLeft+(i-chart.rangeFrom)*chart.plotWidth;
                
                if(i == chart.selectedIndex && chart.selectedIndex < data.count && [data objectAtIndex:chart.selectedIndex]!=nil){
                    
                    NSString *tipsText = [NSString stringWithFormat:@"%@",[category objectAtIndex:chart.selectedIndex]];
                    
                    CGContextSetShouldAntialias(context, YES);
                    CGContextSetStrokeColorWithColor(context, kYFontColor.CGColor);
                    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
                    
                    CGSize size = [tipsText sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:kYFontSizeFenShi]}];
                    
                    int x = ix+chart.plotWidth/2;
                    int y = sec.frame.origin.y+sec.paddingTop;
                    if(x+size.width > sec.frame.size.width+sec.frame.origin.x){
                        x= x-(size.width+4);
                    }
                    CGContextFillRect (context, CGRectMake (x, y, size.width+4,size.height+2));
                    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, size.width+4,size.height+2) cornerRadius:4];
                    CGContextAddPath(context, path.CGPath);
                    CGContextStrokePath(context);
                    
                    [tipsText drawAtPoint:CGPointMake(x+2,y+1) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:kYFontSizeFenShi],NSForegroundColorAttributeName:kYFontColor}];
                    CGContextSetShouldAntialias(context, NO);
                    
                    
                }
            }
        }
    }
    
}

@end
