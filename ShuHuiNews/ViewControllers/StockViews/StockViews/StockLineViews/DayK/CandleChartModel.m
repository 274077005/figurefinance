//
//  CandleChartModel.m
//  chartee
//
//  Created by zzy on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CandleChartModel.h"

@implementation CandleChartModel

-(void)drawSerie:(EverChart *)chart serie:(NSMutableDictionary *)serie cross:(NSInteger)cross{
    //上涨颜色
    serie[@"color"] = [UIColor colorWithRed:252/255.0 green:15/255.0 blue:29/255.0 alpha:1];
    serie[@"negativeColor"] = [UIColor colorWithRed:22/255.0 green:151/255.0 blue:25/255.0 alpha:1];
    serie[@"selectedColor"] = [UIColor colorWithRed:176/255.0 green:52/255.0 blue:52/255.0 alpha:1];
    serie[@"negativeSelectedColor"] = [UIColor colorWithRed:77/255.0 green:143/255.0 blue:42/255.0 alpha:1];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, NO);
    CGContextSetLineWidth(context, 1.0f);
    
    NSMutableArray *data          = serie[@"data"];
    int            yAxis          = [serie[@"yAxis"] intValue];
    int            section        = [serie[@"section"] intValue];
    UIColor       *color         = serie[@"color"];
    UIColor       *negativeColor = serie[@"negativeColor"];
    UIColor       *selectedColor = serie[@"selectedColor"];
    UIColor       *negativeSelectedColor = serie[@"negativeSelectedColor"];
    
    
    Section *sec = chart.sections[section];
    for(NSInteger i=chart.rangeFrom;i<chart.rangeTo;i++){
        if(i == data.count){
            break;
        }
        if(data[i] == nil){
            continue;
        }
        
        float high  = [[data[i] objectAtIndex:2] floatValue];
        float low   = [[data[i] objectAtIndex:3] floatValue];
        float open  = [[data[i] objectAtIndex:0] floatValue];
        float close = [[data[i] objectAtIndex:1] floatValue];
        
        float ix  = sec.frame.origin.x+sec.paddingLeft+(i-chart.rangeFrom)*chart.plotWidth;
        float iNx = sec.frame.origin.x+sec.paddingLeft+(i+1-chart.rangeFrom)*chart.plotWidth;
        float iyo = [chart getLocalY:open withSection:section withAxis:yAxis];
        float iyc = [chart getLocalY:close withSection:section withAxis:yAxis];
        float iyh = [chart getLocalY:high withSection:section withAxis:yAxis];
        float iyl = [chart getLocalY:low withSection:section withAxis:yAxis];
        
        if(i == chart.selectedIndex && chart.selectedIndex < data.count && data[chart.selectedIndex] !=nil){
            //            CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.2 green:0.2 blue:0.2 alpha:1.0].CGColor);
            //            CGContextMoveToPoint(context, ix+chart.plotWidth/2, sec.frame.origin.y+sec.paddingTop);
            //            CGContextAddLineToPoint(context,ix+chart.plotWidth/2,sec.frame.size.height+sec.frame.origin.y);
            //            CGContextStrokePath(context);
        }
        
        if(close == open){
            if(i == chart.selectedIndex){
                CGContextSetStrokeColorWithColor(context, selectedColor.CGColor);
            }else{
                CGContextSetStrokeColorWithColor(context, selectedColor.CGColor);
            }
        }else{
            if(close < open){
                //                if(i == chart.selectedIndex){
                //                    CGContextSetStrokeColorWithColor(context, negativeSelectedColor.CGColor);
                //                    CGContextSetFillColorWithColor(context, negativeSelectedColor.CGColor);
                //                }else{
                //                    CGContextSetStrokeColorWithColor(context, negativeColor.CGColor);
                //                    CGContextSetFillColorWithColor(context, negativeColor.CGColor);
                //                }
                if (chart.nowOrDay == 999) {
                    CGContextSetStrokeColorWithColor(context, kFenShiUpColor.CGColor);
                    CGContextSetFillColorWithColor(context, kFenShiUpColor.CGColor);
                    
                }else{
                    CGContextSetStrokeColorWithColor(context, kFenShiDownColor.CGColor);
                    CGContextSetFillColorWithColor(context, kFenShiDownColor.CGColor);
                }
                
            }else{
                if (chart.nowOrDay == 999) {
                    CGContextSetStrokeColorWithColor(context, kFenShiDownColor.CGColor);
                    CGContextSetFillColorWithColor(context, kFenShiDownColor.CGColor);
                }else{
                    CGContextSetStrokeColorWithColor(context, kFenShiUpColor.CGColor);
                    CGContextSetFillColorWithColor(context, kFenShiUpColor.CGColor);
                }
                
            }
        }
        
        if(close == open){
            CGContextMoveToPoint(context, ix+chart.plotPadding, iyo);
            CGContextAddLineToPoint(context, iNx-chart.plotPadding,iyo);
            CGContextStrokePath(context);
            
        }else{
            if(close < open){
                CGContextFillRect (context, CGRectMake (ix+chart.plotPadding, iyo, chart.plotWidth-2*chart.plotPadding,iyc-iyo));
            }else{
                CGContextFillRect (context, CGRectMake (ix+chart.plotPadding, iyc, chart.plotWidth-2*chart.plotPadding, iyo-iyc));
            }
        }
        
        CGContextMoveToPoint(context, ix+chart.plotWidth/2, iyh);
        CGContextAddLineToPoint(context,ix+chart.plotWidth/2,iyl);
        CGContextStrokePath(context);
    }
}

