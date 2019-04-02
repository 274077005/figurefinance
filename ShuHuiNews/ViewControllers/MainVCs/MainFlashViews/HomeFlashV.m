//
//  HomeNewsV.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/9.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "HomeFlashV.h"

@implementation HomeFlashV


{
    NSMutableArray * _newsArr;
    NSMutableArray * _dateArr;
    GetDataType _getDataType;
    NSString * _lastId;
}

- (id)initWithFrame:(CGRect)frame withFrom:(NSString *)from
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"%f",self.height);
        _fromStr = from;
        _lastId = @"0";
        _getDataType = GetTypeHeader;
        _newsArr = [[NSMutableArray alloc]init];
        _dateArr = [[NSMutableArray alloc]init];
        [self createTableView];
        [self setUpTableView];
        [self getListData];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgeLoginStatus) name:@"loginOrQuitSuccess" object:nil];
        
    }
    return self;
}


-(void)judgeLoginStatus
{
    [self loadRefreshData];
}
//下拉刷新
- (void)loadRefreshData
{
    _lastId = @"0";
    _getDataType = GetTypeHeader;
    self.tableView.mj_footer.state = MJRefreshStateIdle;
    [self getListData];
    
}
//上拉追加
- (void)loadMoreData
{
    NSArray * sectionArr = _newsArr.lastObject;
    FlashModel * model = sectionArr.lastObject;
    _lastId = model.theId;
    _getDataType = GetTypeFooter;
    [self getListData];
}
- (void)getListData
{
    
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setObject:_fromStr forKey:@"from"];
    [bodyDic setObject:_lastId forKey:@"lastId"];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JFlashList Handler:^(NSDictionary *jsonDic, NSError * error) {
        [self.tableView.mj_header endRefreshing];
        
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                NSArray *modelArr;

                modelArr = [FlashModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
                
                if (_getDataType == GetTypeHeader) {
                    [_dateArr removeAllObjects];
                    [_newsArr removeAllObjects];
                    [self calculateCellHeightWithArr:modelArr];
                    if (_newsArr.count == 0) {
                        self.tableView.tableFooterView = self.sofaV;
                    }else{
                        self.tableView.tableFooterView = nil;
                        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
                    }
                }else{
                    [self calculateCellHeightWithArr:modelArr];

                    if (modelArr.count == 0) {
                        
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        self.tableView.mj_footer.hidden = NO;
                        [self.tableView.mj_footer endRefreshing];
                    }
                }
                
                
                [self.tableView reloadData];
            }
        }else{
            if (_getDataType == GetTypeFooter) {
                
                [self.tableView.mj_footer endRefreshing];
            }
        }

    }];
}
- (void)calculateCellHeightWithArr:(NSArray *)array
{

    for (FlashModel * model in array) {
        
        if (![UserInfo share].isLogin) {
            model.is_praise = @"2";
        }
        
        NSString * contentStr = model.content;
        CGFloat strHeight = [GYToolKit AttribLHWithSpace:5 size:12 width:SCREEN_WIDTH - 90 str:contentStr];
        if (model.type == 1) {
            model.cellHeight = strHeight + 120;
        }else if (model.type == 3){
            model.cellHeight = strHeight + 145;
        }else{
            model.cellHeight = strHeight + 145 + (SCREEN_WIDTH - 90 - 30)/3 + 10;
        }
        
        
        if (![_dateArr containsObject:model.addtime]) {
            [_dateArr addObject:model.addtime];
            NSMutableArray * lastArr = [[NSMutableArray alloc]init];
            [lastArr addObject:model];
            [_newsArr addObject:lastArr];
        }else{
            NSMutableArray * lastArr = _newsArr.lastObject;
            [lastArr addObject:model];
        }
    }

}
-(UIView *)sofaV
{
    if (!_sofaV) {
        _sofaV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
        _sofaV.backgroundColor = [UIColor whiteColor];
        UIImageView * imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, SCREEN_WIDTH/2)];
        imgV.image = IMG_Name(@"noFlash");
        imgV.center = _sofaV.center;
        [_sofaV addSubview:imgV];
    }
    return _sofaV;
}
-(void)createTableView
{
    self.tableView = [[UITableView alloc]init];
    CGRect tableFrame = self.bounds;
    
    self.tableView.frame = tableFrame;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    [self addSubview:self.tableView];
}
- (void)setUpTableView
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefreshData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.frame = self.bounds;
    //普通快讯
    [self.tableView registerNib:[UINib nibWithNibName:@"FlashNormalTVCell" bundle:nil] forCellReuseIdentifier:@"NormalCellId"];
    //带图的快讯
    [self.tableView registerNib:[UINib nibWithNibName:@"FlashImgsTVCell" bundle:nil] forCellReuseIdentifier:@"ImgsCellId"];
    self.tableView.mj_footer.hidden = YES;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _newsArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSArray * sectionArr = _newsArr[section];
    return sectionArr.count;
}

//设定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FlashModel * model = _newsArr[indexPath.section][indexPath.row];

    return model.cellHeight;

}
//设置每组头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
//设置每组头视图内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray * sectionArr = _newsArr[section];
    FlashModel * model = sectionArr.firstObject;
    UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    titleLab.text = model.addtime;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.backgroundColor = RGBCOLOR(246, 246, 246);
    titleLab.font = [UIFont boldSystemFontOfSize:13];
    titleLab.textColor = RGBCOLOR(31, 31, 31);
    return titleLab;
    
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FlashModel * model = _newsArr[indexPath.section][indexPath.row];
    if (model.type == 1 || model.type == 3) {
        FlashNormalTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCellId" forIndexPath:indexPath];
        //不让cell有选中状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.flashModel = model;
        
        [cell updateWithModel];
        return cell;
    }else{
        FlashImgsTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ImgsCellId" forIndexPath:indexPath];
        //不让cell有选中状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.flashModel = model;
        
        [cell updateWithModel];
        return cell;
    }


}


@end
