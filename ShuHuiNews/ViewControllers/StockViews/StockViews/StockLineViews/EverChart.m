//
//  ChartFenShi.m
//  TestChart
//
//  Created by Ever on 15/12/18.
//  Copyright © 2015年 Lucky. All rights reserved.
//

#import "EverChart.h"
#import "YYEverColor.h"

#define MIN_INTERVAL  3

@interface EverChart ()
{
    NSDate * BeforeDate;
    NSDate * NowDate;
    NSTimeInterval BeforeTime;
    NSTimeInterval NowTime;
}

@end

@implementation EverChart


@synthesize enableSelection;
@synthesize isInitialized;
@synthesize isSectionInitialized;
@synthesize borderColor;
@synthesize borderWidth;
@synthesize plotWidth;
@synthesize plotPadding;
@synthesize plotCount;
@synthesize paddingLeft;
@synthesize paddingRight;
@synthesize paddingTop;
@synthesize paddingBottom;
@synthesize padding;
@synthesize selectedIndex;
@synthesize touchFlag;
@synthesize touchFlagTwo;
@synthesize rangeFrom;
@synthesize rangeTo;
@synthesize range;
@synthesize series;
@synthesize sections;
@synthesize ratios;
@synthesize models;
@synthesize title;


- (void)drawRect:(CGRect)rect
{
//    NSLog(@"drawrect");
//    NSLog(@"drange:%ld",self.range);
    [self initChart];
    [self initSections];
    [self initXAxis];
    [self initYAxis];
    [self drawXAxis];
    [self drawYAxis];
    
    [self drawChart];
    [self initModels];
    //init models
    
    
    
    
}

-(float)getLocalY:(float)val withSection:(int)sectionIndex withAxis:(int)yAxisIndex{
    Section *sec = [[self sections] objectAtIndex:sectionIndex];
    
    YAxis *yaxis = [sec.yAxises objectAtIndex:yAxisIndex];
    
    CGRect fra = sec.frame;
    float  max = yaxis.max;
    float  min = yaxis.min;
    //NSLog(@"max%f:",max);
    
    if (max == min) {
        return 0;
    }
    return fra.size.height - (fra.size.height-sec.paddingTop)* (val-min)/(max-min)+fra.origin.y;
}

- (void)initChart{
//    NSLog(@"self.isInitialized:%d",self.isInitialized);
    if(!self.isInitialized){
        //设置柱状水平间距
        self.plotPadding = 1.0f;
//        设置内边距（上右下左）
        if(self.padding != nil){
            self.paddingTop    = [[self.padding objectAtIndex:0] floatValue];
            
            self.paddingRight  = [[self.padding objectAtIndex:1] floatValue];

            self.paddingBottom = [[self.padding objectAtIndex:2] floatValue];
            
            self.paddingLeft   = [[self.padding objectAtIndex:3] floatValue];
        }
        
        if(self.series!=nil){
            //获取有多少个数据
//            NSLog(@"rangeto:%ld",rangeTo);

//                NSLog(@"等于0了啊啊啊啊");
            self.rangeTo = (int)[[[[self series] objectAtIndex:0] objectForKey:@"data"] count];

//            NSLog(@"rangefrom:%ld",self.rangeFrom);
            if(rangeTo-range >= 0){
                //设置刚进k线显示多少个柱状图
                
                self.rangeFrom = rangeTo-range;
//                NSLog(@"rangTo11:%ld",rangeTo);
//                NSLog(@"rang1111:%ld",range);
//                NSLog(@"rangeFrom111:%ld",self.rangeFrom);
            }else{
                
                self.rangeFrom = 0;
            }
//            NSLog(@"rangeTo:%ld",self.rangeTo);
            
            

        }else{
            self.rangeTo   = 0;
            self.rangeFrom = 0;
        }
        //NSLog(@"rangeTo:%d",rangeTo);
        //判断选中的下标
        self.selectedIndex = self.rangeTo-1;
        //初始化状态设为YES
        self.isInitialized = YES;
    }
    
    if(self.series!=nil){
        
        self.plotCount = [[[[self series] objectAtIndex:0] objectForKey:@"data"] count];
        //NSLog(@"self.plotCount:%f",self.plotCount);
    }
    //获取当前画板
    CGContextRef context = UIGraphicsGetCurrentContext();
    //画板填充颜色
    CGContextSetRGBFillColor(context,
                             22/255.0, 25/255.0, 32/255.0, 1.0);
//    CGContextSetRGBFillColor(context,
//                             255/255.0, 255/255.0, 255/255.0, 1.0);
    //设置大小
    CGContextFillRect (context, CGRectMake (0, 0, self.bounds.size.width,self.bounds.size.height));
    //    NSLog(@"width:%f",self.bounds.size.width);
    //    NSLog(@"height:%f",self.bounds.size.height);
}
//设置初始化状态为NO
-(void)reset{
    self.isInitialized = NO;
}

- (void)initXAxis{
    
}

