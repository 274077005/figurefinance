//
//  BellViewController.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/23.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BellViewController.h"

@interface BellViewController ()
{
    NSMutableArray * _newsArr;
    GetDataType _getDataType;
    NSInteger _index;
}

@end

@implementation BellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息通知";
    _newsArr = [[NSMutableArray alloc]init];
    [self createTableView];
    
    [self setUpTableView];
    [self loadRefreshData];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUpTableView
{
    //注册cell类型及复用标识
    [self.tableView registerNib:[UINib nibWithNibName:@"MainBellTVCell" bundle:nil] forCellReuseIdentifier:@"BellCellId"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefreshData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}
//下拉刷新
- (void)loadRefreshData
{
    
    _index = 0;
    _getDataType = GetTypeHeader;
    self.tableView.mj_footer.state = MJRefreshStateIdle;
    [self getListData];
    
}
//上拉追加
- (void)loadMoreData
{
    _index++;
    _getDataType = GetTypeFooter;
    [self getListData];
    
    
}
- (void)getListData
{
    
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    
    [bodyDic setObject:@(_index) forKey:@"count"];
    [GYPostData GetInfomationWithDic:bodyDic UrlPath:JBellList Handler:^(NSDictionary *jsonDic, NSError * error) {
        [self.tableView.mj_header endRefreshing];
        
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                NSArray *modelArr;
                
                modelArr = [MainBellModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
                
                if (_getDataType == GetTypeHeader) {
                    [_newsArr removeAllObjects];
                    if (modelArr.count < 10) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }else{
                    if (modelArr.count == 0) {
                        _index--;
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [self.tableView.mj_footer endRefreshing];
                    }
                }
                NSMutableArray * arr = [self calculateCellHeightWithArr:modelArr];
                [_newsArr addObjectsFromArray:arr];
                [self.tableView reloadData];
            }
        }else{
            if (_getDataType == GetTypeFooter) {
                _index--;
                [self.tableView.mj_footer endRefreshing];
            }
        }
        
    }];
}

- (NSMutableArray *)calculateCellHeightWithArr:(NSArray *)array
{
    NSMutableArray * calculateArr = [[NSMutableArray alloc]init];
    for (MainBellModel * model in array) {

        model.cellHeight = [GYToolKit HTMLLHWithSpace:5 size:16 width:SCREEN_WIDTH - 84 str:model.content] + 64;

        [calculateArr addObject:model];
        
    }
    return calculateArr;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return _newsArr.count;
}

//设定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainBellModel * model = _newsArr[indexPath.row];
    return model.cellHeight;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MainBellTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BellCellId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MainBellModel * model = _newsArr[indexPath.row];
    
    cell.bellModel = model;
    
    [cell updateWithModel];
    return cell;

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
