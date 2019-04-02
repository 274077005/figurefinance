//
//  RingQAVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/14.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "MyQAListVC.h"
#import "MyQCommentVC.h"
#import "CreateQuestionVC.h"
@interface MyQAListVC ()
{
    NSMutableArray * _newsArr;
    GetDataType _getDataType;
    NSInteger _index;
}

@end

@implementation MyQAListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _newsArr = [[NSMutableArray alloc]init];
    self.navigationItem.title = @"我的问答";
    [self createTableView];
    [self setUpTableView];
    
//    [self createQuestionBtn];
    
    
//    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"我的评论" style:UIBarButtonItemStyleDone target:self action:@selector(myQABtnClick)];
//    [self.navigationItem.rightBarButtonItem setTintColor:WD_BLUE];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadRefreshData];
}
- (void)qBtnClick
{
    CreateQuestionVC * questionVC = [[CreateQuestionVC alloc]init];
    [self.navigationController pushViewController:questionVC animated:YES];
}


- (void)setUpTableView
{
    
    //注册cell类型及复用标识
    [self.tableView registerNib:[UINib nibWithNibName:@"QAListTVCell" bundle:nil] forCellReuseIdentifier:@"ListCellId"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefreshData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.hidden = YES;
}
- (UIView *)blankV
{
    if (!_blankV) {
        _blankV =  [[[NSBundle mainBundle] loadNibNamed:@"MyQABlankV" owner:nil options:nil] lastObject];
        _blankV.frame = self.tableView.frame;
        //        [self.contentView addSubview:_recommendV];
        
    }
    return _blankV;
    
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
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JMyQAList Handler:^(NSDictionary *jsonDic, NSError * error) {
        [self.tableView.mj_header endRefreshing];
        self.tableView.mj_footer.hidden = NO;
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                NSArray *modelArr;
                
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
                if (_newsArr.count == 0&& _index ==0) {
                    
                    
                    [self.view addSubview:self.blankV];
                }else{
                    [self.blankV removeFromSuperview];
                }
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
