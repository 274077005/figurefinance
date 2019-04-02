//
//  LoveStockListVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/6/26.
//  Copyright © 2018年 耿一. All rights reserved.
//



#import "LoveStockListVC.h"

@interface LoveStockListVC ()
{
    NSMutableArray * _kindIdArr;
    
    //记录新获取的价格的数组
    NSMutableArray * _nowDataArray;
    //记录上次刷新时价格的数组
    NSMutableArray * _beforeDataArray;
    
    //获取股票信息的定时器
    NSTimer * _stockTimer;
}

@end

@implementation LoveStockListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"外汇行情";

    _kindIdArr = [[NSMutableArray alloc]init];
    _beforeDataArray = [[NSMutableArray alloc]init];
    _nowDataArray = [[NSMutableArray alloc]init];
//    [self createBlackNavStyle];
    [self createTableView];
    [self setUpTableView];
//    [self createStockTimer];
    [self createHeaderView];

    
    // Do any additional setup after loading the view.
}
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    
//    return UIStatusBarStyleLightContent;
//    
//}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createLoveKindArr];
    if (!_stockTimer) {
        [self createStockTimer];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [_stockTimer invalidate];
    _stockTimer = nil;
    
}
- (void)createHeaderView
{
    UIView * labelOfLabs = [[UIView alloc] init];
    labelOfLabs.frame = CGRectMake(0, SCREEN_HEIGHT * 33/667 + 1, SCREEN_WIDTH, SCREEN_HEIGHT * 27/667);
    labelOfLabs.backgroundColor = CellColor;
    
    NSArray * titleArr = @[@"品种",@"最新价",@"涨跌",@"涨跌幅"];
    for (int i = 0 ; i < titleArr.count; i++) {
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.textAlignment = NSTextAlignmentLeft;
        
        switch (i) {
            case 0:{
                titleLab.frame = CGRectMake(10 ,0, SCREEN_WIDTH * 0.28, labelOfLabs.frame.size.height);
                break;
            }
            case 1:{
                titleLab.frame = CGRectMake(15 + SCREEN_WIDTH * 0.28 ,0, SCREEN_WIDTH * 0.21, labelOfLabs.frame.size.height);
                titleLab.textAlignment = NSTextAlignmentLeft;
                break;
            }
            case 2:{
                titleLab.textAlignment = NSTextAlignmentRight;
                titleLab.frame = CGRectMake(SCREEN_WIDTH -(SCREEN_WIDTH * 0.41 + 20),0, SCREEN_WIDTH * 0.22, labelOfLabs.frame.size.height);
                titleLab.textAlignment = NSTextAlignmentRight;
                break;
            }
            case 3:{
                titleLab.frame = CGRectMake(SCREEN_WIDTH -(SCREEN_WIDTH * 0.19 + 10),0, SCREEN_WIDTH * 0.19, labelOfLabs.frame.size.height);
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
//自动获取股票信息的定时器
-(void)createStockTimer
{
    _stockTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getListData) userInfo:nil repeats:YES];
    
}

//创建喜欢的品种的Id数组
- (void)createLoveKindArr
{
    [_kindIdArr removeAllObjects];
    NSArray * idArray = [UserDefaults arrayForKey:@"favoriteKindIdArr"];
    if (idArray) {
        [_kindIdArr addObjectsFromArray:idArray];
    }else{
        NSArray * firstArr = @[@"USDX",@"EURUSD",@"USDCNY"];
        [_kindIdArr addObjectsFromArray:firstArr];
        [UserDefaults  setObject:firstArr forKey:@"favoriteKindIdArr"];
    }
    [self getListData];
}
-(void)setUpTableView
{
    if ([self.theId isEqualToString:@"5"]) {
        
        
        CGRect tableFrame = self.view.bounds;
        self.tableView.frame = tableFrame;
    }
    
    self.tableView.backgroundColor = WD_BACKCOLOR;
    //注册cell类型及复用标识
    [self.tableView registerNib:[UINib nibWithNibName:@"StockTableViewCell" bundle:nil] forCellReuseIdentifier:@"StockCellId"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getListData)];
    
    UIButton * footerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    footerBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT * 40/667);
    [footerBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [footerBtn setTitle:@"编辑自选" forState:UIControlStateNormal];
    footerBtn.tintColor = RGBCOLOR(31, 31, 31);
    footerBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    footerBtn.backgroundColor = RGBCOLOR(255, 255, 255);
    [footerBtn addTarget:self action:@selector(footerBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footerBtn;
}
- (void)footerBtnClicked
{
    StockRedactVC * redactVC = [[StockRedactVC alloc]init];
    redactVC.allDataArr = _allDataDic[@"result"];
    NSLog(@"%@",_kindIdArr);
    
    redactVC.loveArr = _kindIdArr;
    [self.navigationController pushViewController:redactVC animated:YES];
}
-(void)getListData
{
    [GYPostData GetStockDataWithUrlPath:@"https://app5.fx168api.com//quotation/3.2.6/getQuotationNavConfig.json?key=wh&t=" Handler:^(NSDictionary * jsonDic, NSError * error) {
        [self.tableView.mj_header endRefreshing];
        if (!error) {
            if ([jsonDic[@"status"]integerValue]==0) {
                [_beforeDataArray removeAllObjects];
                [_beforeDataArray addObjectsFromArray:_nowDataArray];
                
                self.allDataDic = jsonDic[@"data"];
                [self setUpNowDataWithDic:jsonDic[@"data"]];
            }
        }else{
            [SVProgressHUD showWithString:@"网络故障"];
        }
    }];
}
- (void)setUpNowDataWithDic:(NSDictionary *)dataDic
{
    [_nowDataArray removeAllObjects];
    NSArray * dataArr = [StockDetailModel mj_objectArrayWithKeyValuesArray:dataDic[@"result"]];
    for (NSInteger i = 0; i < _kindIdArr.count; i++) {
        NSString * kindId = _kindIdArr[i];
        for (StockDetailModel * detailModel in dataArr) {
            if ([kindId isEqualToString:detailModel.keyRemark]) {
                [_nowDataArray addObject:detailModel];
                break;
            }
        }
        
    }
    [self.tableView reloadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    return 50;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StockCellId" forIndexPath:indexPath];
    //不让cell有选中状态
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //用来判断cell用不用做动画效果
    NSInteger changeColor = 0;
    //来判断是否变大
    NSInteger isOrNotBiger = 0;
    StockDetailModel * nowModel = _nowDataArray[indexPath.row];
    if (_beforeDataArray.count == _nowDataArray.count) {
        StockDetailModel * beforeModel = _beforeDataArray[indexPath.row];
         StockDetailModel * nowModel = _nowDataArray[indexPath.row];
        if ([nowModel.nowP floatValue] > [beforeModel.nowP floatValue]) {
            changeColor = 1;
            isOrNotBiger = 1;
        }else if([nowModel.nowP floatValue] < [beforeModel.nowP floatValue]){
            changeColor = 1;
            isOrNotBiger = 0;
        }
    }
    //比较这次的价格和上次的价格区别
    //获取／展示数据
    [cell updateWithModel:nowModel changeColor:changeColor isOrNotBiger:isOrNotBiger end:1];
    
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StockDetailModel * nowModel = _nowDataArray[indexPath.row];
    StockViewController * stockVC = [[StockViewController alloc]init];
    stockVC.detailModel = nowModel;
    [self.navigationController pushViewController:stockVC animated:YES];
    
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