- (void)initYAxis{
    
    for(int secIndex=0;secIndex<[self.sections count];secIndex++){
        Section *sec = [self.sections objectAtIndex:secIndex];
        //NSLog(@"secIndex：%d",secIndex);
        
        for(int sIndex=0;sIndex<[sec.yAxises count];sIndex++){
            //NSLog(@"sIndex:%lu",[sec.yAxises count]);
            YAxis *yaxis = [sec.yAxises objectAtIndex:sIndex];
            yaxis.isUsed = NO;
        }
    }
    
    for(int secIndex=0;secIndex<[self.sections count];secIndex++){
        Section *sec = [self.sections objectAtIndex:secIndex];
        
        if(sec.paging && [[sec series] count] && self.nowOrDay != 0){
            NSObject *serie = [[sec series] objectAtIndex:sec.selectedIndex];
            if([serie isKindOfClass:[NSArray class]]){
                NSArray *se = (NSArray *)serie;
                for(int i=0;i<[se count];i++){
                    [self setValuesForYAxis:[se objectAtIndex:i]];
                    //NSLog(@"进不来");
                }
            }else {
                //NSLog(@"进不来");
                [self setValuesForYAxis:(NSDictionary *)serie];
            }
            //NSLog(@"进不来");
        }else{
            for(int sIndex=0;sIndex<[sec.series count];sIndex++){
                //NSLog(@"啦啦");
                NSObject *serie = [[sec series] objectAtIndex:sIndex];
                //NSLog(@"serie:%@",serie);
                if([serie isKindOfClass:[NSArray class]]){
                    NSArray *se = (NSArray *)serie;
                    for(int i=0;i<[se count];i++){
                        [self setValuesForYAxis:[se objectAtIndex:i]];
                    }
                }else {
                    [self setValuesForYAxis:(NSDictionary *)serie];
                }
            }
        }
        
        for(int i = 0;i<sec.yAxises.count;i++){
            YAxis *yaxis = [sec.yAxises objectAtIndex:i];
            yaxis.max += (yaxis.max-yaxis.min)*yaxis.ext;
            yaxis.min -= (yaxis.max-yaxis.min)*yaxis.ext;
            
            if(!yaxis.baseValueSticky){
                if(yaxis.max >= 0 && yaxis.min >= 0){
                    yaxis.baseValue = yaxis.min;
                }else if(yaxis.max < 0 && yaxis.min < 0){
                    yaxis.baseValue = yaxis.max;
                }else{
                    yaxis.baseValue = 0;
                }
            }else{
                if(yaxis.baseValue < yaxis.min){
                    yaxis.min = yaxis.baseValue;
                }
                
                if(yaxis.baseValue > yaxis.max){
                    yaxis.max = yaxis.baseValue;
                }
            }
            
            if(yaxis.symmetrical == YES){
                if(yaxis.baseValue > yaxis.max){
                    yaxis.max =  yaxis.baseValue + (yaxis.baseValue-yaxis.min);
                }else if(yaxis.baseValue < yaxis.min){
                    yaxis.min =  yaxis.baseValue - (yaxis.max-yaxis.baseValue);
                }else {
                    if((yaxis.max-yaxis.baseValue) > (yaxis.baseValue-yaxis.min)){
                        yaxis.min =  yaxis.baseValue - (yaxis.max-yaxis.baseValue);
                    }else{
                        yaxis.max =  yaxis.baseValue + (yaxis.baseValue-yaxis.min);
                    }
                }
            }
        }
        
    }
}

-(void)setValuesForYAxis:(NSDictionary *)serie{
    NSString   *type  = [serie objectForKey:@"type"];
    ChartModel *model = [self getModel:type];
    [model setValuesForYAxis:self serie:serie];
}



-(void)drawChart{
    
    for(int secIndex=0;secIndex<self.sections.count;secIndex++){
        Section *sec = [self.sections objectAtIndex:secIndex];
        if(sec.hidden){
            continue;
        }
//        NSLog(@"2222222");
//        NSLog(@"range:%ld",self.range);
        //设置每个数据的宽度
        if (0 == self.nowOrDay) {
            plotWidth = (sec.frame.size.width - sec.paddingLeft)/self.range;
        }else{
            plotWidth = (sec.frame.size.width-sec.paddingLeft)/(self.rangeTo-self.rangeFrom);
        }
//        NSLog(@"range2:%ld",self.range);
        for(int sIndex=0;sIndex<sec.series.count;sIndex++){
            NSObject *serie = [sec.series objectAtIndex:sIndex];
            
            if(sec.hidden){
                continue;
            }
            
            if(sec.paging){
                if (sec.selectedIndex == sIndex) {
                    if([serie isKindOfClass:[NSArray class]]){
                        NSArray *se = (NSArray *)serie;
                        for(int i=0;i<[se count];i++){
                            //NSLog(@"非字典");
                            [self drawSerie:[se objectAtIndex:i]];
                        }
                    }else{
                        //NSLog(@"字典");
                        [self drawSerie:(NSMutableDictionary *)serie];
                    }
                    break;
                }
            }else{
                if([serie isKindOfClass:[NSArray class]]){
                    NSArray *se = (NSArray *)serie;
                    for(int i=0;i<[se count];i++){
                        [self drawSerie:[se objectAtIndex:i]];
                    }
                }else{

                    [self drawSerie:(NSMutableDictionary *)serie];
                }
            }
        }
    }
    [self drawLabels];
}

