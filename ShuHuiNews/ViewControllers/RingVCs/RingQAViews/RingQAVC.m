//
//  RingQAVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/14.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "RingQAVC.h"
#import "MyQAListVC.h"
@interface RingQAVC ()
{
    NSMutableArray * _newsArr;
    GetDataType _getDataType;
    NSInteger _index;
}

@end

@implementation RingQAVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _newsArr = [[NSMutableArray alloc]init];
    self.navigationItem.title = @"问答列表";
    [self createTableView];
    [self setUpTableView];
    [self loadRefreshData];
    
    // Do any additional setup after loading the view.
}

- (UIView *)bannerV
{
    if (!_bannerV) {
        _bannerV =  [[[NSBundle mainBundle] loadNibNamed:@"QAListHeaderV" owner:nil options:nil] lastObject];
        _bannerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90);
        //        [self.contentView addSubview:_recommendV];
        
    }
    return _bannerV;
    
}
- (void)setUpTableView
{
    
    //注册cell类型及复用标识
    [self.tableView registerNib:[UINib nibWithNibName:@"QAListTVCell" bundle:nil] forCellReuseIdentifier:@"ListCellId"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefreshData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.hidden = YES;
}
//下拉刷新
- (void)loadRefreshData
{
    _index = 0;
    _getDataType = GetTypeHeader;
    self.tableView.mj_footer.state = MJRefreshStateIdle;
    [self getQAListData];

    
}
//上拉追加
- (void)loadMoreData
{
    _index++;
    _getDataType = GetTypeFooter;
    [self getQAListData];
    
    
}
- (void)getQAListData
{
    
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    
    [bodyDic setObject:@(_index) forKey:@"count"];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JQAList Handler:^(NSDictionary *jsonDic, NSError * error) {
        [self.tableView.mj_header endRefreshing];
        self.tableView.mj_footer.hidden = NO;
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                NSArray *modelArr;
                self.tableView.tableHeaderView = self.bannerV;
                modelArr = [QAListModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
                
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

    return 113;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QAListTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCellId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    QAListModel * model = _newsArr[indexPath.row];
    
    cell.listModel = model;
    
    [cell updateWithModel];
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (![UserInfo share].isLogin) {
        [GYToolKit pushLoginVC];
        return;
    }
    
    QADetailVC * detailVC = [[QADetailVC alloc]init];
    QAListModel * model = _newsArr[indexPath.row];
    detailVC.QAId = model.theId;
    
    [self.navigationController pushViewController:detailVC animated:YES];

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
