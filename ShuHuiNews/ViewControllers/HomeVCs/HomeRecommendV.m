//
//  HomeRecommendV.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/9.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "HomeRecommendV.h"

@implementation HomeRecommendV
{
    NSMutableArray * _newsArr;
    GetDataType _getDataType;
    NSInteger _index;
}
//重写init方法
- (id)initWithFrame:(CGRect)frame withId:(NSString *)theId
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"%f",self.height);
        self.theId = theId;
        _getDataType = GetTypeHeader;
        _newsArr = [[NSMutableArray alloc]init];
        [self createTableView];
        [self setUpTableView];
        //如果是推荐页面 则先初始化下显示
        if ([_theId isEqualToString:@"-2"]) {
            NSDictionary * jsonDic = [UserDefaults dictionaryForKey:@"HomeRecommendDic"];
            self.bannerV.dataArr = jsonDic[@"data"][@"banner"];
            [self.bannerV setUpBannerV];
            self.tableView.tableHeaderView = self.bannerV;
            NSArray * modelArr = [HomeNewsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"][@"news"]];
            NSMutableArray * arr = [self calculateCellHeightWithArr:modelArr];
            [_newsArr removeAllObjects];
            [_newsArr addObjectsFromArray:arr];
            [self.tableView reloadData];
        }
        [self getListData];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRefreshData) name:@"loginOrQuitSuccess" object:nil];
    }
    return self;
}
//重写init方法
- (id)initWithFrame:(CGRect)frame withType:(NSInteger)comeType valueStr:(NSString *)valueStr
{
    self = [super initWithFrame:frame];
    if (self) {
        _getDataType = GetTypeHeader;
        _newsArr = [[NSMutableArray alloc]init];
        [self createTableView];
        [self setUpTableView];
        switch (comeType) {
            case 0:
                _searchToHere = YES;
                _searchStr = valueStr;
                break;
            case 1:
                _specailToHere = YES;
                _specailId = valueStr;
                break;
            case 2:
                _collectToHere = YES;
                break;
            case 3:
                _workToHere = YES;
                break;
            case 4:
                _columnToHere = YES;
                break;
            case 5:
                _ringToHere = YES;
                NSArray * ringArr = [valueStr componentsSeparatedByString:@"|"];
                _ringTypeId = ringArr.firstObject;
                _industryId = ringArr.lastObject;
                break;
        }
        
        [self getListData];
    }
    return self;
}
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    

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
    NSString * urlStr;
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    if (_searchToHere) {
        [bodyDic setObject:_searchStr forKey:@"keyword"];
        urlStr = JSearchkey;
    }else if(_specailToHere){
        
        [bodyDic setObject:_specailId forKey:@"id"];
        urlStr = JSpecialDetail;
    }else if(_choiceToHere){
        
        [bodyDic setObject:_choiceId forKey:@"oral_id"];
        urlStr = JChoiceDetail;
    }else if(_workToHere){
        
        urlStr = JMainWorkList;
    }else if(_collectToHere){
        
        urlStr = JCollectList;
    }else if(_columnToHere){
        
        urlStr = JColumnList;
    }else if(_ringToHere){
        [bodyDic setObject:_ringTypeId forKey:@"type"];
        [bodyDic setObject:_industryId forKey:@"industry"];
        urlStr = JRingWriteList;
    }else{
        [bodyDic setObject:_theId forKey:@"id"];
        [bodyDic setObject:@"v4" forKey:@"version"];
        urlStr = JNewsList;
    }
    [bodyDic setObject:@(_index) forKey:@"count"];
    [GYPostData GetInfomationWithDic:bodyDic UrlPath:urlStr Handler:^(NSDictionary *jsonDic, NSError * error) {
        [self.tableView.mj_header endRefreshing];
        
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefreshData)];
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                
                NSArray *modelArr;
                //如果是首页或者专题过来的
                if ([_theId isEqualToString:@"-2"]||_specailToHere) {
                    //如果是首页的
                    if (_getDataType == GetTypeHeader&&[_theId isEqualToString:@"-2"]) {
                        self.bannerV.dataArr = jsonDic[@"data"][@"banner"];
                        [self.bannerV setUpBannerV];
                        self.tableView.tableHeaderView = self.bannerV;
                    }
                    if (_getDataType == GetTypeHeader&&_specailToHere) {
                        self.specialHV.contentDic = jsonDic[@"data"][@"special"];
                        [self.specialHV setUpContentView];
                        _titleStr = jsonDic[@"data"][@"special"][@"course_name"];
                        self.tableView.tableHeaderView = self.specialHV;
                    }
                    if (_getDataType == GetTypeHeader) {
                        //如果是推荐的 持久化一下数据
                        if ([_theId isEqualToString:@"-2"]) {
                            [UserDefaults setObject:jsonDic forKey:@"HomeRecommendDic"];
                        }
                        modelArr = [HomeNewsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"][@"news"]];
                    }else{
                        modelArr = [HomeNewsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
                    }
                    
                }else{
                    modelArr = [HomeNewsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
                }
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
                if ([jsonDic[@"code"] integerValue] == 100404) {
                    //                    [SVProgressHUD showWithString:@"请先登录哦~"];
                    return ;
                }
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
    for (HomeNewsModel * model in array) {
        if (model.news_type == 6) {
            model.cellHeight = 75*(SCREEN_WIDTH-30)/345+121;
        }else if (model.news_type == 1){
            model.cellHeight = 75*(SCREEN_WIDTH-30)/345+45;
        }else if (model.news_type == 2){
            model.cellHeight = 114;
        }else if (model.news_type == 4){
            model.cellHeight = 173*(SCREEN_WIDTH-30)/345+80;
        }else if (model.news_type == 21){
            model.cellHeight = 173*(SCREEN_WIDTH-30)/345+107;
        }else if (model.news_type == 22){
            //和普通文章长得一样
            if (model.banner_type == 3) {
                model.cellHeight = 75*(SCREEN_WIDTH-30)/345+45;
            }else{
//                model.cellHeight = 100*(SCREEN_WIDTH-30)/345+20;
                model.cellHeight = 360*(SCREEN_WIDTH-30)/900+30;
            }
            
        }else if (model.news_type == 23){
            model.cellHeight = 190;
        }else if (model.news_type == 26){
            model.cellHeight = 190;
        }else if (model.news_type == 99){
            model.cellHeight = 35;
        }else{
            model.cellHeight = 100;
        }
        [calculateArr addObject:model];
        
    }
    return calculateArr;
}
- (UIView *)bannerV
{
    if (!_bannerV) {
        _bannerV =  [[[NSBundle mainBundle] loadNibNamed:@"HomeBannerV" owner:nil options:nil] lastObject];
        _bannerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 173*(SCREEN_WIDTH - 30)/345+16);
        //        [self.contentView addSubview:_recommendV];
        
    }
    return _bannerV;
    
}
- (UIView *)specialHV
{
    if (!_specialHV) {
        _specialHV =  [[[NSBundle mainBundle] loadNibNamed:@"SpecialHeaderV" owner:nil options:nil] lastObject];
        _specialHV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 187/375);
        //        [self.contentView addSubview:_recommendV];
        
    }
    return _specialHV;
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
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeImgsTVCell" bundle:nil] forCellReuseIdentifier:@"ImgsCellId"];
    //normal
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeNormalTVCell" bundle:nil] forCellReuseIdentifier:@"NormalCellId"];
    //专题
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeSpecialTVCell" bundle:nil] forCellReuseIdentifier:@"SpecialCellId"];
    //专栏
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeColumnTVCell" bundle:nil] forCellReuseIdentifier:@"ColumnCellId"];
    //快讯
    [self.tableView registerNib:[UINib nibWithNibName:@"RecommendFlashTVCell" bundle:nil] forCellReuseIdentifier:@"FlashCellId"];
    //视频
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeVideoTVCell" bundle:nil] forCellReuseIdentifier:@"VideoCellId"];
    //问答
    [self.tableView registerNib:[UINib nibWithNibName:@"QAListTVCell" bundle:nil] forCellReuseIdentifier:@"QACellId"];
    //左右滚动的问答
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeQATVCell" bundle:nil] forCellReuseIdentifier:@"HomeQACellId"];
    //广告
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeAdvertTVCell" bundle:nil] forCellReuseIdentifier:@"HomeAdvertCellId"];
    
    //文字流广告
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeWorldAdvertTVCell" bundle:nil] forCellReuseIdentifier:@"HomeWorldCellId"];
    
    
}