-(void)drawLabels{
    
    for(int i=0;i<self.sections.count;i++){
        Section *sec = [self.sections objectAtIndex:i];
        if(sec.hidden){
            continue;
        }
        
        float w = 0;
        //辅助分时图文字换行
        float h = 0;
        float MAWidth = SCREEN_WIDTH/3;
        for(int s=0;s<sec.series.count;s++){
            
            NSMutableArray *label =[[NSMutableArray alloc] init];
            NSObject *serie = [sec.series objectAtIndex:s];
            
            if(sec.paging){
                if (sec.selectedIndex == s) {
                    if([serie isKindOfClass:[NSArray class]]){
                        NSArray *se = (NSArray *)serie;
                        for(int i=0;i<[se count];i++){
                            [self setLabel:label forSerie:[se objectAtIndex:i]];
                        }
                    }else{
                        [self setLabel:label forSerie:(NSMutableDictionary *)serie];
                    }
                }
            }else{
                if([serie isKindOfClass:[NSArray class]]){
                    NSArray *se = (NSArray *)serie;
                    for(int i=0;i<[se count];i++){
                        [self setLabel:label forSerie:[se objectAtIndex:i]];
                    }
                }else{
                    [self setLabel:label forSerie:(NSMutableDictionary *)serie];
                }
            }
            for(int j=0;j<label.count;j++){
                
                NSMutableDictionary *lbl = [label objectAtIndex:j];
                //NSLog(@"[label objectAtIndex:j]:%@",[label objectAtIndex:j]);
                NSString *text  = [lbl objectForKey:@"text"];
               
                UIColor *textColor = [lbl objectForKey:@"color"];
//                NSLog(@"text:%@",text);
//                NSLog(@"color:%@",textColor);
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextSetShouldAntialias(context, YES);
                //根据内容的大小返回textSize
                CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}];
                CGRect rect = CGRectZero;
                //i==0时，绘制第一个section的文字
                if (i == 0) {
//                    NSLog(@"i == 0");
                    if(self.nowOrDay){
                        //如果不包含汉字，就显示在下一行
                        if (![GYToolKit includeChinese:text]) {
                            
                            rect = CGRectMake(5 + MAWidth + 5 * i, sec.frame.origin.y + textSize.height + 2, 375, textSize.height);
                            MAWidth += textSize.width + 1;
                        }else{
                            if (_nowOrDay == 999) {
                                textColor = [UIColor whiteColor];
                            }
                            rect = CGRectMake(5 + w + 5 * i, sec.frame.origin.y, textSize.width, textSize.height);
                        }
                        
                    }else{

                        if (self.whetherRevolve) {
 
                            rect = CGRectMake(5 + w + 5 * i, sec.frame.origin.y + (sec.paddingTop - textSize.height)/2.0, textSize.width, textSize.height);

                        }else{
//                            if ([text isEqualToString:@"高"]) {
//                                h = textSize.height + 2;
//                                w = 0;
//                            }
                            rect = CGRectMake(5 + w + 5 * i,sec.frame.origin.y + (sec.paddingTop - textSize.height)/2.0, textSize.width, textSize.height);
                        }
                    }
                    
                }else{
                    rect = CGRectMake(sec.frame.origin.x + sec.paddingLeft + w + 10, sec.frame.origin.y + (sec.paddingTop - textSize.height)/2.0, textSize.width, textSize.height);
                }
                [text drawInRect:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:textColor}];
                w += textSize.width + 1;
            }
        }
    }
}

-(void)setLabel:(NSMutableArray *)label forSerie:(NSMutableDictionary *) serie{
    NSString   *type  = [serie objectForKey:@"type"];
    ChartModel *model = [self getModel:type];
    [model setLabel:self label:label forSerie:serie];
}

-(void)drawSerie:(NSMutableDictionary *)serie{
    NSString   *type  = [serie objectForKey:@"type"];
    ChartModel *model = [self getModel:type];
    //NSLog(@"[self getModel:type]:%@",[self getModel:type]);
    [model drawSerie:self serie:serie cross:cross];
    
    NSEnumerator *enumerator = [self.models keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])){
        //NSLog(@"key:%@",key);
        ChartModel *m = [self.models objectForKey:key];
        [m drawTips:self serie:serie cross:cross];
    }
}

