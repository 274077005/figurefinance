//
//  HomeNewsV.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/9.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "MarketListV.h"

@implementation MarketListV
{
    //记录新获取的价格的数组
    NSMutableArray * _nowDataArray;
    //记录上次刷新时价格的数组
    NSMutableArray * _beforeDataArray;
    
//    //获取股票信息的定时器
//    NSTimer * _stockTimer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"%f",self.height);
        _nowDataArray = [[NSMutableArray alloc]init];
        _beforeDataArray = [[NSMutableArray alloc]init];
        [self createTableView];
        [self setUpTableView];
        [self createHeaderView];

        
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    [self getListData];
    
}

- (void)createHeaderView
{
    UIView * labelOfLabs = [[UIView alloc] init];
    labelOfLabs.frame = CGRectMake(0, SCREEN_HEIGHT * 33/667 + 1, SCREEN_WIDTH, SCREEN_HEIGHT * 27/667);
    labelOfLabs.backgroundColor = CellColor;
    
    NSArray * titleArr = @[@"交易量",@"最新价(￥)",@"涨跌幅"];
    for (int i = 0 ; i < titleArr.count; i++) {
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.textAlignment = NSTextAlignmentLeft;
        
        switch (i) {
            case 0:{
                titleLab.frame = CGRectMake(15 ,0, SCREEN_WIDTH * 0.28, labelOfLabs.frame.size.height);
                break;
            }
            case 1:{
                titleLab.frame = CGRectMake(SCREEN_WIDTH -(SCREEN_WIDTH * 0.4 + 25) ,0, SCREEN_WIDTH * 0.21, labelOfLabs.frame.size.height);
                titleLab.textAlignment = NSTextAlignmentRight;
                break;
            }
            case 2:{
                titleLab.frame = CGRectMake(SCREEN_WIDTH -(SCREEN_WIDTH * 0.19 + 15),0, SCREEN_WIDTH * 0.19, labelOfLabs.frame.size.height);
                titleLab.textAlignment = NSTextAlignmentRight;
                break;
            }
            default:
                break;
        }
        titleLab.font = [UIFont systemFontOfSize:13];
        titleLab.text = titleArr[i];
        titleLab.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
        
        [labelOfLabs addSubview:titleLab];
    }
    UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(0, labelOfLabs.height - 0.5, SCREEN_WIDTH, 0.5)];
    lineV.backgroundColor = RGBCOLOR(237, 237, 337);
    [labelOfLabs addSubview:lineV];
    self.tableView.tableHeaderView = labelOfLabs;
}
//下拉刷新
- (void)loadRefreshData
{
    self.tableView.mj_footer.state = MJRefreshStateIdle;
    [self getListData];
}



-(void)createTableView
{
    self.tableView = [[UITableView alloc]init];
    CGRect tableFrame = self.bounds;
    
    self.tableView.frame = tableFrame;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = WD_BACKCOLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    [self addSubview:self.tableView];
}
- (void)setUpTableView
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefreshData)];
    
    self.tableView.frame = self.bounds;
    //图文集
    [self.tableView registerNib:[UINib nibWithNibName:@"ChainTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChainCellId"];
    
    
}
#pragma mark - Table view data source
-(void)getListData
{
    
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    NSString * getUrl = [NSString stringWithFormat:@"https://app.blockmeta.com/tickers/coin?key=%@",self.theId];
    [bodyDic setObject:getUrl forKey:@"getUrl"];
    //自己原生直接发起Get请求的话，在请求头里加上这个
//    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"from"];
    //直接请求
//    [GYPostData GetBTCDic:bodyDic UrlPath:getUrl Handler:^(NSDictionary *jsonDic, NSError * error) {
    [GYPostData PostBBTInfoWithDic:bodyDic UrlPath:JMarketList Handler:^(NSDictionary *jsonDic, NSError * error) {
        [self.tableView.mj_header endRefreshing];
        if (!error) {
            
            [_beforeDataArray removeAllObjects];
            [_beforeDataArray addObjectsFromArray:_nowDataArray];
            
            [self setUpNowDataWithDic:jsonDic];
            
        }else{
            [SVProgressHUD showWithString:@"网络故障"];
        }
    }];
//    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
//    NSString * getUrl = [NSString stringWithFormat:@"https://app.blockmeta.com/tickers/coin?key=%@",self.theId];
//    [bodyDic setObject:getUrl forKey:@"getUrl"];
//    //自己原生直接发起Get请求的话，在请求头里加上这个
//    //    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"from"];
//    [GYPostData GetBTCDic:bodyDic UrlPath:getUrl Handler:^(NSDictionary *jsonDic, NSError * error) {
//        [self.tableView.mj_header endRefreshing];
//        if (!error) {
//            
//            [_beforeDataArray removeAllObjects];
//            [_beforeDataArray addObjectsFromArray:_nowDataArray];
//            
//            [self setUpNowDataWithDic:jsonDic];
//            
//        }else{
//            [SVProgressHUD showWithString:@"网络故障"];
//        }
//    }];
}
- (void)setUpNowDataWithDic:(NSDictionary *)dataDic
{
    [_nowDataArray removeAllObjects];
    NSArray * dataArr = [ChainDetailModel mj_objectArrayWithKeyValuesArray:dataDic[@"tickers"]];
    for (ChainDetailModel * detailModel in dataArr) {
        CTickerModel * tickerModel = detailModel.ticker;
        detailModel.chinaP = detailModel.convert_cny * tickerModel.last;
        detailModel.mp = (tickerModel.last - tickerModel.price_24h_before)/tickerModel.price_24h_before * 100;
        [_nowDataArray addObject:detailModel];
    }
    
    [self.tableView reloadData];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _nowDataArray.count;
}

//设定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChainCellId" forIndexPath:indexPath];
    //不让cell有选中状态
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //用来判断cell用不用做动画效果
    NSInteger changeColor = 0;
    //来判断是否变大
    NSInteger isOrNotBiger = 0;
    ChainDetailModel * nowModel = _nowDataArray[indexPath.row];
    if (_beforeDataArray.count == _nowDataArray.count) {
        ChainDetailModel * beforeModel = _beforeDataArray[indexPath.row];

        if (nowModel.chinaP  > beforeModel.chinaP) {
            changeColor = 1;
            isOrNotBiger = 1;
        }else if(nowModel.chinaP  < beforeModel.chinaP){
            changeColor = 1;
            isOrNotBiger = 0;
        }
    }
    //比较这次的价格和上次的价格区别
    //获取／展示数据
    [cell updateWithModel:nowModel changeColor:changeColor isOrNotBiger:isOrNotBiger];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChainDetailModel * detailModel = _nowDataArray[indexPath.row];
    ChainStockVC * stockVC = [[ChainStockVC alloc]init];
    stockVC.detailModel = detailModel;
    [self.viewContoller.navigationController pushViewController:stockVC animated:YES];
    
}
-(void)dealloc
{
    NSLog(@"MarketList Dealloc");
}
//销毁定时器
//- (void)willMoveToSuperview:(UIView *)newSuperview {
//    
//    [super willMoveToSuperview:newSuperview];
//    if (! newSuperview && _stockTimer) {
//        // 销毁定时器
//        [_stockTimer invalidate];
//        _stockTimer = nil;
//    }
//}
@end
