//
//  LineChartModel.m
//  chartee
//
//  Created by zzy on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LineChartModel.h"
#import "YYEverColor.h"
@implementation LineChartModel

-(void)drawSerie:(EverChart *)chart serie:(NSMutableDictionary *)serie cross:(NSInteger)cross{
    if([serie objectForKey:@"data"] == nil || [[serie objectForKey:@"data"] count] == 0){
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, YES);
    CGContextSetLineWidth(context, 1.0f);
    
    NSMutableArray *data          = serie[@"data"];
    int            yAxis          = [serie[@"yAxis"] intValue];
    int            section        = [serie[@"section"] intValue];
    UIColor         *color          = serie[@"color"];
    
    Section *sec = chart.sections[section];
    //设置选中点 竖线以及小球颜色 十字线开始
    if (1 == cross) {
        
        if(chart.selectedIndex!=-1 && chart.selectedIndex < data.count && data[chart.selectedIndex] !=nil && [[data objectAtIndex:chart.selectedIndex] isKindOfClass:[NSArray class]]){
            //设置选中点竖线
            float value = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:0] floatValue];
            
            CGContextSetShouldAntialias(context, YES);
            CGContextSetLineWidth(context, 0.8);
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
            Section *sec = [chart.sections objectAtIndex:0];
            if (chart.touchY > sec.paddingTop + chart.paddingTop && chart.touchY < sec.frame.size.height + chart.paddingTop) {
                //NSLog(@"画横线");
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
                
                NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:kYFontSizeFenShi],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:kYFontColor};
                CGSize textSize = [text sizeWithAttributes:attributes];

                CGRect rect = CGRectMake(sec.paddingLeft + sec.frame.origin.x - textSize.width - 3, chart.touchY - (textSize.height + 2)/2.0, textSize.width + 2, textSize.height + 2);
                //设置抗锯齿效果
                CGContextSetShouldAntialias(context, YES);
                //设置横线左框字体颜色
                CGContextSetStrokeColorWithColor(context, kYFontColor.CGColor);
                //设置横线左框背景颜色
                CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
                CGContextSetLineWidth(context, 1);
                
                //不进行填充就是透明的
                //CGContextFillRect(context, rect);
                
                
                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:4];
                CGContextAddPath(context, path.CGPath);
                CGContextStrokePath(context);
                
                [text drawInRect:rect withAttributes:attributes];
                
            }
        }
    }
    //十字线结束
    for(NSInteger i=chart.rangeFrom;i<chart.rangeTo;i++){
        if(i == data.count-1){
            break;
        }
        if([data objectAtIndex:i] == nil){
            continue;
        }
        
        if (![[data objectAtIndex:i] isKindOfClass:[NSArray class]]) {
            continue;
        }
        
        if (i<chart.rangeTo-1 && [data objectAtIndex:(i+1)] != nil) {
            float value = [[[data objectAtIndex:i] objectAtIndex:0] floatValue];
            float ix  = sec.frame.origin.x+sec.paddingLeft+(i-chart.rangeFrom)*chart.plotWidth;
            float iNx  = sec.frame.origin.x+sec.paddingLeft+(i+1-chart.rangeFrom)*chart.plotWidth;
            float iy = [chart getLocalY:value withSection:section withAxis:yAxis];
            CGContextSetStrokeColorWithColor(context, color.CGColor);

            CGContextMoveToPoint(context, ix+chart.plotWidth/2, iy);
            CGContextAddLineToPoint(context, iNx+chart.plotWidth/2,[chart getLocalY:([[[data objectAtIndex:(i+1)] objectAtIndex:0] floatValue]) withSection:section withAxis:yAxis]);
            CGContextStrokePath(context);
        }
    }

    
}

