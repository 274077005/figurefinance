//
//  MyReadViewController.m
//  ShuHuiNews
//
//  Created by ding on 2019/4/3.
//  Copyright © 2019年 耿一. All rights reserved.
//

#import "MyReadViewController.h"
#import "MediaItemModel.h"
#import "MediaItemCell.h"
@interface MyReadViewController ()
{
    GetDataType _getDataType;
    NSInteger _index;
}
@property (nonatomic,strong) NSMutableArray *dataAry;

@end

@implementation MyReadViewController

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
    _dataAry = [[NSMutableArray alloc] init];
    //测试用的
    for (int i=0; i<3; i++) {
        MediaItemModel *model = [[MediaItemModel alloc] init];
        [_dataAry addObject:model];
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
    [bodyDic setObject:@(_index) forKey:@"p"];
    [bodyDic setObject:@([[UserInfo share].uId integerValue]) forKey:@"uid"];
    //状态 2是取消订阅 1是订阅 0是默认
    [bodyDic setObject:@(1) forKey:@"status"];
    [bodyDic setObject:@(10) forKey:@"num"];
    
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JMyReadListUrl Handler:^(NSDictionary*jsonMessage, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        self.tableView.mj_footer.hidden = NO;
        if(!error){
            if ([jsonMessage[@"code"] integerValue]==1) {
                NSArray *modelArr;
                modelArr = [MediaItemModel mj_objectArrayWithKeyValuesArray:jsonMessage[@"data"]];
                if (_getDataType == GetTypeHeader) {
                    [_dataAry removeAllObjects];
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
                [_dataAry addObjectsFromArray:modelArr];
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
    return _dataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const cid = @"MyReadCid";
    MediaItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cid];
    if (!cell) {
        cell = [[MediaItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    }
    MediaItemModel *data = self.dataAry[indexPath.row];
    cell.model = data;
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
- (void)cancelReadWith:(MediaItemModel *)model index:(NSIndexPath*)indexpath
{
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    [bodyDic setObject:@(model.book_id) forKey:@"book_id"];
    [bodyDic setObject:@(2) forKey:@"status"];
    [bodyDic setObject:[UserInfo share].uId forKey:@"uid"];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JMyReadStatus Handler:^(NSDictionary*jsonMessage, NSError *error) {
        if ([jsonMessage[@"code"] integerValue] == 1) {
            [_dataAry removeObjectAtIndex:indexpath.row];
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showWithString:jsonMessage[@"msg"]];
        }
    }];
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