-(void)drawYAxis{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, YES);
    CGContextSetLineWidth(context, 1.0f);
    
    for(int secIndex=0;secIndex<[self.sections count];secIndex++){
        Section *sec = [self.sections objectAtIndex:secIndex];
        if(sec.hidden){
            continue;
        }
        //左边Y轴
        CGContextMoveToPoint(context, sec.frame.origin.x+sec.paddingLeft,sec.frame.origin.y+sec.paddingTop);
        CGContextAddLineToPoint(context, sec.frame.origin.x+sec.paddingLeft,sec.frame.size.height+sec.frame.origin.y);
        
        //右边Y轴
        CGContextMoveToPoint(context, sec.frame.origin.x+sec.frame.size.width,sec.frame.origin.y+sec.paddingTop);
        CGContextAddLineToPoint(context, sec.frame.origin.x+sec.frame.size.width,sec.frame.size.height+sec.frame.origin.y);
        
    }
    CGContextStrokePath(context);
    
    for(int secIndex=0;secIndex<[self.sections count];secIndex++){
        Section *sec = [self.sections objectAtIndex:secIndex];
        if(sec.hidden){
            continue;
        }
        
        //中间竖线(虚线)
        float interWidth = (sec.frame.size.width - sec.paddingLeft)/4.0;
        for (int i = 1; i< 4; i++) {
            
            if (i == 2) { //设置实线
                CGContextSetLineDash(context, 0, 0, 0);
                CGContextSetLineWidth(context, 1);
            }else{
                //设置虚线  
//                CGFloat dash[] = {1,1};
//                CGContextSetLineDash (context,20,dash,2);
                CGContextSetLineDash(context, 0, 0, 0);
                CGContextSetLineWidth(context, 1);
            }
            
            CGContextMoveToPoint(context, sec.frame.origin.x+sec.paddingLeft + interWidth * i, sec.frame.origin.y+sec.paddingTop);
            CGContextAddLineToPoint(context, sec.frame.origin.x+sec.paddingLeft + interWidth * i, sec.frame.size.height+sec.frame.origin.y);
            
            CGContextStrokePath(context);
        }
        
    }
    
    for(int secIndex=0;secIndex<self.sections.count;secIndex++){
        
        Section *sec = [self.sections objectAtIndex:secIndex];
        if(sec.hidden){
            continue;
        }
        for(int aIndex=0;aIndex<sec.yAxises.count;aIndex++){
            
            YAxis *yaxis = [sec.yAxises objectAtIndex:aIndex];
            
            //获取Y轴类型
            NSObject *seriesY = [sec.series objectAtIndex:aIndex];
            NSString *yAxisType = @"";
            if ([seriesY isKindOfClass:[NSDictionary class]]) {
                yAxisType = [seriesY valueForKey:@"type"];
                
            }
            
            NSString *format=[@"%." stringByAppendingFormat:@"%df",yaxis.decimal];
            
            float step = (float)(yaxis.max-yaxis.min)/yaxis.tickInterval;
            
            float baseY = [self getLocalY:yaxis.baseValue withSection:secIndex withAxis:aIndex];
            
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.alignment = NSTextAlignmentRight;
            
            NSMutableParagraphStyle *style2 = [[NSMutableParagraphStyle alloc] init];
            style2.alignment = NSTextAlignmentLeft;
            
            CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
            
            UIColor * originColor;
            if (_nowOrDay == 999) {
                originColor = kFenShiUpColor;
            }else{
                originColor = kFenShiDownColor;
            }
            //显示分时图原点处左侧价格刻度
            [[@"" stringByAppendingFormat:format,yaxis.baseValue] drawInRect:CGRectMake(0, baseY - kYFontSizeFenShi, sec.frame.origin.x + sec.paddingLeft - 1, kYFontSizeFenShi * 2) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:KYFontName size:kYFontSizeFenShi],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:originColor}];
            

            
            
            if (yaxis.tickInterval%2 == 1) {
                yaxis.tickInterval +=1;
            }
            
            for(int i=1; i<= yaxis.tickInterval;i++){
                
                //设置虚线
//                CGFloat dash[] = {1,1};
//                CGContextSetLineDash (context,20,dash,2);
                CGContextSetLineDash (context,0,0,0);
                CGContextSetLineWidth(context, 1);
                
                if(yaxis.baseValue + i*step <= yaxis.max && yaxis.max < MAXFLOAT){
                    float iy = [self getLocalY:(yaxis.baseValue + i*step) withSection:secIndex withAxis:aIndex];
                    
                    UIColor *textColor = [UIColor blackColor];
                    
                    //成交量显示缩写；
                    NSString *valueY = [@"" stringByAppendingFormat:format,yaxis.baseValue+i*step];
                    if ([yAxisType isEqualToString:kFenShiColumn]) {
                        valueY = [self roundFloatDisplay:yaxis.baseValue+i*step];
                        textColor = kFenShiVolumeYFontColor;
                    }else {
                        if (i == 1) {
                            if (_nowOrDay == 999) {
                                textColor = kFenShiUpColor;
                            }else{
                                textColor = kFenShiDownColor;
                            }
                        }else if(i == 2){
                            textColor = [UIColor grayColor];
                            CGContextSetLineDash (context,0,0,0);
                            CGContextSetLineWidth(context, 0.8);
                        }else if(i > 2){
                            if (_nowOrDay == 999) {
                                textColor = kFenShiDownColor;
                            }else{
                                textColor = kFenShiUpColor;
                            }
                        }
                    }
                    
                    //Y轴最大刻度，显示位置靠下
                    CGFloat offset = (i == yaxis.tickInterval) ? 0 : kYFontSizeFenShi/2 ;
                    
                    //显示分时图左侧价格刻度
                    [valueY drawInRect:CGRectMake(0, iy - offset, sec.frame.origin.x + sec.paddingLeft - 1, kYFontSizeFenShi * 2) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:KYFontName size:kYFontSizeFenShi],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:textColor}];

                    
                    if(yaxis.baseValue + i*step < yaxis.max){
                        CGContextSetStrokeColorWithColor(context, kDashColor.CGColor);
                        CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,iy);
                        CGContextAddLineToPoint(context,sec.frame.origin.x+sec.frame.size.width,iy);
                    }
                    
                    CGContextStrokePath(context);
                }
            }
            for(int i=1; i <= yaxis.tickInterval;i++){
                if(yaxis.baseValue - i*step >= yaxis.min && yaxis.min < MAXFLOAT){
                    float iy = [self getLocalY:(yaxis.baseValue - i*step) withSection:secIndex withAxis:aIndex];
                    
                    CGContextSetStrokeColorWithColor(context, kDashColor.CGColor);
                    CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,iy);
                    if(!isnan(iy)){
                        CGContextAddLineToPoint(context,sec.frame.origin.x+sec.paddingLeft-2,iy);
                    }
                    CGContextStrokePath(context);
                    
                    UIColor *textColor = [UIColor blackColor];
                    
                    //成交量显示缩写；
                    NSString *valueY = [@"" stringByAppendingFormat:format,yaxis.baseValue+i*step];
                    if ([yAxisType isEqualToString:kFenShiColumn]) {
                        valueY = [self roundFloatDisplay:yaxis.baseValue+i*step];
                        textColor = kFenShiVolumeYFontColor;
                    }else {
                        if (i == 1) {
                            if (_nowOrDay == 999) {
                                textColor = kFenShiUpColor;
                            }else{
                                textColor = kFenShiDownColor;
                            }
                            
                        }else if(i == 2){
                            textColor = [UIColor grayColor];
                        }else if(i > 2){
                            if (_nowOrDay == 999) {
                                textColor = kFenShiDownColor;
                            }else{
                                textColor = kFenShiUpColor;
                            }
                        }
                    }
                    
                    [valueY drawInRect:CGRectMake(0, iy - 7, sec.frame.origin.x + sec.paddingLeft - 1, kYFontSizeFenShi * 2) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:KYFontName size:kYFontSizeFenShi],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:textColor}];
                    
                    if(yaxis.baseValue - i*step > yaxis.min){
                        CGContextSetStrokeColorWithColor(context, kDashColor.CGColor);
                        CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,iy);
                        CGContextAddLineToPoint(context,sec.frame.origin.x+sec.frame.size.width,iy);
                    }
                    
                    CGContextStrokePath(context);
                }
            }
        }
    }
    CGContextSetLineDash (context,0,NULL,0);
}