-(void)setValuesForYAxis:(EverChart *)chart serie:(NSDictionary *)serie{
    if([[serie objectForKey:@"data"] count] == 0){
        return;
    }
    
    NSMutableArray *data    = [serie objectForKey:@"data"];
    NSString       *yAxis   = [serie objectForKey:@"yAxis"];
    NSString       *section = [serie objectForKey:@"section"];
    
    YAxis *yaxis = [[[chart.sections objectAtIndex:[section intValue]] yAxises] objectAtIndex:[yAxis intValue]];
    if([serie objectForKey:@"decimal"] != nil){
        yaxis.decimal = [[serie objectForKey:@"decimal"] intValue];
    }
    
    if ([[data objectAtIndex:chart.rangeFrom] isKindOfClass:[NSArray class]]) {
        float value = [[[data objectAtIndex:chart.rangeFrom] objectAtIndex:0] floatValue];
        
        if(!yaxis.isUsed){
            [yaxis setMax:value];
            [yaxis setMin:value];
            yaxis.isUsed = YES;
        }
    }
    
    for(NSInteger i=chart.rangeFrom;i<chart.rangeTo;i++){
        if(i == data.count){
            break;
        }
        if([data objectAtIndex:i] == nil){
            continue;
        }
        if(![[data objectAtIndex:i] isKindOfClass:[NSArray class]]){
            continue;
        }
        
        
        float value = [[[data objectAtIndex:i] objectAtIndex:0] floatValue];
        if(value > [yaxis max])
            [yaxis setMax:value];
        if(value < [yaxis min])
            [yaxis setMin:value];
        
        /////////////// 本人添加的处理当数据全是一样的情况
        if (value == yaxis.max && value == yaxis.min) {
            [yaxis setMax:value+0.1];
            [yaxis setMin:value-0.1];
        }
        /////////////// 本人添加的处理当数据全是一样的情况
    }
}
//设置第二和第三图之间的字
-(void)setLabel:(EverChart *)chart label:(NSMutableArray *)label forSerie:(NSMutableDictionary *) serie{
    if(serie[@"data"] == nil || [serie[@"data"] count] == 0){
        return;
    }
    
    NSMutableArray *data          = serie[@"data"];
    //NSString       *type          = serie[@"type"];
    NSString       *lbl           = serie[@"label"];
    int            yAxis          = [serie[@"yAxis"] intValue];
    int            section        = [serie[@"section"] intValue];
    NSString       * color         = serie[@"color"];
    YAxis *yaxis = [[chart.sections objectAtIndex:section] yAxises][yAxis];
    NSString *format=[@"%." stringByAppendingFormat:@"%df",yaxis.decimal];
    
    if(chart.selectedIndex!=-1 && chart.selectedIndex < data.count && [data objectAtIndex:chart.selectedIndex]!=nil){
        float value = 0;
        if ([[data objectAtIndex:chart.selectedIndex] isKindOfClass:[NSArray class]]) {
            value = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:0] floatValue];
        }
        
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
        NSMutableString *l = [[NSMutableString alloc] init];
        //NSString *fmt = [@"%@:" stringByAppendingFormat:@"%@",format];
        NSString *fmt = [@"%@:" stringByAppendingFormat:@"%@ ", format];
        [l appendFormat:fmt,lbl,value];
        tmp[@"text"] = l;
        
        tmp[@"color"] = color;
        
        [label addObject:tmp];
    }
}
-(void)drawTips:(EverChart *)chart serie:(NSMutableDictionary *)serie cross:(NSInteger)cross{

    if(serie[@"data"] == nil || [serie[@"data"] count] == 0){
        return;
    }
    NSMutableArray *data          = [serie objectForKey:@"data"];
    NSString       *type          = [serie objectForKey:@"type"];
    int            section        = [[serie objectForKey:@"section"] intValue];
    NSMutableArray *category      = [serie objectForKey:@"category"];
    //抗锯齿
    CGContextRef context = UIGraphicsGetCurrentContext();
    Section *sec = [chart.sections objectAtIndex:section];
    if (1 == cross) {

        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetShouldAntialias(context, NO);
        CGContextSetLineWidth(context, 1.0f);
        
//        NSMutableArray *data          = [serie objectForKey:@"data"];
//        NSString       *type          = [serie objectForKey:@"type"];
//        int            section        = [[serie objectForKey:@"section"] intValue];
//        NSMutableArray *category      = [serie objectForKey:@"category"];
//        Section *sec = [chart.sections objectAtIndex:section];
        
        if([type isEqualToString:@"candle"]){
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
    CGContextSetShouldAntialias(context, YES);
    //dayK起止时间
//    NSLog(@"%ld",data.count);
//    NSLog(@"countqqqq:%ld",category.count);

//    NSLog(@"%ld",chart.rangeFrom);
    
//    NSLog(@"%@",category[chart.rangeFrom]);
//    NSLog(@"%@",[category[chart.rangeFrom]substringFromIndex:[category[chart.rangeFrom] length]- 5]);
    
    NSString * fromDate = [category[chart.rangeFrom]substringFromIndex:[category[chart.rangeFrom] length]- 5];


    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    [fromDate drawInRect:CGRectMake(sec.frame.origin.x + sec.paddingLeft - 18, sec.frame.origin.y + sec.frame.size.height + 2, 30, kYFontSizeFenShi*2) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kYFontSizeFenShi],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:kXWorldColor}];
    //当缩小k线图的时候 防止越界
    if(chart.rangeTo -1 < category.count){
        NSString * toDate = [category[chart.rangeTo - 1]substringFromIndex:[category[chart.rangeTo - 1] length]- 5];
        style.alignment = NSTextAlignmentRight;
        [toDate drawInRect:CGRectMake(sec.frame.origin.x + sec.frame.size.width - 30, sec.frame.origin.y + sec.frame.size.height + 2, 30, kYFontSizeFenShi*2) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kYFontSizeFenShi],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:kXWorldColor}];
    }
    
}

@end
