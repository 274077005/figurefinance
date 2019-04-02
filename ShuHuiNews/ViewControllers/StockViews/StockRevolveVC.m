//
//  StockRevolveVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/10.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "StockRevolveVC.h"

@interface StockRevolveVC ()
{
    //自选View
    UIView * _mainView;
    
    UIButton * _redactBtn;
    
    //滚动视图的item数组
    NSMutableArray *_itemArray;
    
    NSMutableArray * _itemIdArray;
    //用于记录每个按钮的偏移量
    NSMutableArray *_itemInfoArray;
    //按钮数组
    NSMutableArray *_scrollBtnArray;
    //尖锐数组
    NSMutableArray * _tipArray;
    float _totalWidth;
    
    
    //主视图要显示线的类型
    
    NSMutableArray * _primeTypeArray;
    NSMutableArray * _minorTypeArray;
    
    NSMutableString * _URLStr;
    
    //KPI按钮数组
    NSMutableArray * _kpiBtnArray;
    
    //主图KPI按钮
    NSMutableArray * _primeKpiBtnArray;
    
    NSDictionary * _jsonMessage;
    NSMutableArray * _jsonDataArray;
    
    NSMutableArray * _category;
    
    //用来记录button的tag值来判断是否在重复（如一直刷新周K）
    NSInteger _btnTag;
    
    //获取股票信息的定时器
    NSTimer * _getDetailTimer;
    
    NSTimer * _getKlineTimer;
    
    //控制数字渐变timer
    NSTimer * _changPriceTimer;
}
@end

@implementation StockRevolveVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor =RGBCOLOR(21, 25, 32);
    //开启横屏
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = 2;

    _nowKDataDic = [[NSMutableDictionary alloc]init];
    _jsonMessage = [[NSDictionary alloc]init];
    _jsonDataArray = [[NSMutableArray alloc]init];
    self.priceLab.text = self.detailModel.sell;
    [self updateLables];
    [self createStockDetail];
    [self createScrollView];
    
    
    CGFloat width = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
    CGFloat height = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
    
    self.stockChart = [[EverChart alloc] initWithFrame:CGRectMake(0, 80, width, height - 80)];
    self.stockChart.whetherRevolve = 1;
    [self.view addSubview:self.stockChart];
    
    
    [self initChart];
    [self getKLineData];
    [self createKPIView];
    [self createPrimeKPIView];
    
    [self createGetDetailTimer];
    
    // Do any additional setup after loading the view.
}
//由模态推出的视图控制器 优先支持的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}
//隐藏tabBar
- (void)viewWillAppear:(BOOL)animated
{
    //开启横屏
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = 2;
    
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [_getKlineTimer invalidate];
    _getKlineTimer = nil;
    
    [_getDetailTimer invalidate];
    _getDetailTimer = nil;
    
    [_changPriceTimer invalidate];
    _changPriceTimer = nil;
    
    [super viewWillDisappear:animated];
}

- (void)createGetDetailTimer
{
    _getDetailTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(createStockDetail) userInfo:nil repeats:YES];
    _getKlineTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(getKLineData) userInfo:nil repeats:YES];
    _changPriceTimer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(changePriceLable) userInfo:nil repeats:YES];
    [_changPriceTimer setFireDate:[NSDate distantFuture]];
}
//画画按钮点击
- (IBAction)drawBtnClick:(id)sender {
    
    UIImage*image = [GYToolKit snapshotSingleView:KeyWindow];
    
    DrawingBoardViewController * DrawVC = [[DrawingBoardViewController alloc]init];
    DrawVC.drawImage = image;
    DrawVC.navigationItem.title = self.navigationItem.title;
    
    DrawVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:DrawVC animated:YES completion:nil];
}

//返回上页
- (IBAction)narrowBtnClick:(id)sender {
    //恢复竖屏
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = 0;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)refreshBtnClick:(id)sender {
    [self getKLineData];
}
- (void)updateLables
{
    self.nameLab.text = self.detailModel.name;
    self.lastLab.text = self.detailModel.lastClose;
    
    if ([self.detailModel.nowP isEqualToString:@"--"]) {
        return;
    }
    
    
    self.timeLab.text = [self.detailModel.date substringFromIndex:5];
    self.priceLab.text = self.detailModel.nowP;
    self.marginLab.text = _detailModel.margin;
    self.mpLab.text = _detailModel.mp;
    [_changPriceTimer setFireDate:[NSDate distantPast]];
    if ([self.detailModel.nowP floatValue] > [self.detailModel.lastClose floatValue]) {
        
        self.priceLab.textColor = RedColor;
        self.marginLab.textColor = RedColor;
        self.mpLab.textColor = RedColor;
    }else{
        
        self.priceLab.textColor = GreenColor;
        self.marginLab.textColor = GreenColor;
        self.mpLab.textColor = GreenColor;
    }
    self.topLab.text = self.detailModel.top;
    if ([self.detailModel.top floatValue]> [self.detailModel.lastClose floatValue]) {
        self.topLab.textColor = RedColor;
    }else{
        self.topLab.textColor = GreenColor;
    }
    
    self.lowLab.text = self.detailModel.low;
    if ([self.detailModel.low floatValue]> [self.detailModel.lastClose floatValue]) {
        self.lowLab.textColor = RedColor;
    }else{
        self.lowLab.textColor = GreenColor;
    }

}
//渐变数字lab
- (void)changePriceLable
{
    
    [GYStockLineIndicators gradualChangeLabWithEndNum:self.detailModel.nowP Lab:self.priceLab Timer:_changPriceTimer];
    
}

