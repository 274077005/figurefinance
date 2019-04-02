//
//  YYStockViewController.m
//  Treasure
//
//  Created by 耿一 on 16/4/22.
//  Copyright © 2016年 GY. All rights reserved.
//

#import "ChainStockVC.h"
#import "YYGetData.h"
#import "Section.h"
#import "GYURLConnection.h"
#import "GYStockLineIndicators.h"
#define RedColor [UIColor colorWithRed:253/255.0 green:62/255.0 blue:57/255.0 alpha:1.0]
#define GreenColor [UIColor colorWithRed:81/255.0 green:215/255.0 blue:106/255.0 alpha:1.0]
@interface ChainStockVC ()
{
    
    UIButton * _redactBtn;
    
    //数据源
    NSMutableArray * _detailArray;
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
    //用来判断是分时还是日K
    NSInteger _nowOrDay;
    //用来记录button的tag值来判断是否在重复（如一直刷新周K）
    NSInteger _btnTag;
    
    //拼链接的时间戳字串
    NSString * _timeBucketStr;
    
    
    NSMutableString * _URLStr;
    
    //KPI按钮数组
    NSMutableArray * _kpiBtnArray;
    
    NSMutableArray * _primeKpiBtnArray;
    
    
    //主视图要显示线的类型
    NSString * _primeType;
    
    NSString * _minorType;
    
    NSMutableArray * _primeTypeArray;
    NSMutableArray * _minorTypeArray;
    
    NSDictionary * _jsonMessage;
    NSMutableArray * _jsonDataArray;
    
    NSMutableArray * _category;
    
    //获取股票信息的定时器
    NSTimer * _getDetailTimer;
    
    NSTimer * _getKlineTimer;
    
    //控制数字渐变timer
    NSTimer * _changPriceTimer;
    
    BOOL _whetherFa;
    
    UIView * _bottomV;
    
    UIButton * _refreshBtn;
    
    UIButton *  _bellBtn;
    
    
}
@end

@implementation ChainStockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%f",StatusBarHeight);
    
    self.view.backgroundColor = [UIColor blackColor];
    self.topHeight.constant = TopHeight;
    [self createBlackNavStyle];
    self.labelsOfV.backgroundColor = [UIColor colorWithRed:22/255.0 green:25/255.0 blue:32/255.0 alpha:1.0];
    _nowKDataDic = [[NSMutableDictionary alloc]init];
    _detailArray = [[NSMutableArray alloc]init];
    _primeType = @"MA";
    _minorType = @"MACD";
    self.stockChart = [[EverChart alloc] initWithFrame:self.stockV.bounds];
    
    self.stockChart.range = 55;
    self.stockChart.nowOrDay = 999;
    
    _jsonMessage = [[NSDictionary alloc]init];
    _jsonDataArray = [[NSMutableArray alloc]init];
    
    
    [self updateLables];
    [self initChart];
    [self createBottomView];
    [self judgeIsOrNotFavoriteStock];
    
    [self setKpisValue];
    
    [self createStockDetail];
    
    [self createPrimeKPIView];
    
    [self.stockV addSubview:self.stockChart];
    [self createScrollView];
    
    //    [self getKLineData];
    [self createKPIView];
    [self createTitleView];
}

-(void)createTitleView
{
    UIView * titleV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, NavBarHeight)];
    
    UILabel * nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, titleV.width, NavBarHeight/2 - 5)];
    nameLab.text = self.detailModel.name;
    nameLab.textColor = [UIColor whiteColor];
    nameLab.font = [UIFont boldSystemFontOfSize:15];
    nameLab.textAlignment = NSTextAlignmentCenter;
    [titleV addSubview:nameLab];
    
    NSString * currencyStr = [NSString stringWithFormat:@"%@/%@",self.detailModel.coin,self.detailModel.currency];
    UILabel * currencyLab = [[UILabel alloc]initWithFrame:CGRectMake(0, nameLab.bottom, titleV.width, NavBarHeight - nameLab.top - nameLab.height)];
    currencyLab.textColor = [UIColor whiteColor];
    currencyLab.font = [UIFont systemFontOfSize:13];
    currencyLab.textAlignment = NSTextAlignmentCenter;
    currencyLab.text = [currencyStr uppercaseString];
    [titleV addSubview:currencyLab];
    
    self.navigationItem.titleView = titleV;
}
//隐藏显示navigationBar
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self createGetDetailTimer];
    //恢复竖屏
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = 0;
    //    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    //    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
    
    [_getDetailTimer invalidate];
    _getDetailTimer = nil;
    [_getKlineTimer invalidate];
    _getKlineTimer = nil;
    [_changPriceTimer invalidate];
    _changPriceTimer = nil;
    [super viewWillDisappear:animated];
}

