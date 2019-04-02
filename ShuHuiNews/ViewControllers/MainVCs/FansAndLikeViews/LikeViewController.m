//
//  FansViewController.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/25.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "LikeViewController.h"

@interface LikeViewController ()
{
    NSMutableArray * _newsArr;
    GetDataType _getDataType;
    NSInteger _index;
}

@end

@implementation LikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关注";
    _newsArr = [[NSMutableArray alloc]init];
    
    [self createTableView];
    [self setUpTableView];
    [self loadRefreshData];
    // Do any additional setup after loading the view.
}

- (void)setUpTableView
{
    
    //注册cell类型及复用标识
    [self.tableView registerNib:[UINib nibWithNibName:@"FansTVCell" bundle:nil] forCellReuseIdentifier:@"FansCellId"];
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
    [GYPostData GetInfomationWithDic:bodyDic UrlPath:JLikeList Handler:^(NSDictionary *jsonDic, NSError * error) {
        [self.tableView.mj_header endRefreshing];
        
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                
                NSArray *modelArr;
                
                modelArr = [FansModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
                
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
    
    return 74;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FansTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FansCellId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FansModel * model = _newsArr[indexPath.row];
    cell.nameLab.text = model.nickname;
    [cell.imgBtn sd_setImageWithURL:model.image forState:UIControlStateNormal];
    
    [cell.controllBtn setTitle:@"已关注" forState:UIControlStateNormal];
    [cell.controllBtn setTintColor:RGBCOLOR(171, 171, 171)];
    cell.controllBtn.layer.borderColor = RGBCOLOR(171, 171, 171).CGColor;
    
    cell.controllBtn.tag = indexPath.row;
    [cell.controllBtn addTarget:self action:@selector(controllerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}
- (void)controllerBtnClick:(UIButton *)btn
{
    FansModel * model = _newsArr[btn.tag];
    
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    
    [bodyDic setObject:model.theId forKey:@"auth_id"];
    
    [bodyDic setObject:@"1" forKey:@"status"];
    
    [GYPostData GetInfomationWithDic:bodyDic UrlPath:JFansSome Handler:^(NSDictionary *jsonDic, NSError * error) {
        
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                [_newsArr removeObjectAtIndex:btn.tag];
                [self.tableView reloadData];
            }
            
        }
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FansModel * model = _newsArr[indexPath.row];
    RingDetailVC * detailVC = [[RingDetailVC alloc]init];
    detailVC.writeId = model.theId;
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
