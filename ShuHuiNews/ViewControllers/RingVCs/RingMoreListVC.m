//
//  RingMoreListVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/28.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "RingMoreListVC.h"

@interface RingMoreListVC ()
{
    NSMutableArray * _newsArr;
    GetDataType _getDataType;
    NSInteger _index;
}
@end

@implementation RingMoreListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([_listType isEqualToString:@"1"]) {
        self.navigationItem.title = @"公司列表";
    }else{
        self.navigationItem.title = @"个人列表";
    }
    
    _newsArr = [[NSMutableArray alloc]init];
    [self createTableView];
    [self setUpTableView];
    [self loadRefreshData];

    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
//下拉刷新
- (void)loadRefreshData
{
    
    _index = 1;
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
    if (_statusModel.sCompanyId.length > 0) {
        
        [bodyDic setObject:_statusModel.sCompanyId forKey:@"company_tag"];
    }
    if (_statusModel.sPersonId.length > 0) {
        [bodyDic setObject:_statusModel.sPersonId forKey:@"person_tag"];
    }
    
    [bodyDic setObject:_listType forKey:@"type"];
    
    [bodyDic setObject:@(_index) forKey:@"page"];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JRingMoreList Handler:^(NSDictionary *jsonDic, NSError * error) {
        [self.tableView.mj_header endRefreshing];
        
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                
                NSArray *modelArr;

                modelArr = [RingListModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];

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

                [_newsArr addObjectsFromArray:modelArr];
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

- (void)setUpTableView
{
    //注册cell类型及复用标识
    [self.tableView registerNib:[UINib nibWithNibName:@"RingNormalTVCell" bundle:nil] forCellReuseIdentifier:@"NormalCellId"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefreshData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%ld",_newsArr.count);
    return _newsArr.count;
}

//设定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 72;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RingNormalTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCellId" forIndexPath:indexPath];
    //不让cell有选中状态
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RingListModel * listModel = _newsArr[indexPath.row];
    cell.listModel = listModel;
    [cell updateWithModel];
    
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RingListModel * listModel = _newsArr[indexPath.row];
    RingDetailVC * detailVC = [[RingDetailVC alloc]init];
    detailVC.writeId = listModel.theId;
    [self.navigationController pushViewController:detailVC animated:YES];

    
}

@end