- (void)createGetDetailTimer
{
    _getDetailTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(createStockDetail) userInfo:nil repeats:YES];
    _getKlineTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getKLineData) userInfo:nil repeats:YES];
    _changPriceTimer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(changePriceLable) userInfo:nil repeats:YES];
    [_changPriceTimer setFireDate:[NSDate distantFuture]];
}

//设置各种Kpi的初始化值
- (void)setKpisValue
{
    _kpiModel = [[GYStockKPIModel alloc]init];
    
}
- (void)judgeIsOrNotFavoriteStock
{
    
}
- (void)createBottomView
{
    _bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    CGFloat bottomHeight = _bottomV.frame.size.height;
    [self.view addSubview:_bottomV];
    
    _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _refreshBtn.frame = CGRectMake(0, 0, 34, 34);
    _refreshBtn.center = CGPointMake(20,bottomHeight / 2 );
    
    [_refreshBtn addTarget:self action:@selector(getKLineData) forControlEvents:UIControlEventTouchUpInside];
    [_refreshBtn setImage:[[UIImage imageNamed:@"refresh"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    _animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    // 设定动画选项
    _animation.duration = 10; // 持续时间
    _animation.repeatCount = FLT_MAX; // 重复次数
    
    // 设定旋转角度
    _animation.fromValue = [NSNumber numberWithFloat:0.0]; // 起始角度
    _animation.toValue = [NSNumber numberWithFloat:30 * M_PI]; // 终止角度
    
    
    
    [_bottomV addSubview:_refreshBtn];
    
    
    //    UIButton * revolveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    revolveBtn.frame = CGRectMake(0, 0, 34, 34);
    //    revolveBtn.center = CGPointMake(SCREEN_WIDTH - 27,bottomHeight / 2 );
    //    [revolveBtn setImage:[UIImage imageNamed:@"revolve"] forState:UIControlStateNormal];
    //    [revolveBtn addTarget:self action:@selector(revolveScreen) forControlEvents:UIControlEventTouchUpInside];
    //    [_bottomV addSubview:revolveBtn];
    
    
    UIButton * drawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    drawBtn.frame = CGRectMake(0, 0, 80, 34);
    drawBtn.center = CGPointMake(80, bottomHeight/2);
    [drawBtn setTitle:@"画画" forState:UIControlStateNormal];
    [drawBtn setImage:[[UIImage imageNamed:@"drawBoard"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [drawBtn setTintColor:[UIColor whiteColor]];
    drawBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    drawBtn.adjustsImageWhenHighlighted = NO;
    [drawBtn addTarget:self action:@selector(drawButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomV addSubview:drawBtn];
    
    
    //因为刚进来是分时图 所以不需要显示
    [self.stockChart setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -40 -_labelsOfV.height - TopHeight - 50)];
    [self.stockChart getSection:1].hidden = YES;
    
    
}

- (void)drawButtonClick
{
    UIImage*image = [GYToolKit snapshotSingleView:KeyWindow];
    
    DrawingBoardViewController * DrawVC = [[DrawingBoardViewController alloc]init];
    DrawVC.drawImage = image;
    DrawVC.navigationItem.title = self.navigationItem.title;
    
    DrawVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:DrawVC animated:YES completion:nil];
}

- (void)revolveScreen{
    
    //跳转到应用的详情页
    //    StockRevolveVC * revolveVC = [[StockRevolveVC alloc]initWithNibName:@"StockRevolveVC" bundle:nil];
    //
    //    revolveVC.nowOrDay = _nowOrDay;
    //    revolveVC.primeType = _primeType;
    //    revolveVC.minorType = _minorType;
    //    revolveVC.timeBucketStr = _timeBucketStr;
    //
    //    revolveVC.detailModel = self.detailModel;
    //
    //    revolveVC.kpiModel = _kpiModel;
    //    revolveVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //    [self presentViewController:revolveVC animated:YES completion:nil];
}
//设置主图指标视图
- (void)createPrimeKPIView
{
    self.primeKPIV.backgroundColor = [UIColor colorWithRed:22/255.0 green:25/255.0 blue:32/255.0 alpha:1.0];
    UIButton * primeSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    primeSetBtn.frame = CGRectMake(SCREEN_WIDTH - 30, 0, 25, 25);
    [primeSetBtn setImage:[UIImage imageNamed:@"KPISet"] forState:UIControlStateNormal];
    [primeSetBtn addTarget:self action:@selector(primeKpiSetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.primeKPIV addSubview:primeSetBtn];
    
    _primeKpiBtnArray = [[NSMutableArray alloc]init];
    _primeTypeArray = [[NSMutableArray alloc]initWithArray:@[@"MA",@"BOLL",@"ENV"]];
    float menuWidth = 10.0;
    for (int i = 0;i<_primeTypeArray.count; i++) {
        float itemWidth = 60.0;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *str = _primeTypeArray[i];
        //NSLog(@"itemWidth:%f",itemWidth);
        button.frame = CGRectMake(menuWidth, 5, itemWidth - 10, 20);
        [button setTitle:str forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
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
    UIButton *button = _primeKpiBtnArray[0];
    button.backgroundColor = [UIColor colorWithRed:31/255.0 green:36/255.0 blue:46/255.0 alpha:1.0];
    button.selected = YES;
    
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
- (void)createKPIView
{
    self.stockV.backgroundColor = [UIColor colorWithRed:22/255.0 green:25/255.0 blue:32/255.0 alpha:1.0];
    self.KPIV.backgroundColor = [UIColor colorWithRed:22/255.0 green:25/255.0 blue:32/255.0 alpha:1.0];
    UIButton * minorSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    minorSetBtn.frame = CGRectMake(SCREEN_WIDTH - 30, 0, 25, 25);
    [minorSetBtn setImage:[UIImage imageNamed:@"KPISet"] forState:UIControlStateNormal];
    [minorSetBtn addTarget:self action:@selector(minorKpiSetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.KPIV addSubview:minorSetBtn];
    
    _kpiBtnArray = [[NSMutableArray alloc] init];
    _minorTypeArray = [[NSMutableArray alloc]initWithArray:@[@"MACD",@"RSI",@"KDJ",@"WR"]];
    float menuWidth = 10.0;
    for (int i = 0;i<_minorTypeArray.count; i++) {
        float itemWidth = 60.0;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *str = _minorTypeArray[i];
        //NSLog(@"itemWidth:%f",itemWidth);
        button.frame = CGRectMake(menuWidth, 0, itemWidth - 10, 24);
        [button setTitle:str forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
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
    UIButton *button = _kpiBtnArray[0];
    button.backgroundColor = [UIColor colorWithRed:31/255.0 green:36/255.0 blue:46/255.0 alpha:1.0];
    button.selected = YES;
    
}
//次图设置按钮点击
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
    }
}
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
//根据网络上获取到的数据来显示
- (void)createStockDetail{
    
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    
    
    NSString * pairStr = [NSString stringWithFormat:@"%@_%@",self.detailModel.coin,self.detailModel.currency];
    NSString * getUrl = [NSString stringWithFormat:@"https://app.blockmeta.com/ticker?exchange=%@&pair=%@",self.detailModel.key,pairStr];
    [bodyDic setObject:getUrl forKey:@"getUrl"];
    [GYPostData PostBBTInfoWithDic:bodyDic UrlPath:JMarketList Handler:^(NSDictionary * jsonDic, NSError * error) {
        if (!error) {
            if ([jsonDic[@"status"]integerValue] == 0) {
                self.detailModel = [ChainDetailModel mj_objectWithKeyValues:jsonDic[@"ticker"]];
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
//把之前那一页传过来的数据先呈现出来
- (void)updateLables
{
    self.navigationItem.title = self.detailModel.name;
    self.lastLab.text = [GYToolKit changeWithFormat:2 FloatNumber:self.detailModel.ticker.price_24h_before];
    
    //    if ([self.detailModel.nowP isEqualToString:@"--"]) {
    //        return;
    //    }
    CTickerModel * tickerModel = self.detailModel.ticker;
    self.detailModel.chinaP = self.detailModel.convert_cny * tickerModel.last;
    self.timeLab.text = [NSString stringWithFormat:@"交易量: %@",[GYToolKit changeWithFormat:3 FloatNumber:self.detailModel.ticker.volume]];
    self.priceLab.text = [NSString stringWithFormat:@"￥%@",[GYToolKit changeWithFormat:2 FloatNumber:self.detailModel.chinaP]];
    self.lastLab.text = [GYToolKit changeWithFormat:2 FloatNumber:self.detailModel.chinaP];
    self.detailModel.mp = (tickerModel.last - tickerModel.price_24h_before)/tickerModel.price_24h_before * 100;
    self.marginLab.text = [NSString stringWithFormat:@"%@%%",[GYToolKit changeWithFormat:2 FloatNumber:self.detailModel.mp]];
    self.mpLab.text = [NSString stringWithFormat:@"价 %@",[GYToolKit changeWithFormat:2 FloatNumber:tickerModel.last]];
    [_changPriceTimer setFireDate:[NSDate distantPast]];
    if (tickerModel.last < tickerModel.price_24h_before) {
        
        self.priceLab.textColor = RedColor;
        self.marginLab.textColor = RedColor;
        self.mpLab.textColor = RedColor;
    }else{
        
        self.priceLab.textColor = GreenColor;
        self.marginLab.textColor = GreenColor;
        self.mpLab.textColor = GreenColor;
    }
    CGFloat  high = self.detailModel.convert_cny * tickerModel.high;
    self.topLab.text = [GYToolKit changeWithFormat:2 FloatNumber:high];
    if (tickerModel.high < tickerModel.price_24h_before) {
        self.topLab.textColor = RedColor;
    }else{
        self.topLab.textColor = GreenColor;
    }
    CGFloat  low = self.detailModel.convert_cny * tickerModel.low;
    self.lowLab.text =  [GYToolKit changeWithFormat:2 FloatNumber:low];
    if (tickerModel.low < tickerModel.price_24h_before) {
        self.lowLab.textColor = RedColor;
    }else{
        self.lowLab.textColor = GreenColor;
    }
    CGFloat  open = self.detailModel.convert_cny * tickerModel.price_24h_before;
    self.openLab.text = [GYToolKit changeWithFormat:2 FloatNumber:open];
    //    if (tickerModel.price_24h_before > [self.detailModel.lastClose floatValue]) {
    //        self.openLab.textColor = RedColor;
    //    }else{
    //        self.openLab.textColor = GreenColor;
    //    }
    
    
}
//渐变数字lab
- (void)changePriceLable
{
    
    //    [GYStockLineIndicators gradualChangeLabWithEndNum:[GYToolKit changeWithFormat:2 FloatNumber:self.detailModel.ticker.last] Lab:self.priceLab Timer:_changPriceTimer];
    
}
- (void)backToFrontPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getKLineData
{
    
    //kkkkkkkkkkkkk
    [_refreshBtn.layer addAnimation:_animation forKey:@"refreshBtnAnimation"];
    
    [self.stockChart getSection:1].hidden = NO;
    [self.stockChart setFrame:CGRectMake(0, 25, SCREEN_WIDTH, SCREEN_HEIGHT -40 -_labelsOfV.height - TopHeight - 30 - 25 - 50)];

    //假如现在有好几个请求k线数据的请求在队列中，取消其他的，防止因为有的请求慢导致k线呈现错误
    AFHTTPSessionManager *manager = [AFHTTPSessionManager shareManager];
    //取消所有的网络请求
//    [manager.operationQueue cancelAllOperations];
    [manager.tasks makeObjectsPerformSelector:@selector(cancel)];
//    NSLog(@"线程个数:%ld",manager.tasks.count);
    
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    NSString * pairStr = [NSString stringWithFormat:@"%@_%@",self.detailModel.coin,self.detailModel.currency];
    NSString * getUrl = [NSString stringWithFormat:@"https://app.blockmeta.com/ticker/kline?exchange=%@&level=%@&pair=%@",self.detailModel.key,_timeBucketStr,pairStr];
    [bodyDic setObject:getUrl forKey:@"getUrl"];
    NSLog(@"%@",_timeBucketStr);
    //直接请求
//    [GYPostData GetBTCDic:bodyDic UrlPath:getUrl Handler:^(NSArray * jsonArr, NSError * error){
    [GYPostData PostBBTKDataInfoWithDic:bodyDic UrlPath:JMarketList Handler:^(NSArray * jsonArr, NSError * error) {
        
        [_refreshBtn.layer removeAllAnimations];
        if (!error) {
            
            if (!_isOrNotGetKLineData) {
                [self.stockChart reset];
                _isOrNotGetKLineData = YES;
            }
            
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
            
            NSDictionary * responseObject = @{@"data":jsonArr};
            
            [self renderDayChart:responseObject];
            
        }else{
            if ([error code] != -999 ) {
                [SVProgressHUD showWithString:@"网络故障"];
            }
        }
    }];
    
    
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
}
-(void)setSeries
{
    NSMutableArray * KlineSeriesArr = [GYStockLineIndicators setDayKLineSeriesWithKPIModel:_kpiModel];
    //candleChart init
    [self.stockChart setSeries:KlineSeriesArr[0]];
    
    [[self.stockChart sections][0] setSeries:KlineSeriesArr[1]];
    [[self.stockChart sections][1] setSeries:KlineSeriesArr[2]];
    [[self.stockChart sections][1] setPaging:YES];
    
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

- (void)renderDayChart:(NSDictionary *)responseObject{

    
    NSMutableArray *data =[[NSMutableArray alloc] init];
    //用来储存日期
    _category =[[NSMutableArray alloc] init];
    //用换行符隔开变成数组
    NSArray * lines = responseObject[@"data"];
    
    if (lines.count < 1) {
        
        
        return;
    }
    
    for (NSInteger i = 0 ;i < lines.count;i++) {
        
        
        NSDictionary  * dic = lines[i];
        //处理时间
        NSInteger dateStr = [dic[@"date"] integerValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateStr];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        //设定时间格式,这里可以设置成自己需要的格式
        //        yyyy-MM-dd HH:mm:ss
        if (_nowOrDay <= 4) {
            [dateFormatter setDateFormat:@"HH:mm"];
        }else{
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }
        
        NSString *currentDateStr = [dateFormatter stringFromDate:date];
        [_category addObject:currentDateStr];
        
        NSMutableArray *item =[[NSMutableArray alloc] init];
        //open
        [item addObject:dic[@"open"]];
        //close
        [item addObject:dic[@"close"]];
        //high
        [item addObject:dic[@"high"]];
        //low
        [item addObject:dic[@"low"]];
        //volume
        [item addObject:dic[@"vol"]];
        [data addObject:item];
    }
    
    if(data.count==0){
        return;
    }
    [_jsonDataArray removeAllObjects];
    [_jsonDataArray addObjectsFromArray:data];

 
    if (_btnTag != _nowOrDay) {
        [self.stockChart reset];
        _btnTag = _nowOrDay;
    }
    
    [self.stockChart clearData];
    [self.stockChart clearCategory];
    
    
    NSMutableDictionary *dic = [GYStockLineIndicators generateKLineData:data withKPIModel:_kpiModel];
    
    _jsonMessage = dic;
    [self setData:dic];

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

- (void)createScrollView
{
    //自选按钮的父视图
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
    _itemArray = [[NSMutableArray alloc]initWithArray:@[@"1分钟",@"5分钟",@"15分钟",@"30分钟",@"60分钟",@"日K",@"周K",@"月K"]];
    _itemIdArray = [[NSMutableArray alloc]initWithArray:@[@"1min",@"5min",@"15min",@"30min",@"1hour",@"1day",@"1week",@"1month"]];
    
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
        button.tag = i;
        [button addTarget:self action:@selector(ScrollMenuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
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
    UIView * tipV = _tipArray.firstObject;
    tipV.hidden = NO;
    _timeBucketStr = _itemIdArray[0];
    UIButton *button = _scrollBtnArray [0];
    
    button.selected = YES;
    _totalWidth = menuWidth;
    //为了适配ipad
    if (menuWidth < SCREEN_WIDTH) {
        [lineView setFrame:CGRectMake(0, 39, SCREEN_WIDTH, 1)];
    }else{
        [lineView setFrame:CGRectMake(0, 39, menuWidth, 1)];
    }
    //[lineView setFrame:CGRectMake(0, 39, menuWidth, 1)];
    [_menuScrollV setContentSize:CGSizeMake(menuWidth, 40)];
    
}
#pragma mark - 点击事件
- (void)ScrollMenuButtonClicked:(UIButton *)btn {
    [self changeButtonStateAtIndex:btn.tag];
    NSLog(@"BBBB:%ld",btn.tag);
    _nowOrDay = btn.tag;

    _timeBucketStr = _itemIdArray[btn.tag];
    
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
    //NSLog(@"count:%ld",_scrollBtnArray.count);
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

// 使用segue正向传值给详情界面
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //    //正向传值
    //    StockRevolveViewController * revolveVC = segue.destinationViewController;
    //    revolveVC.nowOrDay = _nowOrDay;
    //    revolveVC.primeType = _primeType;
    //    revolveVC.minorType = _minorType;
    //    revolveVC.timeBucketStr = _timeBucketStr;
    //    if (_detailArray.count >0) {
    //        revolveVC.detailModel = _detailArray[0];
    //    }
    //    revolveVC.kpiModel = _kpiModel;
    
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
- (void)dealloc{
    NSLog(@"K线图dealloc");
}
@end