-(void)drawXAxis{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, NO);
    CGContextSetLineWidth(context, 1.f);
    CGContextSetStrokeColorWithColor(context, kBorderColor.CGColor);
    
    for(int secIndex=0;secIndex<self.sections.count;secIndex++){
        Section *sec = [self.sections objectAtIndex:secIndex];
        if(sec.hidden){
            continue;
        }
        
        //上边X轴
        CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,sec.frame.origin.y+sec.paddingTop);
        CGContextAddLineToPoint(context, sec.frame.origin.x+sec.frame.size.width,sec.frame.origin.y+sec.paddingTop);
        
        //下边X轴
        CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,sec.frame.size.height+sec.frame.origin.y);
        CGContextAddLineToPoint(context, sec.frame.origin.x+sec.frame.size.width,sec.frame.size.height+sec.frame.origin.y);
        
    }
    CGContextStrokePath(context);
}

-(void) setSelectedIndexByPoint:(CGPoint) point{
    
    if([self getIndexOfSection:point] == -1){
        return;
    }
    Section *sec = [self.sections objectAtIndex:[self getIndexOfSection:point]];
    //NSLog(@"[self getIndexOfSection:point]:%d",[self getIndexOfSection:point]);
    for(NSInteger i=self.rangeFrom;i<self.rangeTo;i++){
        
        if((plotWidth*(i-self.rangeFrom))<=(point.x-sec.paddingLeft-self.paddingLeft) && (point.x-sec.paddingLeft-self.paddingLeft)<plotWidth*((i-self.rangeFrom)+1)){
            
            self.selectedIndex=i;
            [self setNeedsDisplay];
            
            return;
        }
    }
}
//给series添加数据
-(void)appendToData:(NSArray *)data forName:(NSString *)name{
    //    NSLog(@"lalaname:%@",name);
    //    NSLog(@"series.count:%ld",series.count);
    for(int i=0;i<self.series.count;i++){
        if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
            if([[self.series objectAtIndex:i] objectForKey:@"data"] == nil){
                NSMutableArray *tempData = [[NSMutableArray alloc] init];
                [[self.series objectAtIndex:i] setObject:tempData forKey:@"data"];
                //NSLog(@"进不来");
            }
            
            for(int j=0;j<data.count;j++){
                //NSLog(@"--%@",[self.series objectAtIndex:i]);
                [[[self.series objectAtIndex:i] objectForKey:@"data"] addObject:[data objectAtIndex:j]];
                //NSLog(@"-----------%d",i);
                //NSLog(@"%@",[self.series objectAtIndex:i]);
            }
        }
    }
    //NSLog(@"series:%@",self.series);
}

-(void)clearDataforName:(NSString *)name{
    for(int i=0;i<self.series.count;i++){
        if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
            if([[self.series objectAtIndex:i] objectForKey:@"data"] != nil){
                [[[self.series objectAtIndex:i] objectForKey:@"data"] removeAllObjects];
            }
        }
    }
}
//清除之前记录的日期
-(void)clearData{
    for(int i=0;i<self.series.count;i++){
        //NSLog(@"--%@",[[self.series objectAtIndex:i] objectForKey:@"data"]);
        [[[self.series objectAtIndex:i] objectForKey:@"data"] removeAllObjects];
    }
    
}