//根据网络上获取到的数据来显示
- (void)createStockDetail{
    NSLog(@"获取横屏详情");
    NSString * urlStr = [NSString stringWithFormat:@"https://app5.fx168api.com//quotation/getQuotationTradeInfo.json?key=%@",self.detailModel.key];
    [GYPostData GetStockDataWithUrlPath:urlStr Handler:^(NSDictionary * jsonDic, NSError * error) {
        if (!error) {
            if ([jsonDic[@"status"]integerValue] == 0) {
                self.detailModel = [StockDetailModel mj_objectWithKeyValues:jsonDic[@"data"]];
                if (!_isOrNotGetKLineData) {
                    [self getKLineData];
                }
                [self updateLables];
            }
            
        }else{
            
            NSLog(@"stock详情error:%@",error);
        }
    }];
}
- (void)createKPIView
{
    self.KPIV.backgroundColor = [UIColor colorWithRed:22/255.0 green:25/255.0 blue:32/255.0 alpha:1.0];
    
    UIButton * minorSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    minorSetBtn.frame = CGRectMake(12, SCREEN_WIDTH - 270, 30, 30);
    minorSetBtn.center = CGPointMake(self.KPIV.frame.size.width/2, SCREEN_WIDTH - 100);
    [minorSetBtn setImage:[UIImage imageNamed:@"KPISet"] forState:UIControlStateNormal];
    [minorSetBtn addTarget:self action:@selector(minorKpiSetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.KPIV addSubview:minorSetBtn];
    
    
    _kpiBtnArray = [[NSMutableArray alloc] init];
    _minorTypeArray = [[NSMutableArray alloc]initWithArray:@[@"MACD",@"RSI",@"KDJ",@"WR"]];
    //float menuWidth = self.KPIV.bounds.size.height - 150;
    float menuWidth = SCREEN_WIDTH -260;
    for (int i = 0;i<_minorTypeArray.count; i++) {
        float itemWidth = 40.0;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *str = _minorTypeArray[i];
        //NSLog(@"itemWidth:%f",itemWidth);
        button.frame = CGRectMake(5, menuWidth, itemWidth, 24);
        [button setTitle:str forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        //高亮状态
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        //高亮状态发光效果
        //button.showsTouchWhenHighlighted = YES;
        [button addTarget:self action:@selector(kpiButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        
        //设置圆角半径
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        
        [self.KPIV addSubview:button];
        
        menuWidth += itemWidth;
        //NSLog(@"@(menuWidth):%@",@(menuWidth));
        [_kpiBtnArray addObject:button];
        
    }
    for (UIButton *btn in _kpiBtnArray) {
        btn.backgroundColor = [UIColor clearColor];
    }
    
    for (NSInteger i = 0; i < _minorTypeArray.count; i++) {
        if ([self.minorType isEqualToString:_minorTypeArray[i]]) {
            UIButton *button = _kpiBtnArray[i];
            Section * sec = self.stockChart.sections[1];
            [sec nextPage:i];
            button.backgroundColor = [UIColor colorWithRed:31/255.0 green:36/255.0 blue:46/255.0 alpha:1.0];
            button.selected = YES;
            break;
        }
    }
    
}
- (void)minorKpiSetButtonClick
{
    if ([_minorType isEqualToString:@"MACD"]) {
        [self.view addSubview:[self createMACDSetView]];
        [UIView animateWithDuration:0.5 animations:^{
            self.macdSetView.alpha = 0.5;
            self.macdSetView.alpha = 1.0;
        }];
    }else if ([_minorType isEqualToString:@"RSI"]){
        [self.view addSubview:[self createRSISetView]];
        [UIView animateWithDuration:0.5 animations:^{
            self.rsiSetView.alpha = 0.5;
            self.rsiSetView.alpha = 1.0;
        }];
    }else if ([_minorType isEqualToString:@"KDJ"]){
        [self.view addSubview:[self createKDJSetView]];
        [UIView animateWithDuration:0.5 animations:^{
            self.kdjSetView.alpha = 0.5;
            self.kdjSetView.alpha = 1.0;
        }];
    }else if ([_minorType isEqualToString:@"WR"]){
        [self.view addSubview:[self createWRSetView]];
        [UIView animateWithDuration:0.5 animations:^{
            self.wrSetView.alpha = 0.5;
            self.wrSetView.alpha = 1.0;
        }];
    }}
- (void)kpiButtonClicked:(UIButton *)btn
{
    for (UIButton *btn in _kpiBtnArray) {
        btn.selected = NO;
        btn.backgroundColor = [UIColor clearColor];
    }
    UIButton *button = [_kpiBtnArray objectAtIndex:btn.tag];
    button.selected = YES;
    button.backgroundColor = [UIColor colorWithRed:31/255.0 green:36/255.0 blue:46/255.0 alpha:1.0];
    _minorType = _minorTypeArray[btn.tag];
    
    Section * sec = self.stockChart.sections[1];
    [sec nextPage:btn.tag];
    [self.stockChart setNeedsDisplay];
}
- (void)createPrimeKPIView
{
    self.primeKPIV.backgroundColor = [UIColor colorWithRed:22/255.0 green:25/255.0 blue:32/255.0 alpha:1.0];
    _primeKpiBtnArray = [[NSMutableArray alloc] init];
    
    UIButton * primeSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    primeSetBtn.frame = CGRectMake(0, 130, 30, 30);
    primeSetBtn.center = CGPointMake(self.primeKPIV.frame.size.width/2, 135);
    [primeSetBtn setImage:[UIImage imageNamed:@"KPISet"] forState:UIControlStateNormal];
    [primeSetBtn addTarget:self action:@selector(primeKpiSetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.primeKPIV addSubview:primeSetBtn];
    _primeTypeArray = [[NSMutableArray alloc]initWithArray:@[@"MA",@"BOLL",@"ENV"]];
    float menuWidth = 15;
    for (int i = 0;i<_primeTypeArray.count; i++) {
        float itemWidth = 40.0;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *str = _primeTypeArray[i];
        //NSLog(@"itemWidth:%f",itemWidth);
        button.frame = CGRectMake(5, menuWidth, itemWidth, 24);
        [button setTitle:str forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        //高亮状态
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        //高亮状态发光效果
        //button.showsTouchWhenHighlighted = YES;
        [button addTarget:self action:@selector(primeKpiButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        
        
        //设置圆角半径
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        
        [self.primeKPIV addSubview:button];
        
        menuWidth += itemWidth;
        //NSLog(@"@(menuWidth):%@",@(menuWidth));
        [_primeKpiBtnArray addObject:button];
        
    }
    for (UIButton *btn in _primeKpiBtnArray) {
        btn.backgroundColor = [UIColor clearColor];
    }
    
    for (NSInteger i = 0; i < _primeTypeArray.count; i++) {
        if ([self.primeType isEqualToString:_primeTypeArray[i]]) {
            UIButton *button = _primeKpiBtnArray[i];
            button.backgroundColor = [UIColor colorWithRed:31/255.0 green:36/255.0 blue:46/255.0 alpha:1.0];
            button.selected = YES;
            break;
        }
    }
    
}
- (void)primeKpiSetButtonClick
{
    if ([_primeType isEqualToString:@"MA"]) {
        [self.view addSubview:[self createMaSetView]];
        [UIView animateWithDuration:0.5 animations:^{
            self.maSetView.alpha = 0.5;
            self.maSetView.alpha = 1.0;
        }];
    }else if ([_primeType isEqualToString:@"BOLL"]){
        [self.view addSubview:[self createBOLLSetView]];
        [UIView animateWithDuration:0.5 animations:^{
            self.bollSetView.alpha = 0.5;
            self.bollSetView.alpha = 1.0;
        }];
    }else if ([_primeType isEqualToString:@"ENV"]){
        [self.view addSubview:[self createENVSetView]];
        [UIView animateWithDuration:0.5 animations:^{
            self.envSetView.alpha = 0.5;
            self.envSetView.alpha = 1.0;
        }];
    }
}

- (void)primeKpiButtonClicked:(UIButton *)btn
{
    for (UIButton *btn in _primeKpiBtnArray) {
        btn.selected = NO;
        btn.backgroundColor = [UIColor clearColor];
    }
    UIButton *button = [_primeKpiBtnArray objectAtIndex:btn.tag];
    button.selected = YES;
    button.backgroundColor = [UIColor colorWithRed:31/255.0 green:36/255.0 blue:46/255.0 alpha:1.0];
    _primeType = _primeTypeArray[btn.tag];
    
    [self.stockChart clearData];
    [self.stockChart clearCategory];
    
    [self setData:_jsonMessage];
    NSMutableArray *cate = [[NSMutableArray alloc] init];
    for(int i=0;i<_category.count;i++){
        [cate addObject:_category[i]];
    }
    [self setCategory:cate];
    //[self renderDayChart:_jsonMessage];
    
    [self.stockChart setNeedsDisplay];
}
- (void)getKLineData
{
    NSLog(@"获取数据");
    [_refreshBtn.layer addAnimation:_animation forKey:@"refreshBtnAnimation"];
 
    if (0==_nowOrDay) {
        [self.stockChart getSection:1].hidden = YES;
        //设置K线图部分的大小，为了让KPIV隐藏,这里的SCREEN_WIDTH, SCREEN_HEIGHT是反过来的
        CGFloat width = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
        CGFloat height = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
        if (iphoneX) {
            [self.stockChart setFrame:CGRectMake(30, 80, width-30, height - 80)];
        }else{
            [self.stockChart setFrame:CGRectMake(0, 80, width, height - 80)];
        }
        
        
        _URLStr = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"https://app5.fx168api.com//quotation/getMinHourData.json?code=%@",self.detailModel.key]];
        //如果没有网络状态从推送弹窗跳转过来，有可能lastClose为空，需要先获取到lastClose才能计算分时图
        if(!self.detailModel.lastClose){
            [self createStockDetail];
            return;
        }
        [GYPostData GetStockDataWithUrlPath:_URLStr Handler:^(NSDictionary * dic, NSError * error) {
            _btnTag = _nowOrDay;
            [_refreshBtn.layer removeAllAnimations];
            if (!error) {
                if ([dic[@"status"]integerValue]==0) {
                    
                    _isOrNotGetKLineData = YES;
                    //这里是为了定时刷新的时候不显示黑的
                    //设置初始化状态为NO
                    [self.stockChart reset];
                    //清除之前记录的日期
                    [self.stockChart clearData];
                    //清除数据
                    [self.stockChart clearCategory];
                    
                    [self.stockChart.series removeAllObjects];
                    
                    [self setSeries];
                    
                    [self renderNowChart:dic[@"data"]];
                }
            }else{
                [SVProgressHUD showWithString:@"网络故障"];
            }
        }];
    }else{
        [self.stockChart getSection:1].hidden = NO;
        CGFloat width = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
        CGFloat height = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
        //处理刘海
        if (iphoneX) {
            self.primeVLeading.constant = 30;
            
            [self.stockChart setFrame:CGRectMake(50 + 34, 80, width - 100 - 34, height - 80)];
        }else{
            [self.stockChart setFrame:CGRectMake(50, 80, width - 100, height - 80)];
        }
        
        NSString * urlStr = [NSString stringWithFormat:@"https://app5.fx168api.com//quotation/getData.json?code=%@&count=240&type=%@&direct=first",self.detailModel.key,_timeBucketStr];
        
        //假如现在有好几个请求k线数据的请求在队列中，取消其他的，防止因为有的请求慢导致k线呈现错误
        AFHTTPSessionManager *manager = [AFHTTPSessionManager shareManager];
        //取消所有的网络请求
        [manager.operationQueue cancelAllOperations];
        [manager.tasks makeObjectsPerformSelector:@selector(cancel)];
        
        
        [GYPostData GetStockDataWithUrlPath:urlStr Handler:^(NSDictionary * dic, NSError * error) {
            NSLog(@"%@",_timeBucketStr);
            NSLog(@"%@",urlStr);
            [_refreshBtn.layer removeAllAnimations];
            if (!error) {
                if ([dic[@"status"]integerValue]==0) {
                    _isOrNotGetKLineData = YES;
                    //这里是为了定时刷新的时候不显示黑的
                    //设置初始化状态为NO
                    //[self.stockChart reset];
                    //清除之前记录的日期
                    [self.stockChart clearData];
                    //清除数据
                    [self.stockChart clearCategory];
                    
                    [self.stockChart.series removeAllObjects];
                    
                    [self setSeries];
                    //到这里结束
                    
                    NSDictionary * responseObject = dic;
                    
                    [self renderDayChart:responseObject[@"data"]];
                }
            }else{
                if ([error code] != -999 ) {
                    [SVProgressHUD showWithString:@"网络故障"];
                }
            }
        }];
    }
}

#pragma mark - Chart Action
/**
 *  初始化分时图
 */
-(void)initChart{
    NSMutableArray *padding = [NSMutableArray arrayWithObjects:@"0",@"0",@"10",@"0",nil];
    //设置内边距（上右下左）
    [self.stockChart setPadding:padding];
    NSMutableArray *secs = [[NSMutableArray alloc] init];
    [secs addObject:@"2"]; //设置上下两部分比例
    [secs addObject:@"1"];
    
    //chart添加两个分组
    [self.stockChart addSections:2 withRatios:secs];
    //添加Y轴线
    [[[self.stockChart sections] objectAtIndex:0] addYAxis:0];
    
    [[[self.stockChart sections] objectAtIndex:1] addYAxis:0];
    //设置水平虚线分割数
    [self.stockChart getYAxis:0 withIndex:0].tickInterval = 4;
    [self.stockChart getYAxis:1 withIndex:0].tickInterval = 2;
    [self setSeries];
    
    self.stockChart.nowOrDay = _nowOrDay;
    if(_nowOrDay !=0){
        self.stockChart.range = 55;
    }else{
        self.stockChart.range = 288;
    }
    
}
-(void)setSeries
{
    //self.stockChart.range = 1440; //设置显示区间大小
    if(0 == _nowOrDay){
        NSMutableArray * KlineSeriesArr = [GYStockLineIndicators setNowKLineSeries];
        
        
        //设置chart的截面信息，series数组类型
        [self.stockChart setSeries:KlineSeriesArr[0]];
        //分别给两个截面设置信息
        [[[self.stockChart sections] objectAtIndex:0] setSeries:KlineSeriesArr[1]];
        [[[self.stockChart sections] objectAtIndex:1] setSeries:KlineSeriesArr[2]];
    }else{
        
        NSMutableArray * KlineSeriesArr = [GYStockLineIndicators setDayKLineSeriesWithKPIModel:_kpiModel];
        //candleChart init
        [self.stockChart setSeries:KlineSeriesArr[0]];
        [[self.stockChart sections][0] setSeries:KlineSeriesArr[1]];
        [[self.stockChart sections][1] setSeries:KlineSeriesArr[2]];
        [[self.stockChart sections][1] setPaging:YES];
    }
}

-(void)setOptions:(NSDictionary *)options ForSerie:(NSMutableDictionary *)serie{
    [serie setObject:[options objectForKey:@"name"] forKey:@"name"];
    [serie setObject:[options objectForKey:@"label"] forKey:@"label"];
    [serie setObject:[options objectForKey:@"type"] forKey:@"type"];
    [serie setObject:[options objectForKey:@"yAxis"] forKey:@"yAxis"];
    [serie setObject:[options objectForKey:@"section"] forKey:@"section"];
    [serie setObject:[options objectForKey:@"color"] forKey:@"color"];
    [serie setObject:[options objectForKey:@"negativeColor"] forKey:@"negativeColor"];
    [serie setObject:[options objectForKey:@"selectedColor"] forKey:@"selectedColor"];
    [serie setObject:[options objectForKey:@"negativeSelectedColor"] forKey:@"negativeSelectedColor"];
}


/**
 *  配置数据源，生成分时图
 *
 *  @param responseObject 数据参数
 */
- (void)renderNowChart:(NSDictionary *)responseObject{
    //    NSLog(@"res:%@",responseObject);
    //设置初始化状态为NO
    [self.stockChart reset];
    //清除之前记录的日期
    [self.stockChart clearData];
    //清除数据
    [self.stockChart clearCategory];
    
    NSMutableArray *data1 =[[NSMutableArray alloc] init];
    NSMutableArray *data2 =[[NSMutableArray alloc] init];
    
    NSMutableArray *category =[[NSMutableArray alloc] init];
    
    NSArray *listArray = responseObject[@"totalList"];//得到各个时间点的数据组成的数组
    //NSLog(@"array：%@",listArray);
    
    NSString *closeYesterday = self.detailModel.lastClose;//昨日收盘价
    //NSLog(@"close:%@",closeYesterday);
    //开盘价
    NSString * openPrice = self.detailModel.open;
    
    NSString * topPrice = self.detailModel.top;
    
    NSString * lowPrice = self.detailModel.low;
    //处理起止时间
    NSRange range = {10,6};
    NSArray * timeRangeArray = [responseObject[@"timeRange"] componentsSeparatedByString:@"~"];
    NSString * beginTime = timeRangeArray[0];
    NSString * endTime = timeRangeArray[1];
    NSArray * timeArr = @[[beginTime substringWithRange:range],[endTime substringWithRange:range]];
    //    NSArray * AllTimesArray = responseObject[@"intervalTime"];
    
    for(NSInteger i = listArray.count -1;i>=0;i--){
        
        NSDictionary *dic = listArray[i];
        //NSLog(@"dic:%@",dic);
        //当前时间
        
        NSString * nowTime  = [dic[@"date"] substringWithRange:range];
        [category addObject:nowTime];
        //NSLog(@"dic[1]:%@",dic[1]);
        //当前价格
        //        NSString * str = dic[@"closePrice"];
        //        NSLog(@"%@ :%@",nowTime,str);
        //        NSRange priceRange = {0,str.length - 0};
        //        NSString * nowPrice = [str substringWithRange:priceRange];
        NSString * nowPrice = dic[@"closePrice"];
        //        NSLog(@"%@ %@",nowTime,nowPrice);
        //均价
        NSArray *item1 = @[nowPrice,closeYesterday,openPrice,topPrice,lowPrice,timeArr];
        //NSLog(@"item：%@",item1);
        //实时价格
        NSArray *item2 = @[nowPrice,closeYesterday,openPrice,topPrice,lowPrice,timeArr];
        //成交量
        
        [data1 addObject:item1];
        //NSLog(@"data1:%@",data1);
        [data2 addObject:item2];
        //[data3 addObject:item3];
    }
    //NSLog(@"data1:%@",data1);
    //        NSLog(@"category:%@",category);
    //上面构造数据的方法，可以按照需求更改；数据源构建完毕后，赋值到分时图上
    [self.stockChart appendToData:data1 forName:kFenShiAvgNameLine];
    //    NSLog(@"data1:%@",data1);
    [self.stockChart appendToData:data2 forName:kFenShiNowNameLine];
    //当被选中时，要显示的数据or文字v
    [self.stockChart appendToCategory:category forName:kFenShiAvgNameLine];
    [self.stockChart appendToCategory:category forName:kFenShiNowNameLine];
    //    self.stockChart.range = [responseObject[@"stockCount"] integerValue];
    //如果交易时间是09：30---23：30的
    if ([beginTime containsString:@"09:30"]) {
        self.stockChart.range = 14*60;
    }else{
        self.stockChart.range = 1440;
    }
    
    //    NSLog(@"11111range:%ld",self.stockChart.range);
    //重绘图表
    
    [self.stockChart setNeedsDisplay];
    
    
}
- (void)renderDayChart:(NSDictionary *)responseObject{
    
    
    NSMutableArray *data =[[NSMutableArray alloc] init];
    //用来储存日期
    _category =[[NSMutableArray alloc] init];
    //用换行符隔开变成数组
    NSArray * lines = responseObject[@"totalList"];
    
    
    for (NSInteger i = lines.count -1;i >= 0;i--) {
        
        NSDictionary  * dic = lines[i];
        //处理时间
        NSString * timeStr = dic[@"date"];
        NSString * dateStr;
        
        if ([_timeBucketStr containsString:@"Min"]) {
            NSRange dateRange = {11,5};
            dateStr = [timeStr substringWithRange:dateRange];
        }else{
            dateStr = [timeStr substringToIndex:timeStr.length -9];
        }
        
        [_category addObject:dateStr];
        
        NSMutableArray *item =[[NSMutableArray alloc] init];
        //open
        [item addObject:dic[@"openPrice"]];
        //close
        [item addObject:dic[@"closePrice"]];
        //high
        [item addObject:dic[@"highPrice"]];
        //low
        [item addObject:dic[@"lowPrice"]];
        //volume
        [item addObject:dic[@"hold"]];
        [data addObject:item];
    }
    
    if(data.count==0){
        return;
    }
    [_jsonDataArray removeAllObjects];
    [_jsonDataArray addObjectsFromArray:data];
    
    //    [self.stockChart reset];
    if (_btnTag != _nowOrDay) {
        [self.stockChart reset];
        _btnTag = _nowOrDay;
    }
    [self.stockChart clearData];
    [self.stockChart clearCategory];
    
    
    NSMutableDictionary *dic = [GYStockLineIndicators generateKLineData:data withKPIModel:_kpiModel];
    
    _jsonMessage = dic;
    [self setData:dic];
    //    NSMutableArray *cate = [[NSMutableArray alloc] init];
    //    for(int i=0;i<_category.count;i++){
    //        [cate addObject:_category[i]];
    //    }
    //
    [self setCategory:_category];
    
    [self.stockChart setNeedsDisplay];
}


-(void)setData:(NSDictionary *)dic{
    [self.stockChart appendToData:dic[@"price"] forName:@"price"];
    [self.stockChart appendToData:dic[@"vol"] forName:@"vol"];
    //
    if ([_primeType isEqualToString:@"MA"]) {
        [self.stockChart appendToData:dic[@"ma5"] forName:@"ma5"];
        [self.stockChart appendToData:dic[@"ma10"] forName:@"ma10"];
        [self.stockChart appendToData:dic[@"ma20"] forName:@"ma20"];
    }else if ([_primeType isEqualToString:@"BOLL"]){
        [self.stockChart appendToData:[dic objectForKey:@"MID"] forName:@"MID"];
        [self.stockChart appendToData:[dic objectForKey:@"UP"] forName:@"UP"];
        [self.stockChart appendToData:[dic objectForKey:@"DN"] forName:@"DN"];
    }else  if ([_primeType isEqualToString:@"ENV"]) {
        [self.stockChart appendToData:[dic objectForKey:@"ENVUP"] forName:@"ENVUP"];
        [self.stockChart appendToData:[dic objectForKey:@"ENVLOW"] forName:@"ENVLOW"];
        [self.stockChart appendToData:[dic objectForKey:@"ENVMID"] forName:@"ENVMID"];
    }
    
    [self.stockChart appendToData:dic[@"rsi6"] forName:@"rsi6"];
    [self.stockChart appendToData:dic[@"rsi12"] forName:@"rsi12"];
    [self.stockChart appendToData:dic[@"rsi24"] forName:@"rsi24"];
    
    [self.stockChart appendToData:dic[@"wr"] forName:@"wr"];
    [self.stockChart appendToData:dic[@"vr"] forName:@"vr"];
    
    [self.stockChart appendToData:dic[@"kdj_k"] forName:@"kdj_k"];
    [self.stockChart appendToData:dic[@"kdj_d"] forName:@"kdj_d"];
    [self.stockChart appendToData:dic[@"kdj_j"] forName:@"kdj_j"];
    
    [self.stockChart appendToData:[dic objectForKey:@"macd"] forName:@"macd"];
    [self.stockChart appendToData:[dic objectForKey:@"diff"] forName:@"diff"];
    [self.stockChart appendToData:[dic objectForKey:@"dea"] forName:@"dea"];
    
    NSMutableDictionary *serie = [self.stockChart getSerie:@"price"];
    if(serie == nil){
        return;
    }
}

-(void)setCategory:(NSArray *)category{
    
    [self.stockChart appendToCategory:category forName:@"price"];
    [self.stockChart appendToCategory:category forName:@"line"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)createScrollView
{
    _animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    // 设定动画选项
    _animation.duration = 10; // 持续时间
    _animation.repeatCount = FLT_MAX; // 重复次数
    
    // 设定旋转角度
    _animation.fromValue = [NSNumber numberWithFloat:0.0]; // 起始角度
    _animation.toValue = [NSNumber numberWithFloat:30 * M_PI]; // 终止角度
    
    
    //自选按钮的父视图
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(0,40, 50, 40)];
    _mainView.backgroundColor = [UIColor colorWithRed:31/255.0 green:36/255.0 blue:46/255.0 alpha:1.0];
    [self.view addSubview:_mainView];
    _menuScrollV.backgroundColor = [UIColor colorWithRed:31/255.0 green:36/255.0 blue:46/255.0 alpha:1.0];
    //边界回弹效果，默认开启
    _menuScrollV.bounces = NO;
    //设置指示条的显示
    _menuScrollV.showsHorizontalScrollIndicator = NO;
    _menuScrollV.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_menuScrollV];
    _itemInfoArray = [[NSMutableArray alloc] init];
    _scrollBtnArray = [[NSMutableArray alloc] init];
    _tipArray = [[NSMutableArray alloc] init];
    _itemArray = [[NSMutableArray alloc]initWithArray:@[@"日K",@"周K",@"月K",@"1分钟",@"5分钟",@"15分钟",@"30分钟",@"1小时",@"4小时"]];
    _itemIdArray = [[NSMutableArray alloc]initWithArray:@[@"Day",@"Week",@"Month",@"Min01",@"Min05",@"Min15",@"Min30",@"Min60",@"Min240"]];
    
    //创建自选按钮
    UIButton *mainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mainBtn.frame = CGRectMake(0, 0, 50, 38);
    [mainBtn setTitle:@"分时" forState:UIControlStateNormal];
    mainBtn.tintColor = [UIColor whiteColor];
    mainBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    //button.backgroundColor = [UIColor blackColor];
    //高亮状态
    [mainBtn setTitleColor:RedColor forState:UIControlStateSelected];
    //高亮状态发光效果
    //button.showsTouchWhenHighlighted = YES;
    [mainBtn addTarget:self action:@selector(ScrollMenuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    mainBtn.tag = 0;
    [_mainView addSubview:mainBtn];
    [_scrollBtnArray addObject:mainBtn];
    UIView * mainLineV = [[UIView alloc] initWithFrame:CGRectMake(0, 39, 50, 1)];
    mainLineV.backgroundColor = [UIColor colorWithRed:96/255.0 green:111/255.0 blue:143/255.0 alpha:1.0];
    [_mainView addSubview:mainLineV];
    UIImageView * mainTipV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 35, 50, 5)];
    [mainTipV setImage:[UIImage imageNamed:@"tip"]];
    [_mainView addSubview:mainTipV];
    [_tipArray addObject:mainTipV];
    //这是下端线的视图，要在这里添加，因为有层次
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, 10, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:96/255.0 green:111/255.0 blue:143/255.0 alpha:1.0];
    [_menuScrollV addSubview:lineView];
    //创建其他的市场按钮
    float menuWidth = 0.0;
    for (int i = 0;i<_itemArray.count; i++) {
        float itemWidth = 60.0;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSInteger len = [_itemArray[i] length];
        NSString *str = _itemArray[i];
        //NSLog(@"%@",str);
        if (len >= 3) {
            itemWidth = 80;
            if(len > 4){
                itemWidth = 100;
            }
        }
        UIImageView * tipImV = [[UIImageView alloc] initWithFrame:CGRectMake(menuWidth + (itemWidth - 50)/2, 35, 50, 5)];
        [tipImV setImage:[UIImage imageNamed:@"tip"]];
        //NSLog(@"itemWidth:%f",itemWidth);
        button.frame = CGRectMake(menuWidth, 0, itemWidth, 38);
        [button setTitle:str forState:UIControlStateNormal];
        button.tintColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        //button.backgroundColor = [UIColor blackColor];
        //高亮状态
        [button setTitleColor:RedColor forState:UIControlStateSelected];
        //高亮状态发光效果
        //button.showsTouchWhenHighlighted = YES;
        [button addTarget:self action:@selector(ScrollMenuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i+1;
        
        [_menuScrollV addSubview:button];
        [_menuScrollV addSubview:tipImV];
        
        menuWidth += itemWidth;
        [_itemInfoArray addObject:@(menuWidth)];
        //NSLog(@"@(menuWidth):%@",@(menuWidth));
        [_scrollBtnArray addObject:button];
        
        [_tipArray addObject:tipImV];
        
    }
    for (UIImageView * view in _tipArray) {
        view.hidden = YES;
    }
    UIImageView * view = [_tipArray objectAtIndex:_nowOrDay];
    view.hidden = NO;
    UIButton *button = _scrollBtnArray [_nowOrDay];
    
    button.selected = YES;
    _totalWidth = menuWidth;
    //为了适配ipad
    if (menuWidth < SCREEN_HEIGHT) {
        [lineView setFrame:CGRectMake(0, 39, SCREEN_HEIGHT, 1)];
    }else{
        [lineView setFrame:CGRectMake(0, 39, menuWidth, 1)];
    }
    //[lineView setFrame:CGRectMake(0, 39, menuWidth, 1)];
    [_menuScrollV setContentSize:CGSizeMake(menuWidth, 40)];
    
    
}
#pragma mark - 点击事件
- (void)ScrollMenuButtonClicked:(UIButton *)btn {
    [self changeButtonStateAtIndex:btn.tag];
    _nowOrDay = btn.tag;
    if(btn.tag !=0){
        _timeBucketStr = _itemIdArray[btn.tag - 1];
        self.stockChart.range = 55;
    }else{
        self.stockChart.range = 288;
    }
    
    self.stockChart.nowOrDay = _nowOrDay;
    
    [self.stockChart reset];
    //清除之前记录的日期
    [self.stockChart clearData];
    //清除数据
    [self.stockChart clearCategory];
    
    [self.stockChart.series removeAllObjects];
    if (_btnTag != _nowOrDay) {
        
        [self.stockChart setNeedsDisplay];
    }
    
    [self setSeries];
    [self getKLineData];
}
#pragma mark 选中第几个button
- (void)clickButtonAtIndex:(NSInteger)index {
    [self ScrollMenuButtonClicked:_scrollBtnArray[index]];
}

#pragma mark 改变第几个button为选中状态，不发送delegate
- (void)changeButtonStateAtIndex:(NSInteger)index {
    
    UIButton *button = [_scrollBtnArray objectAtIndex:index];
    [self changeButtonsToNormalState];
    button.selected = YES;
    if (index !=0) {
        [self moveMenuVAtIndex:index];
    }
    UIImageView * view = [_tipArray objectAtIndex:index];
    view.hidden = NO;
    
}

#pragma mark 取消所有button点击状态
-(void)changeButtonsToNormalState {
    for (UIButton *btn in _scrollBtnArray) {
        btn.selected = NO;
    }
    for (UIImageView * view in _tipArray) {
        view.hidden = YES;
    }
}

#pragma mark 移动button到可视的区域
- (void)moveMenuVAtIndex:(NSInteger)index {
    if (_itemInfoArray.count < index) {
        return;
    };
    //宽度小于320肯定不需要移动
    CGFloat Width = _menuScrollV.frame.size.width;
    if (_totalWidth <= Width) {
        
        return;
    }
    
    float buttonOrigin = [_itemInfoArray[index - 1] floatValue];
    if (buttonOrigin >= Width - 180) {
        if ((buttonOrigin - 180) >= _menuScrollV.contentSize.width - Width) {
            [_menuScrollV setContentOffset:CGPointMake(_menuScrollV.contentSize.width - Width, _menuScrollV.contentOffset.y) animated:YES];
            return;
        }
        
        float moveToContentOffset = buttonOrigin - 180;
        if (moveToContentOffset > 0) {
            [_menuScrollV setContentOffset:CGPointMake(moveToContentOffset, _menuScrollV.contentOffset.y) animated:YES];
        }
    }else{
        [_menuScrollV setContentOffset:CGPointMake(0, _menuScrollV.contentOffset.y) animated:YES];
        return;
    }
}

//KPISetView懒加载
- (UIView *)createMaSetView
{
    if (!self.maSetView) {
        self.maSetView = [[[NSBundle mainBundle] loadNibNamed:@"MAKPISetView" owner:nil options:nil] lastObject];
        self.maSetView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.maSetView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        [self.maSetView setMALables];
        
        __weak __typeof__(self) weakSelf = self;
        self.maSetView.valueBlock = ^(NSInteger M1Value,NSInteger M2Value,NSInteger M3Value){
            weakSelf.kpiModel.MA1 = M1Value;
            weakSelf.kpiModel.MA2 = M2Value;
            weakSelf.kpiModel.MA3 = M3Value;
            
            __strong __typeof(self) strongSelf = weakSelf;
            [strongSelf didSetValueForKpiValue];
            
        };
        
    }
    [self.maSetView setLablesWithKPIValue:[NSString stringWithFormat:@"%ld",_kpiModel.MA1] kpi2Value:[NSString stringWithFormat:@"%ld",_kpiModel.MA2] kpi3Value:[NSString stringWithFormat:@"%ld",_kpiModel.MA3]];
    return self.maSetView;
}

- (UIView *)createBOLLSetView
{
    if (!self.bollSetView) {
        self.bollSetView = [[[NSBundle mainBundle] loadNibNamed:@"MAKPISetView" owner:nil options:nil] lastObject];
        self.bollSetView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.bollSetView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        [self.bollSetView setBOLLLables];
        
        __weak __typeof__(self) weakSelf = self;
        self.bollSetView.valueBlock = ^(NSInteger M1Value,NSInteger M2Value,NSInteger M3Value){
            weakSelf.kpiModel.BOLL1 = M1Value;
            weakSelf.kpiModel.BOLL2 = M2Value;
            
            __strong __typeof(self) strongSelf = weakSelf;
            [strongSelf didSetValueForKpiValue];
        };
    }
    [self.bollSetView setLablesWithKPIValue:[NSString stringWithFormat:@"%ld",_kpiModel.BOLL1] kpi2Value:[NSString stringWithFormat:@"%ld",self.kpiModel.BOLL2] kpi3Value:0];
    
    return self.bollSetView;
    
}

- (UIView *)createENVSetView
{
    if (!self.envSetView) {
        self.envSetView = [[[NSBundle mainBundle] loadNibNamed:@"MAKPISetView" owner:nil options:nil] lastObject];
        self.envSetView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.envSetView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        [self.envSetView setENVLables];
        
        __weak __typeof__(self) weakSelf = self;
        self.envSetView.valueBlock = ^(NSInteger M1Value,NSInteger M2Value,NSInteger M3Value){
            weakSelf.kpiModel.ENV1 = M1Value;
            __strong __typeof(self) strongSelf = weakSelf;
            [strongSelf didSetValueForKpiValue];
        };
    }
    [self.envSetView setLablesWithKPIValue:[NSString stringWithFormat:@"%ld",_kpiModel.ENV1] kpi2Value:0 kpi3Value:0];
    return self.envSetView;
}
- (UIView *)createMACDSetView
{
    if (!self.macdSetView) {
        self.macdSetView = [[[NSBundle mainBundle] loadNibNamed:@"MAKPISetView" owner:nil options:nil] lastObject];
        self.macdSetView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.macdSetView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        [self.macdSetView setMACDLables];
        
        __weak __typeof__(self) weakSelf = self;
        self.macdSetView.valueBlock = ^(NSInteger M1Value,NSInteger M2Value,NSInteger M3Value){
            weakSelf.kpiModel.MACD1 = M1Value;
            weakSelf.kpiModel.MACD2 = M2Value;
            weakSelf.kpiModel.MACD3 = M3Value;
            
            __strong __typeof(self) strongSelf = weakSelf;
            [strongSelf didSetValueForKpiValue];
            
        };
        
    }
    [self.macdSetView setLablesWithKPIValue:[NSString stringWithFormat:@"%ld",_kpiModel.MACD1] kpi2Value:[NSString stringWithFormat:@"%ld",_kpiModel.MACD2] kpi3Value:[NSString stringWithFormat:@"%ld",_kpiModel.MACD3]];
    return self.macdSetView;
}

- (UIView *)createRSISetView
{
    if (!self.rsiSetView) {
        self.rsiSetView = [[[NSBundle mainBundle] loadNibNamed:@"MAKPISetView" owner:nil options:nil] lastObject];
        self.rsiSetView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.rsiSetView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        [self.rsiSetView setRSILables];
        
        __weak __typeof__(self) weakSelf = self;
        self.rsiSetView.valueBlock = ^(NSInteger M1Value,NSInteger M2Value,NSInteger M3Value){
            weakSelf.kpiModel.RSI1 = M1Value;
            weakSelf.kpiModel.RSI2 = M2Value;
            weakSelf.kpiModel.RSI3 = M3Value;
            
            __strong __typeof(self) strongSelf = weakSelf;
            [strongSelf didSetValueForKpiValue];
            
        };
        
    }
    [self.rsiSetView setLablesWithKPIValue:[NSString stringWithFormat:@"%ld",_kpiModel.RSI1] kpi2Value:[NSString stringWithFormat:@"%ld",_kpiModel.RSI2] kpi3Value:[NSString stringWithFormat:@"%ld",_kpiModel.RSI3]];
    return self.rsiSetView;
}

- (UIView *)createKDJSetView
{
    if (!self.kdjSetView) {
        self.kdjSetView = [[[NSBundle mainBundle] loadNibNamed:@"MAKPISetView" owner:nil options:nil] lastObject];
        self.kdjSetView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.kdjSetView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        [self.kdjSetView setKDJLables];
        
        __weak __typeof__(self) weakSelf = self;
        self.kdjSetView.valueBlock = ^(NSInteger M1Value,NSInteger M2Value,NSInteger M3Value){
            weakSelf.kpiModel.KDJ1 = M1Value;
            weakSelf.kpiModel.KDJ2 = M2Value;
            weakSelf.kpiModel.KDJ3 = M3Value;
            
            __strong __typeof(self) strongSelf = weakSelf;
            [strongSelf didSetValueForKpiValue];
            
        };
        
    }
    [self.kdjSetView setLablesWithKPIValue:[NSString stringWithFormat:@"%ld",_kpiModel.KDJ1] kpi2Value:[NSString stringWithFormat:@"%ld",_kpiModel.KDJ2] kpi3Value:[NSString stringWithFormat:@"%ld",_kpiModel.KDJ3]];
    return self.kdjSetView;
    
}

- (UIView *)createWRSetView
{
    if (!self.wrSetView) {
        self.wrSetView = [[[NSBundle mainBundle] loadNibNamed:@"MAKPISetView" owner:nil options:nil] lastObject];
        self.wrSetView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.wrSetView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        [self.wrSetView setWRLables];
        
        __weak __typeof__(self) weakSelf = self;
        self.wrSetView.valueBlock = ^(NSInteger M1Value,NSInteger M2Value,NSInteger M3Value){
            weakSelf.kpiModel.WR1 = M1Value;
            
            __strong __typeof(self) strongSelf = weakSelf;
            [strongSelf didSetValueForKpiValue];
            
        };
        
    }
    [self.wrSetView setLablesWithKPIValue:[NSString stringWithFormat:@"%ld",_kpiModel.WR1] kpi2Value:0 kpi3Value:0];
    return self.wrSetView;
}
- (void)didSetValueForKpiValue
{
    
    [self setSeries];
    [self.stockChart clearData];
    [self.stockChart clearCategory];
    
    NSMutableDictionary *dic = [GYStockLineIndicators generateKLineData:_jsonDataArray withKPIModel:_kpiModel];
    [self setData:dic];
    _jsonMessage = dic;
    
    NSMutableArray *cate = [[NSMutableArray alloc] init];
    for(int i=0;i<_category.count;i++){
        [cate addObject:_category[i]];
    }
    [self setCategory:cate];
    [self.stockChart setNeedsDisplay];
}


@end