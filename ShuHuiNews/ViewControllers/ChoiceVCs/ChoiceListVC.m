//
//  ChoiceListVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/19.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "ChoiceListVC.h"

@interface ChoiceListVC ()
{
    NSMutableArray * _newsArr;
    GetDataType _getDataType;
    NSInteger _index;
}
@end

@implementation ChoiceListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.titleStr;
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

- (void)setUpTableView
{
    //注册cell类型及复用标识
    [self.tableView registerNib:[UINib nibWithNibName:@"ChoiceTVCell" bundle:nil] forCellReuseIdentifier:@"ChoiceCellId"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefreshData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.hidden = YES;
    [self.view addSubview:self.tableView];
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
    [bodyDic setObject:self.category_id forKey:@"category_id"];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JChoiceList Handler:^(NSDictionary *jsonDic, NSError * error) {
        [self.tableView.mj_header endRefreshing];
        self.tableView.mj_footer.hidden = NO;
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {

                NSArray *modelArr;
                modelArr = [ComListModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
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
    
    return 130;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChoiceTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceCellId" forIndexPath:indexPath];
    //不让cell有选中状态
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ComListModel * model = _newsArr[indexPath.row];
    cell.titleLab.text = model.name;
    cell.publishLab.text = model.publish;
    cell.authorLab.text = [NSString stringWithFormat:@"作者:%@",model.author];
    cell.priceLab.text = [NSString stringWithFormat:@"￥%@",model.price];
    [cell.coverImgV sd_setImageWithURL:model.img];
    
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComListModel * listModel = _newsArr[indexPath.row];
    
    BookDetailVC * bookVC = [[BookDetailVC alloc]init];
    bookVC.moreListToHere = YES;
    bookVC.bookId = listModel.theId;
    [self.navigationController pushViewController:bookVC animated:YES];
    
}


@end