-(void)setData:(NSMutableArray *)data forName:(NSString *)name{
    for(int i=0;i<self.series.count;i++){
        if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
            [[self.series objectAtIndex:i] setObject:data forKey:@"data"];
        }
    }
}
//添加时间
-(void)appendToCategory:(NSArray *)category forName:(NSString *)name{
    for(int i=0;i<self.series.count;i++){
        if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
            if([[self.series objectAtIndex:i] objectForKey:@"category"] == nil){
                NSMutableArray *tempData = [[NSMutableArray alloc] init];
                [[self.series objectAtIndex:i] setObject:tempData forKey:@"category"];
                //NSLog(@"进不来");
            }
            for(int j=0;j<category.count;j++){
                [[[self.series objectAtIndex:i] objectForKey:@"category"] addObject:[category objectAtIndex:j]];
            }
            //NSLog(@"category:%@",[[self.series objectAtIndex:i] objectForKey:@"category"]);
        }
    }
}

-(void)clearCategoryforName:(NSString *)name{
    for(int i=0;i<self.series.count;i++){
        if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqual:name]){
            if([[self.series objectAtIndex:i] objectForKey:@"category"] != nil){
                [[[self.series objectAtIndex:i] objectForKey:@"category"] removeAllObjects];
            }
        }
    }
}
//清除数据
-(void)clearCategory{
    for(int i=0;i<self.series.count;i++){
        [[[self.series objectAtIndex:i] objectForKey:@"category"] removeAllObjects];
    }
    //NSLog(@"series:%@",self.series);
}

-(void)setCategory:(NSMutableArray *)category forName:(NSString *)name{
    for(int i=0;i<self.series.count;i++){
        if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
            [[self.series objectAtIndex:i] setObject:category forKey:@"category"];
        }
    }
}

/*
 * Sections
 */
-(Section *)getSection:(int) index{
    return [self.sections objectAtIndex:index];
}
-(int)getIndexOfSection:(CGPoint) point{
    for(int i=0;i<self.sections.count;i++){
        Section *sec = [self.sections objectAtIndex:i];
        if (CGRectContainsPoint(sec.frame, point)){
            return i;
        }
    }
    return -1;
}

/*
 * series
 */
-(NSMutableDictionary *)getSerie:(NSString *)name{
    NSMutableDictionary *serie = nil;
    for(int i=0;i<self.series.count;i++){
        if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
            serie = [self.series objectAtIndex:i];
            break;
        }
    }
    return serie;
}

-(void)addSerie:(NSObject *)serie{
    if([serie isKindOfClass:[NSArray class]]){
        NSArray *se = (NSArray *)serie;
        int section = 0;
        for (NSDictionary *ser in se) {
            section = [[ser objectForKey:@"section"] intValue];
            [self.series addObject:ser];
        }
        [[[self.sections objectAtIndex:section] series] addObject:serie];
    }else{
        NSDictionary *se = (NSDictionary *)serie;
        int section = [[se objectForKey:@"section"] intValue];
        [self.series addObject:serie];
        [[[self.sections objectAtIndex:section] series] addObject:serie];
    }
}

/*
 *  Chart Sections
 */
-(void)addSection:(NSString *)ratio{
    Section *sec = [[Section alloc] init];
    [self.sections addObject:sec];
    //NSLog(@"ratio:%@",ratio);
    [self.ratios addObject:ratio];
}

-(void)removeSection:(int)index{
    [self.sections removeObjectAtIndex:index];
    [self.ratios removeObjectAtIndex:index];
}
/**
 *  设置chart信息
 *
 *  @param num  截面数量
 *  @param rats 截面大小比例
 */
-(void)addSections:(int)num withRatios:(NSArray *)rats{
    for (int i=0; i< num; i++) {
        Section *sec = [[Section alloc] init];
        [self.sections addObject:sec];
        [self.ratios addObject:[rats objectAtIndex:i]];
    }
}
-(void)removeSections{
    [self.sections removeAllObjects];
    [self.ratios removeAllObjects];
}

