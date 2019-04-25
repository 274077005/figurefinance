//
//  MyBuyViewController.m
//  ShuHuiNews
//
//  Created by ding on 2019/4/3.
//  Copyright © 2019年 耿一. All rights reserved.
//

#import "MyBuyViewController.h"
#import "MediaItemMyBuyModel.h"
#import "MediaItemCell.h"
@interface MyBuyViewController ()
{
    NSMutableArray *_listAry;
    GetDataType _getDataType;
    NSInteger _index;
    
}
@end

@implementation MyBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self createTableView];
    [self setUpTableView];
    //    [self loadRefreshData];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-40);
}
-(void)initData{
    _listAry = [[NSMutableArray alloc] init];
    //测试用的
    for (int i=0; i<3; i++) {
         MediaItemMyBuyModel *model = [[MediaItemMyBuyModel alloc] init];
        [_listAry addObject:model];
    }
}
- (void)setUpTableView
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefreshData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadRefreshData)];
    self.tableView.mj_footer.hidden = YES;
}
//下拉刷新
- (void)loadRefreshData
{
    _index = 0;
    _getDataType = GetTypeHeader;
    self.tableView.mj_footer.state = MJRefreshStateIdle;
    [self getReadListDetail];
}
- (void)getReadListDetail
{
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    [bodyDic setObject:@(_index) forKey:@"count"];
    [bodyDic setObject:@([[UserInfo share].uId integerValue]) forKey:@"uid"];
    //状态 2是取消订阅 1是订阅 0是默认
    [bodyDic setObject:@(10) forKey:@"num"];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JMyPayBuyListUrl Handler:^(NSDictionary*jsonMessage, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        self.tableView.mj_footer.hidden = NO;
        if(!error){
            if ([jsonMessage[@"code"] integerValue]==1) {
                NSArray *modelArr;
                modelArr = [MediaItemModel mj_objectArrayWithKeyValuesArray:jsonMessage[@"data"]];
                if (_getDataType == GetTypeHeader) {
                    [_listAry removeAllObjects];
                    if (modelArr.count < 10) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }else{
                    if(modelArr.count == 0){
                        _index--;
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [self.tableView.mj_footer endRefreshing];
                    }
                }
                [_listAry addObjectsFromArray:modelArr];
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
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const cid = @"MyReadCid";
    MediaItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cid];
    if (!cell) {
        cell = [[MediaItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    }
    MediaItemMyBuyModel *data = _listAry[indexPath.row];
    cell.buyModel = data;
    cell.cancelButtonClickedBlock = ^{
        [self cancelReadWith:data index:indexPath];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
//继续阅读
- (void)cancelReadWith:(MediaItemMyBuyModel *)model index:(NSIndexPath*)indexpath
{
   
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