#pragma mark - Table view data source


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_collectToHere) {
        return YES;
    }
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeNewsModel *newsModel = _newsArr[indexPath.row];
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setObject:newsModel.theId forKey:@"id"];
    [SVProgressHUD show];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JRemoveCollect Handler:^(NSDictionary * jsonMessage, NSError *error){
        if ([jsonMessage[@"code"] integerValue] == 1) {
            [SVProgressHUD showWithString:@"删除成功~"];
            [_newsArr removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showWithString:jsonMessage[@"msg"]];
        }
    }];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return _newsArr.count;
}

//设定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeNewsModel *newsModel = _newsArr[indexPath.row];
    
    return newsModel.cellHeight;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeNewsModel *newsModel = _newsArr[indexPath.row];
    if (newsModel.news_type == 6) {
        HomeImgsTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ImgsCellId" forIndexPath:indexPath];
        //不让cell有选中状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.newsModel = newsModel;
        [cell updateWithModel];
        return cell;
    }else if (newsModel.news_type == 1) {
        HomeNormalTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCellId" forIndexPath:indexPath];
        //不让cell有选中状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.newsModel = newsModel;
        cell.advertLab.hidden = YES;
        [cell updateWithModel];
        return cell;
    }else if(newsModel.news_type == 2){
        RecommendFlashTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FlashCellId" forIndexPath:indexPath];
        //不让cell有选中状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.newsModel = newsModel;
        [cell updateWithModel];
        return cell;
    }else if (newsModel.news_type == 4) {
        HomeVideoTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VideoCellId" forIndexPath:indexPath];
        //不让cell有选中状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.newsModel = newsModel;
        [cell updateWithModel];
        return cell;
    }else if(newsModel.news_type == 21){
        HomeSpecialTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SpecialCellId" forIndexPath:indexPath];
        //不让cell有选中状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.newsModel = newsModel;
        [cell updateWithModel];
        return cell;
    }else if(newsModel.news_type == 22){
        if (newsModel.banner_type == 3) {
            HomeNormalTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCellId" forIndexPath:indexPath];
            //不让cell有选中状态
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.newsModel = newsModel;
            cell.advertLab.hidden = NO;
            [cell updateWithModel];
            return cell;
        }
        HomeAdvertTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HomeAdvertCellId" forIndexPath:indexPath];
        //不让cell有选中状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.advertImg sd_setImageWithURL:newsModel.imgurl];
        
        return cell;
    }else if(newsModel.news_type == 23){
        HomeColumnTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ColumnCellId" forIndexPath:indexPath];
        //不让cell有选中状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.newsModel = newsModel;
        [cell updateWithModel];
        return cell;
    }else if(newsModel.news_type == 25){
        QAListTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"QACellId" forIndexPath:indexPath];
        //不让cell有选中状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.newsModel = newsModel;
        [cell updateWithNewsModel];
        return cell;
    }else if(newsModel.news_type == 26){
        HomeQATVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HomeQACellId" forIndexPath:indexPath];
        //不让cell有选中状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.newsModel = newsModel;
        [cell updateWithModel];
        return cell;
    }else if(newsModel.news_type == 99){
        HomeWorldAdvertTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HomeWorldCellId" forIndexPath:indexPath];
        //不让cell有选中状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLab.text = newsModel.title;
        return cell;
    }else{
        RecommendFlashTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FlashCellId" forIndexPath:indexPath];
        //不让cell有选中状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    MainCenterVC * editVC = [[MainCenterVC alloc]init];
//    [self.viewContoller.navigationController pushViewController:editVC animated:YES];
//    return;
    
    
    HomeNewsModel *newsModel = _newsArr[indexPath.row];
    if (newsModel.news_type == 21) {
        SpecialDetailVC * detailVC = [[SpecialDetailVC alloc]init];
        
        detailVC.specialId = newsModel.theId;
        [self.viewContoller.navigationController pushViewController:detailVC animated:YES];
    }else if (newsModel.news_type == 2) {
        BaseWebVC * detailVC = [[BaseWebVC alloc]init];
        
        detailVC.urlStr = newsModel.href_url;
        
        [self.viewController.navigationController pushViewController:detailVC animated:YES];
    }else if (newsModel.news_type == 4) {
        VideoDetailVC * detailVC = [[VideoDetailVC alloc]init];
        detailVC.theId = newsModel.theId;
        detailVC.vGetUrl = newsModel.href_url;
        
        [self.viewContoller.navigationController pushViewController:detailVC animated:YES];
    }else if (newsModel.news_type == 22) {
        BaseWebVC * webVC = [[BaseWebVC alloc]init];
        webVC.urlStr = newsModel.href_url;
        [self.viewContoller.navigationController pushViewController:webVC animated:YES];

    }else if (newsModel.news_type == 25) {
        if (![UserInfo share].isLogin) {
            [GYToolKit pushLoginVC];
            return;
        }
        QADetailVC * detailVC = [[QADetailVC alloc]init];
        detailVC.QAId = newsModel.theId;
        [self.viewContoller.navigationController pushViewController:detailVC animated:YES];
    }else if(newsModel.news_type == 6 ||newsModel.news_type == 1){
        CommentWebVC * webVC = [[CommentWebVC alloc]init];
        if ([UserInfo share].isLogin) {
            webVC.urlStr = [NSString stringWithFormat:@"%@&uid=%@",newsModel.href_url,[UserInfo share].uId];
            
        }else{
            webVC.urlStr = newsModel.href_url;
        }
        
        webVC.noNetContent = newsModel.noNetContent;
        [self.viewController.navigationController pushViewController:webVC animated:YES];
    }else if(newsModel.news_type == 99){
        BaseWebVC * webVC = [[BaseWebVC alloc]init];
        
        webVC.urlStr = newsModel.href_url;
        
        [self.viewController.navigationController pushViewController:webVC animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (!_specailToHere) {
        return;
    }
    if (scrollView.contentOffset.y > SCREEN_WIDTH * 187/375) {
        [UIView animateWithDuration:0.5 animations:^{
            UIView *backBar = self.viewContoller.navigationController.navigationBar.subviews.firstObject;
            backBar.subviews.firstObject.alpha = 1.0;
            backBar.subviews.lastObject.alpha = 1.0;
            self.viewContoller.navigationItem.title = _titleStr;
        } completion:^(BOOL finished) {
            
        }];
        
        
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            UIView *backBar = self.viewContoller.navigationController.navigationBar.subviews.firstObject;
            backBar.subviews.firstObject.alpha = 0.0;
            backBar.subviews.lastObject.alpha = 0.0;
            self.viewContoller.navigationItem.title = @"";
        } completion:^(BOOL finished) {
            
        }];
    }
}

@end