-(void)initSections{
    //设置截面大小
    float height = self.frame.size.height-(self.paddingTop+self.paddingBottom);
    float width  = self.frame.size.width-(self.paddingLeft+self.paddingRight);
    //NSLog(@"height:%f",self.paddingBottom);
    //    NSLog(@"width:%f",width);
    //total 总的要比例数
    int total = 0;
    for (int i=0; i< self.ratios.count; i++) {
        if([[self.sections objectAtIndex:i] hidden]){
            //NSLog(@"啦啦");
            continue;
        }
        //各自截面占的比例
        int ratio = [[self.ratios objectAtIndex:i] intValue];
        //NSLog(@"[self.ratios objectAtIndex:i]:%@",[self.ratios objectAtIndex:i]);
        total += ratio;
    }
    //NSLog(@"total:%d",total);
    
    Section*prevSec = nil;
    for (int i=0; i< self.sections.count; i++) {
        int ratio = [[self.ratios objectAtIndex:i] intValue];
        Section *sec = [self.sections objectAtIndex:i];
        if([sec hidden]){
            continue;
        }
        float h = height*ratio/total;
        float w = width;
        //设置两个截面的大小
        if(i==0){
            //NSLog(@"top:%f",self.paddingTop);
            [sec setFrame:CGRectMake(0+self.paddingLeft, 0+self.paddingTop, w,h)];
        }else{
            if(i==([self.sections count]-1)){
//              NSLog(@"Y:%f",prevSec.frame.origin.y);
//                NSLog(@"H:%f",prevSec.frame.size.height);
                [sec setFrame:CGRectMake(0+self.paddingLeft, prevSec.frame.origin.y+prevSec.frame.size.height, w,self.paddingTop+height-(prevSec.frame.origin.y+prevSec.frame.size.height))];
            }else {
                NSLog(@"啦啦3");
                [sec setFrame:CGRectMake(0+self.paddingLeft, prevSec.frame.origin.y+prevSec.frame.size.height, w,h)];
            }
        }
        prevSec = sec;
        //NSLog(@"prevSec.frame:%@",NSStringFromCGRect(prevSec.frame));
        
    }
    //设置界面初始化状态为YES
    self.isSectionInitialized = YES;
}


-(YAxis *)getYAxis:(int) section withIndex:(int) index{
    Section *sec = [self.sections objectAtIndex:section];
    YAxis *yaxis = [sec.yAxises objectAtIndex:index];
    return yaxis;
}


-(void)initModels{
    [self.models removeAllObjects];
    if (0 == self.nowOrDay) {
        //line
        ChartModel *model = [[EverLineModel alloc] init];
        [self addModel:model withName:kFenShiLine];
        //column
        model = [[EverColumnModel alloc] init];
        [self addModel:model withName:kFenShiColumn];
    }else{
        //line
        ChartModel *model = [[LineChartModel alloc] init];
        [self addModel:model withName:@"line"];
        
        //column
        model = [[EverColumnModel alloc] init];
        [self addModel:model withName:@"column"];
        
        //candle
        model = [[CandleChartModel alloc] init];
        [self addModel:model withName:@"candle"];
        
    }
    
    
}

-(void)addModel:(ChartModel *)model withName:(NSString *)name{
    [self.models setObject:model forKey:name];
}

-(ChartModel *)getModel:(NSString *)name{
    return [self.models objectForKey:name];
}


