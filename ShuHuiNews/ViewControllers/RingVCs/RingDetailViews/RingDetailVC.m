//
//  RingDetailVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/2.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "RingDetailVC.h"

@interface RingDetailVC ()
{
    NSMutableArray * _userMsgArr;
    NSMutableArray * _newsArr;
    NSMutableArray * _worksArr;
}

@end

@implementation RingDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    UIView *backBar = self.navigationController.navigationBar.subviews.firstObject;
    backBar.subviews.firstObject.hidden = YES;//这是那个线
    backBar.subviews.firstObject.alpha = 0.0;
    backBar.subviews.lastObject.alpha = 0.0;
    self.navigationItem.title = @"";
    
    _userMsgArr = [[NSMutableArray alloc]init];
    _newsArr = [[NSMutableArray alloc]init];
    
    
    [self createTableView];
    [self setUpTableView];
    [self getDetailData];

    // Do any additional setup after loading the view.
}

//第一次进来 设置下透明，ios12后 viewDidLoad里设置无效了
- (void)setUpNavigationView
{
    UIView *backBar = self.navigationController.navigationBar.subviews.firstObject;
    backBar.subviews.firstObject.alpha = 0.0;
    backBar.subviews.lastObject.alpha = 0.0;
    self.navigationItem.title = @"";
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    UIView *backBar = self.navigationController.navigationBar.subviews.firstObject;
    backBar.subviews.firstObject.hidden = YES;//这是那个线
}
- (void)getDetailData
{

    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    
    [bodyDic setObject:_writeId forKey:@"auth_id"];

    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JRingDetail Handler:^(NSDictionary *jsonDic, NSError * error) {
        [self.tableView.mj_header endRefreshing];
        
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                [_userMsgArr removeAllObjects];
                NSArray * msgArr = [RingDetailModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"][@"personCenter"]];
                [_userMsgArr addObjectsFromArray:[self getCenterCellHWithArr:msgArr]];
                
                
                [_newsArr removeAllObjects];
               NSArray * modelArr = [HomeNewsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"][@"articleList"]];
                
                NSMutableArray * arr = [self calculateCellHeightWithArr:modelArr];
                
                [_worksArr removeAllObjects];
                NSArray *workArr = [HomeAuthorModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"][@"authorList"]];
                [_worksArr addObjectsFromArray:workArr];
                
                [_newsArr addObjectsFromArray:arr];
                [self.tableView reloadData];
                [self setUpNavigationView];
                
            }
        }else{
            
        }
        
    }];
}
//计算用户数据每个Cell的高度
- (NSMutableArray *)getCenterCellHWithArr:(NSArray *)array
{
    NSMutableArray * calculateArr = [[NSMutableArray alloc]init];
    for (RingDetailModel * model in array) {
        if (model.news_type == 80) {
            model.cellHeight = SCREEN_WIDTH * 300/375;
//            NSDictionary *modelDic = model.mj_keyValues;
            _userModel = [RingUserModel mj_objectWithKeyValues:model];
        }else if (model.news_type == 81){
            model.cellHeight = 90;
        }else if (model.news_type == 82){
            model.cellHeight = 40 * model.relationArr.count+10;
        }else if (model.news_type == 83){
            model.cellHeight = 40 * model.urlArr.count+10;
        }else if (model.news_type == 84){
            model.cellHeight = 75 * model.regulationArr.count + 40;
        }else if (model.news_type == 85){
            CenterEnvironmentModel * arrModel = model.environmentArr.firstObject;
            model.cellHeight = arrModel.content.count * 30+80;
        }else if (model.news_type == 86){
            model.cellHeight = SCREEN_WIDTH * 100/250 + 10;
        }else if (model.news_type == 87){
            CGFloat height = 0.0;
            for (NSInteger i = 0; i < model.commentArr.count; i++) {
                RDCommentModel * cModel = model.commentArr[i];
                NSString * commentStr;
                if (cModel.replyName.length > 0) {
                    commentStr = [NSString stringWithFormat:@"回复 :%@ %@ ",cModel.replyName,cModel.comment];
                }else{
                    commentStr = cModel.comment;
                }
                CGFloat strH = [GYToolKit AttribLHWithSpace:5 size:16 width:SCREEN_WIDTH - 67 str:commentStr];
                cModel.cellHeight = strH + 55;
                height = height + strH + 55;
            }
            model.cellHeight = height;
            //如果需要显示更多评论
            if (model.commentArr.count > 1) {
                model.cellHeight = height + 100;
            }else{
                model.cellHeight = height + 75;
            }
            //如果没有评论
            if (model.commentArr.count == 0) {
                model.cellHeight = 250;
            }
        }else if (model.news_type == 88){
            model.cellHeight = 90;
        }else if (model.news_type == 89){
            NSString * contentStr = model.desc;
            CGFloat strHeight = [GYToolKit AttribLHWithSpace:5 size:12 width:SCREEN_WIDTH - 50 str:contentStr];
            model.cellHeight = strHeight + 60;
        }else if (model.news_type == 90){
            model.cellHeight = SCREEN_WIDTH * 315/375;
            _userModel = [RingUserModel mj_objectWithKeyValues:model];
        }else if (model.news_type == 91){
            model.cellHeight = 160;

        }else{
            model.cellHeight = 100;
        }
        [calculateArr addObject:model];
        
    }
    return calculateArr;
}
//计算文章每个cell的高度
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
- (void)setUpTableView
{
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    //头部
    [self.tableView registerNib:[UINib nibWithNibName:@"RDHeaderTVCell" bundle:nil] forCellReuseIdentifier:@"HeaderCellId"];
    
    //个人类型头部
    [self.tableView registerNib:[UINib nibWithNibName:@"RDPersonalHeaderTVCell" bundle:nil] forCellReuseIdentifier:@"PersonalHeaderCellId"];
    //个人类型基本信息
    [self.tableView registerNib:[UINib nibWithNibName:@"RDPersonalBasicTVCell" bundle:nil] forCellReuseIdentifier:@"PersonalBasicCellId"];
    
    
    //评分模块
    [self.tableView registerNib:[UINib nibWithNibName:@"RDGradeTVCell" bundle:nil] forCellReuseIdentifier:@"GradeCellId"];
    
    //简介模块
    [self.tableView registerNib:[UINib nibWithNibName:@"RDIntroduceTVCell" bundle:nil] forCellReuseIdentifier:@"IntroduceCellId"];
    
    
    //联系方式模块
    [self.tableView registerNib:[UINib nibWithNibName:@"RDRelationTVCell" bundle:nil] forCellReuseIdentifier:@"RelationCellId"];
    
    //网址模块
    [self.tableView registerNib:[UINib nibWithNibName:@"RDURLTVCell" bundle:nil] forCellReuseIdentifier:@"URLCellId"];
    
    //监管信息
    [self.tableView registerNib:[UINib nibWithNibName:@"RDRegulationTVCell" bundle:nil] forCellReuseIdentifier:@"RegulationCellId"];

    //交易环境
    [self.tableView registerNib:[UINib nibWithNibName:@"RDEnvironmentTVCell" bundle:nil] forCellReuseIdentifier:@"EnvironmentCellId"];
    
    //标签
    [self.tableView registerNib:[UINib nibWithNibName:@"RDTagInfoTVCell" bundle:nil] forCellReuseIdentifier:@"TagCellId"];
    
    //广告
    [self.tableView registerNib:[UINib nibWithNibName:@"RDAdvertTVCell" bundle:nil] forCellReuseIdentifier:@"AdvertCellId"];
    
    //评论
    [self.tableView registerNib:[UINib nibWithNibName:@"RDCommentTVCell" bundle:nil] forCellReuseIdentifier:@"CommentCellId"];
    
    
    //以下是文章的各个Cell
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RDWorksCell" bundle:nil] forCellReuseIdentifier:@"HomeWorksCellId"];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_userMsgArr.count == 0) {
        return 0;
    }
    if (section == 0) {
        
        return _userMsgArr.count;
    }else if(section == 1){
        //return _newsArr.count;
        if (_newsArr.count>3) {
            return 3;
        }else{
            return _newsArr.count;
        }
    }else{
        return _worksArr.count;
    }

}

