//
//  ReplyMeV.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/21.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "ReplyMeV.h"
#import "ReplyMeTVCell.h"
@implementation ReplyMeV
{
    NSMutableArray * _newsArr;
    GetDataType _getDataType;
    NSInteger _index;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"%f",self.height);
        
        _getDataType = GetTypeHeader;
        _newsArr = [[NSMutableArray alloc]init];
        [self createTableView];
        [self setUpTableView];
        
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [self getListData];
    
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
    
    NSString * urlStr;
    if ([_replyType isEqualToString:@"commentOther"]) {
        urlStr = JQCommentOther;
    }else{
        urlStr = JReplyMe;
    }

    [bodyDic setObject:@(_index) forKey:@"count"];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:urlStr Handler:^(NSDictionary *jsonDic, NSError * error) {
        [self.tableView.mj_header endRefreshing];

            self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefreshData)];
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                
                NSArray *modelArr;
                modelArr = [ReplyMeModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
                
                NSMutableArray * arr = [self calculateCellHeightWithArr:modelArr];

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
            }else{
                
                [SVProgressHUD showWithString:jsonDic[@"msg"]];
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
    for (ReplyMeModel * model in array) {
        
        CGFloat qHeight = [GYToolKit AttribLHWithSpace:5 size:12 width:SCREEN_WIDTH - 96 str:model.delivery.question];
        
        CGFloat aHeight = [GYToolKit AttribLHWithSpace:5 size:16 width:SCREEN_WIDTH - 86 str:model.eval];
        model.cellHeight = qHeight + aHeight + 96;

        [calculateArr addObject:model];
    }
    return calculateArr;
}

-(void)createTableView
{
    self.tableView = [[UITableView alloc]init];
    CGRect tableFrame = self.bounds;
    
    self.tableView.frame = tableFrame;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = WD_BACKCOLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    [self addSubview:self.tableView];
}
- (void)setUpTableView
{
    
    self.tableView.frame = self.bounds;
    //图文集
    [self.tableView registerNib:[UINib nibWithNibName:@"ReplyMeTVCell" bundle:nil] forCellReuseIdentifier:@"ReplyCellId"];

    
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
    ReplyMeModel * model = _newsArr[indexPath.row];
    
    return model.cellHeight;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ReplyMeTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ReplyCellId" forIndexPath:indexPath];
    //不让cell有选中状态
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.replyType = _replyType;
     ReplyMeModel * model = _newsArr[indexPath.row];
    cell.model = model;
    [cell updateWithModel];
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


@end