#pragma mark -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //记录开始触摸屏幕的时间
    BeforeDate = [NSDate date];
    BeforeTime = [BeforeDate timeIntervalSince1970];
    //NSLog(@"BeforTime:%f",BeforeTime);
    NSArray *ts = [touches allObjects];
    self.touchFlag = 0;
    self.touchFlagTwo = 0;
    if([ts count]==1){
        //        UITouch* touch = ts[0];
        //        if([touch locationInView:self].x < 40){
        //            NSLog(@"<40");
        //            NSLog(@"%f",[touch locationInView:self].x);
        //            self.touchFlag = [touch locationInView:self].y;
        //        }
        self.touchFlag = [ts[0] locationInView:self].x ;
    }else if ([ts count]==2) {
        self.touchFlag = [ts[0] locationInView:self].x ;

        self.touchFlagTwo = [ts[1] locationInView:self].x;

    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSArray *touchs = [touches allObjects];
    UITouch* touch = [touchs objectAtIndex:0];
    //记录开始move的时间
    NowDate = [NSDate date];
    //计算两个日期间的时间差
    CGFloat x = [NowDate timeIntervalSinceDate:BeforeDate];
    //NSLog(@"x:%f",x);
    NowTime = [NowDate timeIntervalSince1970];
    //NSLog(@"NowTime:%f",NowTime);
    self.touchY = [touch locationInView:self].y;
    
    NSArray *ts = [touches allObjects];
    if (0 == self.nowOrDay) {
        if([ts count]==1){
            if(x>0.5){
                UITouch* touch = ts[0];
                int i = [self getIndexOfSection:[touch locationInView:self]];
                if(i!=-1){
                    Section *sec = self.sections[i];
                    if([touch locationInView:self].x > sec.paddingLeft)
                        [self setSelectedIndexByPoint:[touch locationInView:self]];
                }
                cross = 1;
            }
        }
    }else{
        if([ts count]==1){
            if(x>0.5){
                UITouch* touch = ts[0];
                int i = [self getIndexOfSection:[touch locationInView:self]];
                if(i!=-1){
                    Section *sec = self.sections[i];
                    if([touch locationInView:self].x > sec.paddingLeft)
                        [self setSelectedIndexByPoint:[touch locationInView:self]];
                }
                cross = 1;
            }else{
                
                float currFlag = [ts[0] locationInView:self].x;
                if(self.touchFlag == 0){
                    self.touchFlag = currFlag;
                }else{
                    //拖动速度因数
                    int Velocity = 1;
                    //NSLog(@"%f",currFlag - self.touchFlag);
                    if((currFlag - self.touchFlag) > 0 ){
                        //向右滑动手势
                        if(self.plotCount > (self.rangeTo-self.rangeFrom)){
                            if(self.rangeFrom - Velocity >= 0){
                                self.rangeFrom -= Velocity;
                                self.rangeTo   -= Velocity;
                                if(self.selectedIndex >= self.rangeTo){
                                    self.selectedIndex = self.rangeTo-1;
                                }
                            }else {
                                self.rangeFrom = 0;
                                self.rangeTo  -= self.rangeFrom;
                                if(self.selectedIndex >= self.rangeTo){
                                    self.selectedIndex = self.rangeTo-1;
                                }
                            }
                            //NSLog(@"大于");
                            //NSLog(@"画我3");
                            [self setNeedsDisplay];
                        }
                    }else if((currFlag - self.touchFlag) < 0){
                        //向左滑动手势
                        if(self.plotCount > (self.rangeTo-self.rangeFrom)){
                            if(self.rangeTo + Velocity <= self.plotCount){
                                self.rangeFrom += Velocity;
                                self.rangeTo += Velocity;
                                if(self.selectedIndex < self.rangeFrom){
                                    self.selectedIndex = self.rangeFrom;
                                }
                            }else {
                                self.rangeFrom  += self.plotCount-self.rangeTo;
                                self.rangeTo     = self.plotCount;
                                
                                if(self.selectedIndex < self.rangeFrom){
                                    self.selectedIndex = self.rangeFrom;
                                }
                            }
                            //NSLog(@"画我4");
                            [self setNeedsDisplay];
                        }
                    }
                }
            }
        }if ([ts count]==2) {
            float currFlag = [ts[0] locationInView:self].x;
            float currFlagTwo = [ts[1] locationInView:self].x;
            //        NSLog(@"touchFlag:%f",self.touchFlag);
            //        NSLog(@"currFlag:%f",currFlag);
            if(self.touchFlag == 0){
                self.touchFlag = currFlag;
                self.touchFlagTwo = currFlagTwo;
            }else{
                //放大缩小的因数
                int sizeNumber = 5;
                //NSLog(@"%f",currFlag - self.touchFlag);
                if(fabsf(fabsf(currFlagTwo-currFlag)-fabsf(self.touchFlagTwo-self.touchFlag)) >= MIN_INTERVAL){
                    //NSLog(@"差值：%ld",self.rangeTo - self.rangeFrom);
                    if (self.rangeTo - self.rangeFrom >=30) {
                        if(fabsf(currFlagTwo-currFlag)-fabsf(self.touchFlagTwo-self.touchFlag) > 0){
                            NSLog(@"放大");
                            if((self.plotCount>self.rangeTo-self.rangeFrom)){
                                if(self.rangeFrom + sizeNumber < self.rangeTo){
                                    self.rangeFrom += sizeNumber;
                                }
                                if((self.rangeTo - sizeNumber > self.rangeFrom)){
                                    self.rangeTo -= sizeNumber;
                                }
                            }else{
                                if(self.rangeTo - sizeNumber > self.rangeFrom){
                                    self.rangeTo -= sizeNumber;
                                }
                            }
                            [self setNeedsDisplay];
                        }
                    }else{
                        //NSLog(@"臣妾做不到啊");
                    }
                    if(fabsf(currFlagTwo-currFlag)-fabsf(self.touchFlagTwo-self.touchFlag) < 0){
                        if (self.rangeTo - self.rangeFrom <=100) {
                            NSLog(@"缩小");
                            if(self.rangeFrom - sizeNumber >= 0){
                                self.rangeFrom -= sizeNumber;
                            }else{
                                self.rangeFrom = 0;
                            }
                            self.rangeTo += sizeNumber;
                            
                            [self setNeedsDisplay];
                        }
                        
                    }
                    
                }
            }
            self.touchFlag = currFlag;
            self.touchFlagTwo = currFlagTwo;
        }
    }
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    cross = 0;
   
}

/**
 *  格式化float，显示单位，保留1位小数
 *
 *  @return 格式化后的字符串
 */
- (NSString *)roundFloatDisplay:(CGFloat)value{
    
    NSString *unit = @"";
    if (value > 100000) {
        value /= 10000.0;
        unit = @"万";
    }
    if (value > 100000) {
        value /= 10000.0;
        unit = @"亿";
    }
    if (value > 100000) {
        value /= 10000.0;
        unit = @"万亿";
    }
    
    if ([unit isEqualToString:@""]) {
        return [NSString stringWithFormat:@"%d",(int)value];
    }
    return [NSString stringWithFormat:@"%.1f%@",value,unit];
}
/*
 * UIView Methods
 */
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.enableSelection = YES;
        self.isInitialized   = NO;
        self.isSectionInitialized   = NO;
        self.selectedIndex   = -1;
        self.padding         = nil;
        self.paddingTop      = 0;
        self.paddingRight    = 0;
        self.paddingBottom   = 0;
        self.paddingLeft     = 0;
        self.rangeFrom       = 0;
        self.rangeTo         = 0;
        self.range           = 1440;
        self.touchFlag       = 0;
        self.touchFlagTwo    = 0;
        NSMutableArray *rats = [[NSMutableArray alloc] init];
        self.ratios          = rats;
        
        NSMutableArray *secs = [[NSMutableArray alloc] init];
        self.sections        = secs;
        
        NSMutableDictionary *mods = [[NSMutableDictionary alloc] init];
        self.models        = mods;
        //开启多点触控
        [self setMultipleTouchEnabled:YES];

        
    }
    return self;
}

@end