//设定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        RingDetailModel * detailModel = _userMsgArr[indexPath.row];
//        NSLog(@"%f",detailModel.cellHeight);
        return detailModel.cellHeight;
    }else{
        HomeNewsModel *newsModel = _newsArr[indexPath.row];
        return newsModel.cellHeight;
    }
    
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        RingDetailModel * detailModel = _userMsgArr[indexPath.row];
        if (detailModel.news_type == 80) {
            RDHeaderTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCellId" forIndexPath:indexPath];
            //不让cell有选中状态
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.deModel = detailModel;
            cell.userModel = _userModel;
            [cell updateWithModel];
            return cell;
        }else if (detailModel.news_type == 81) {
            RDGradeTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GradeCellId" forIndexPath:indexPath];
            //不让cell有选中状态
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.deModel = detailModel;
            [cell updateWithModel];
            return cell;
        }else if (detailModel.news_type == 82) {
            RDRelationTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RelationCellId" forIndexPath:indexPath];
            //不让cell有选中状态
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.deModel = detailModel;
            [cell updateWithModel];
            return cell;
        }else if (detailModel.news_type == 83) {
            RDURLTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"URLCellId" forIndexPath:indexPath];
            //不让cell有选中状态
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.deModel = detailModel;
            [cell updateWithModel];
            return cell;
        }else if (detailModel.news_type == 84) {
            RDRegulationTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RegulationCellId" forIndexPath:indexPath];
            //不让cell有选中状态
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.deModel = detailModel;
            [cell updateWithModel];
            return cell;
        }else if (detailModel.news_type == 85) {
            RDEnvironmentTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EnvironmentCellId" forIndexPath:indexPath];
            //不让cell有选中状态
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.centerModel = detailModel;
            [cell updateWithModel];
            return cell;
        }else if (detailModel.news_type == 86) {
            RDAdvertTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AdvertCellId" forIndexPath:indexPath];
            //不让cell有选中状态
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.deModel = detailModel;
            [cell updateWithModel];
            return cell;
        }else if (detailModel.news_type == 87) {
            RDCommentTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCellId" forIndexPath:indexPath];
            //不让cell有选中状态
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            WeakSelf;
            cell.commentBlock = ^{
                [weakSelf getDetailData];
            };
            cell.deModel = detailModel;
            cell.companyId = _writeId;
            
            cell.articleList = _newsArr;
            
            [cell updateWithModel];
            return cell;
        }else if (detailModel.news_type == 88){
            RDTagInfoTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TagCellId" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.attModel = detailModel;
            [cell updateWithModel];
            return cell;
        }else if (detailModel.news_type == 89){
            RDIntroduceTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IntroduceCellId" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.deModel = detailModel;
            [cell updateWithModel];
            return cell;
        }else if (detailModel.news_type == 90){
            RDPersonalHeaderTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalHeaderCellId" forIndexPath:indexPath];
            //不让cell有选中状态
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.deModel = detailModel;
            cell.userModel = _userModel;
            [cell updateWithModel];
            return cell;
        }else if (detailModel.news_type == 91){
            RDPersonalBasicTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalBasicCellId" forIndexPath:indexPath];
            //不让cell有选中状态
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.deModel = detailModel;
            [cell updateWithModel];
            return cell;
        }else{
            RDRelationTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RelationCellId" forIndexPath:indexPath];
            //不让cell有选中状态
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.deModel = detailModel;
            [cell updateWithModel];
            return cell;
        }
    }
    
    //添加作品
    if (indexPath.section==2) {
         HomeAuthorModel *worksModel = _worksArr[indexPath.row];
        RDWorksCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeWorksCellId" forIndexPath:indexPath];
        cell.worksModel = worksModel;
        return cell;
    }
   
    
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
    
    if (indexPath.section == 0) {
        
    }else{
        HomeNewsModel *newsModel = _newsArr[indexPath.row];
        if (newsModel.news_type == 21) {
            SpecialDetailVC * detailVC = [[SpecialDetailVC alloc]init];
            
            detailVC.specialId = newsModel.theId;
            [self.navigationController pushViewController:detailVC animated:YES];
        }else if (newsModel.news_type == 2) {
            BaseWebVC * detailVC = [[BaseWebVC alloc]init];
            
            detailVC.urlStr = newsModel.href_url;
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }else if (newsModel.news_type == 4) {
            VideoDetailVC * detailVC = [[VideoDetailVC alloc]init];
            detailVC.theId = newsModel.theId;
            detailVC.vGetUrl = newsModel.href_url;
            [self.navigationController pushViewController:detailVC animated:YES];
        }else if (newsModel.news_type == 25) {
            QADetailVC * detailVC = [[QADetailVC alloc]init];
            detailVC.QAId = newsModel.theId;
            [self.navigationController pushViewController:detailVC animated:YES];
        }else if(newsModel.news_type == 6 ||newsModel.news_type == 1){
            CommentWebVC * webVC = [[CommentWebVC alloc]init];
            if ([UserInfo share].isLogin) {
                webVC.urlStr = [NSString stringWithFormat:@"%@&uid=%@",newsModel.href_url,[UserInfo share].uId];
            }else{
                webVC.urlStr = newsModel.href_url;
            }
            [self.navigationController pushViewController:webVC animated:YES];
        }else if(newsModel.news_type == 99){
            BaseWebVC * webVC = [[BaseWebVC alloc]init];
            
            webVC.urlStr = newsModel.href_url;
            
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.y > SCREEN_WIDTH * 187/375) {
        [UIView animateWithDuration:0.5 animations:^{
            UIView *backBar = self.navigationController.navigationBar.subviews.firstObject;
            backBar.subviews.firstObject.alpha = 1.0;
            backBar.subviews.lastObject.alpha = 1.0;
            self.navigationItem.title = _userModel.nickname;
        } completion:^(BOOL finished) {
            
        }];
        
        
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            UIView *backBar = self.navigationController.navigationBar.subviews.firstObject;
            backBar.subviews.firstObject.alpha = 0.0;
            backBar.subviews.lastObject.alpha = 0.0;
            self.navigationItem.title = @"";
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_userMsgArr.count&&section == 2) {
        //作品列表
        ZWWorksHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"ZWWorksHeaderView" owner:nil options:nil].lastObject;
        headerView.worksList = _worksArr;
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==2) {
        return 60;
    }
    return 0;
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