-(void)setValuesForYAxis:(EverChart *)chart serie:(NSDictionary *)serie{
    if([serie[@"data"] count] == 0){
        return;
    }
    
    NSMutableArray *data    = serie[@"data"];
    NSString       *yAxis   = serie[@"yAxis"];
    NSString       *section = serie[@"section"];
    
    YAxis *yaxis = [[chart.sections objectAtIndex:[section intValue]] yAxises][[yAxis intValue]];
    
    float high = [[data[chart.rangeFrom] objectAtIndex:2] floatValue];
    float low = [[data[chart.rangeFrom] objectAtIndex:3] floatValue];
    
    if(!yaxis.isUsed){
        [yaxis setMax:high];
        [yaxis setMin:low];
        yaxis.isUsed = YES;
    }
    
    for(NSInteger i=chart.rangeFrom;i<chart.rangeTo;i++){
        if(i == data.count){
            break;
        }
        if(data[i] == nil){
            continue;
        }
        
        float high = [[data[i] objectAtIndex:2] floatValue];
        float low = [[data[i] objectAtIndex:3] floatValue];
        if(high > [yaxis max])
            [yaxis setMax:high];
        if(low < [yaxis min])
            [yaxis setMin:low];
    }
}

-(void)setLabel:(EverChart *)chart label:(NSMutableArray *)label forSerie:(NSMutableDictionary *) serie{
    if(serie[@"data"] == nil || [serie[@"data"] count] == 0){
        return;
    }
    
    NSMutableArray *data          = serie[@"data"];
    UIColor       *color         = serie[@"color"];
    UIColor       *negativeColor = serie[@"negativeColor"];
    
    if(chart.selectedIndex!=-1 && chart.selectedIndex < data.count && data[chart.selectedIndex] !=nil){
        float high  = [[data[chart.selectedIndex] objectAtIndex:2] floatValue];
        float low   = [[data[chart.selectedIndex] objectAtIndex:3] floatValue];
        float open  = [[data[chart.selectedIndex] objectAtIndex:0] floatValue];
        float close = [[data[chart.selectedIndex] objectAtIndex:1] floatValue];
        float inc   =  (close-open)*100/open;
        
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
        NSMutableString *l = [[NSMutableString alloc] init];
        [l appendFormat:@"开:%.2f ",open];
        tmp[@"text"] = l;
        tmp[@"color"] = tmp[@"color"] = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        [label addObject:tmp];
        
        tmp = [[NSMutableDictionary alloc] init];
        l = [[NSMutableString alloc] init];
        [l appendFormat:@"收:%.2f ",close];
        tmp[@"text"] = l;
        if(close>open){
            tmp[@"color"] = color;
        }else if (close < open) {
            tmp[@"color"] = negativeColor;
        }else{
            tmp[@"color"] = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        }
        [label addObject:tmp];
        
        
        tmp = [[NSMutableDictionary alloc] init];
        l = [[NSMutableString alloc] init];
        [l appendFormat:@"高:%.2f ",high];
        tmp[@"text"] = l;
        if(high>open){
            tmp[@"color"] = color;
        }else{
            tmp[@"color"] = negativeColor;
        }
        
        [label addObject:tmp];
        
        tmp = [[NSMutableDictionary alloc] init];
        l = [[NSMutableString alloc] init];
        [l appendFormat:@"低:%.2f ",low];
        tmp[@"text"] = l;
        if(low>open){
            tmp[@"color"] = color;
        }else if(low<open){
            tmp[@"color"] = negativeColor;
        }else{
            tmp[@"color"] = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        }
        [label addObject:tmp];
        
        
        tmp = [[NSMutableDictionary alloc] init];
        l = [[NSMutableString alloc] init];
        [l appendFormat:@"Change:%.2f%@  ",inc,@"%"];
        if(inc > 0){
            tmp[@"color"] = color;
        }else if(inc < 0){
            tmp[@"color"] = negativeColor;
        }else{
            tmp[@"color"] = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        }
        [label addObject:tmp];
    }
    
}


@end
