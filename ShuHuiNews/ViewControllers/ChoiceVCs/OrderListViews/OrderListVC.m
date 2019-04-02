//
//  OrderListVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/30.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "OrderListVC.h"

@interface OrderListVC ()
{
    NSMutableArray* _listArr;
    GetDataType _getDataType;
    NSInteger _index;
}
@end

@implementation OrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _listArr = [[NSMutableArray alloc]init];
    self.navigationItem.title = @"我的订单";
    [self createTableView];
    [self setUpTableView];
    
    [self loadRefreshData];
 
    
    UIImage *backButtonImage = [UIImage imageNamed:@"navGoBack"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[backButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backItemClick)];
    // Do any additional setup after loading the view.
}
-(void)backItemClick
{
   
    if (self.moreListToHere) {
        for (UIViewController *controller in self.navigationController.navigationController.viewControllers) {
            
            BaseSystemNVC *jumpNavC = controller.childViewControllers.firstObject;
            
            if ([jumpNavC.viewControllers.firstObject isKindOfClass:[ChoiceListVC class]]) {
                
                [self.navigationController popToViewController:jumpNavC.viewControllers.firstObject animated:YES];
                
            }
            
        }
    }else{
         [self.navigationController popToRootViewControllerAnimated:YES];
    }

}
- (void)setUpTableView
{
    
    //注册cell类型及复用标识
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderListTVCell" bundle:nil] forCellReuseIdentifier:@"ListCellId"];
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
    [self getOrderListDetail];
    
    
}
//上拉追加
- (void)loadMoreData
{
    _index++;
    _getDataType = GetTypeFooter;
    [self getOrderListDetail];
    
    
}
- (void)getOrderListDetail
{
    
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    
    [bodyDic setObject:@(_index) forKey:@"count"];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JOrderList Handler:^(NSDictionary *jsonDic, NSError * error) {
        [self.tableView.mj_header endRefreshing];
        self.tableView.mj_footer.hidden = NO;
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                NSArray *modelArr;
                modelArr = [OrderListModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
                
                if (_getDataType == GetTypeHeader) {
                    [_listArr removeAllObjects];
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
                
                [_listArr addObjectsFromArray:modelArr];
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
    
    
    return _listArr.count;
}

//设定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 216;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderListTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCellId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OrderListModel * model = _listArr[indexPath.row];
    
    cell.listModel = model;
    
    [cell updateWithModel];
    return cell;
    
}
@end
