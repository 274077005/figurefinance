//
//  SpecialListVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/18.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "SpecialListVC.h"

@interface SpecialListVC ()
{
    NSMutableArray * _newsArr;
    GetDataType _getDataType;
    NSInteger _index;
}
@end

@implementation SpecialListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _newsArr = [[NSMutableArray alloc]init];
    self.navigationItem.title = @"专题";
    [self createTableView];
    [self setUpTableView];
    [self loadRefreshData];
    // Do any additional setup after loading the view.
}

- (void)setUpTableView
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefreshData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    //图文集
    [self.tableView registerNib:[UINib nibWithNibName:@"SpecialListTVCell" bundle:nil] forCellReuseIdentifier:@"listCellId"];
    
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
    [GYPostData GetInfomationWithDic:bodyDic UrlPath:JSpecialList Handler:^(NSDictionary *jsonDic, NSError * error) {
        [self.tableView.mj_header endRefreshing];
        
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                
                
                NSArray * arr = [HomeNewsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
                
                if (_getDataType == GetTypeHeader) {
                    [_newsArr removeAllObjects];
                    if (arr.count < 10) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }else{
                    if (arr.count == 0) {
                        _index--;
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [self.tableView.mj_footer endRefreshing];
                    }
                }
                
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
    
    
    return 172*(SCREEN_WIDTH-30)/345+70;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SpecialListTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"listCellId" forIndexPath:indexPath];
    //不让cell有选中状态
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HomeNewsModel * model = _newsArr[indexPath.row];
    [cell.coverImg sd_setImageWithURL:model.imgurl];
    cell.titleLab.text = model.title;
    return cell;
    
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeNewsModel *newsModel = _newsArr[indexPath.row];
    SpecialDetailVC * detailVC = [[SpecialDetailVC alloc]init];
    
    detailVC.specialId = newsModel.theId;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
