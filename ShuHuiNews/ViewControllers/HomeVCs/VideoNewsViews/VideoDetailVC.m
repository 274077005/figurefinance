//
//  VideoDetailVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/3.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "VideoDetailVC.h"

@interface VideoDetailVC ()
{
    //是不是对某个回复评论
    BOOL  _comToOther;
    NSMutableArray * _commentArr;
}

@end

@implementation VideoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView * statusV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, StatusBarHeight)];
    statusV.backgroundColor = [UIColor blackColor];
    [self.view addSubview:statusV];
    _commentArr = [[NSMutableArray alloc]init];
    CGRect videoFrame = CGRectMake(0, StatusBarHeight, SCREEN_WIDTH, SCREEN_WIDTH/375*213);
    self.player.frame = videoFrame;
    self.player.origianlFrame = videoFrame;
    
    self.player.delegate = self;
    
    self.player.firstSuperView = self.view;
    
    [self.view addSubview:self.player];
    [self createTableView];
    [self setUpTableView];
    [self getVideoDta];
    
    UITapGestureRecognizer * tfBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tfBVClick)];
    [self.tfBV addGestureRecognizer: tfBVTGR];
    
    WeakSelf;
    self.commentV.submitBlock = ^(NSString *commentStr) {
        
        
        weakSelf.commentStr = commentStr;
        [weakSelf commentToVideo];
        
        
    };
    
    
    // Do any additional setup after loading the view.
}
-(void)getVideoDta{
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    NSString * firstUrl = [self.vGetUrl componentsSeparatedByString:Main_Url].lastObject;
    NSString * getUrl = [firstUrl componentsSeparatedByString:@"?id="].firstObject;
    
    NSString * videoId = [[firstUrl componentsSeparatedByString:@"&format"].firstObject componentsSeparatedByString:@"id="].lastObject;
    
    [bodyDic setObject:videoId forKey:@"id"];
    
    [GYPostData GetInfomationWithDic:bodyDic UrlPath:getUrl Handler:^(NSDictionary * jsonMessage, NSError *error){
        if ([jsonMessage[@"code"] integerValue] == 1) {
            self.detailModel = [VideoDetailModel mj_objectWithKeyValues:jsonMessage[@"data"]];
            [_commentArr removeAllObjects];
            [_commentArr addObjectsFromArray:self.detailModel.comment];
            self.player.title =_detailModel.news.title;
            self.player.mediaPath = _detailModel.news.href_url;
            //            VCorrelationModel * cModel = _detailModel.correlation[1];
            //            cModel.title = @"明月几时有，把酒问晴天，不是天上宫阙，今夕是何年,我欲乘风归去";
                //            self.detailModel.news.content = @"明月几时有把酒问青天";
            [self judgeTitleCellStatus];
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showWithString:jsonMessage[@"msg"]];
        }
    }];
}
- (void)tfBVClick
{
    //    [self commentToWeb];
    
    if (![UserInfo share].isLogin) {
        [GYToolKit pushLoginVC];
        return;
    }
    self.commentV.holdLab.text = @"有何见解，展开聊聊~";
    _comToOther = NO;
    [DialogView showWithPop:self.commentV];
}
- (void)commentToVideo
{
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    
    if (_comToOther) {
        [bodyDic setObject:self.chooseCId forKey:@"c_id"];
    }
    [bodyDic setObject:[UserInfo share].uId forKey:@"user_id"];
    [bodyDic setObject:self.commentStr forKey:@"comment_content"];
    [bodyDic setObject:self.theId forKey:@"news_id"];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JAddComment Handler:^(NSDictionary * jsonMessage, NSError *error){
        if ([jsonMessage[@"code"] integerValue] == 1) {
            VCommentModel * cModel = [VCommentModel mj_objectWithKeyValues:jsonMessage[@"data"]];
            [_commentArr insertObject:cModel atIndex:0];
            [self judgeTitleCellStatus];
            [self.tableView reloadData];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }else{
            [SVProgressHUD showWithString:jsonMessage[@"msg"]];
        }
    }];
}
//评论某个人
- (void)commentToOtherWithModel:(VCommentModel *)cModel
{
    _comToOther = YES;
    NSString * nameStr = cModel.nickname;
    self.commentV.holdLab.text = [NSString stringWithFormat:@"回复%@:",nameStr];
    if ([cModel.user_id isEqualToString:[UserInfo share].uId]) {
        WeakSelf;
        self.wayV.submitBlock = ^(NSString *handleStr) {
            if ([handleStr isEqualToString:@"delete"]) {
                _comToOther = NO;
                [weakSelf deleteComment];
            }else{
                [DialogView showWithPop:weakSelf.commentV];
            }
        };
        [DialogView showWithPop:self.wayV];
    }else{
        
        [DialogView showWithPop:self.commentV];
    }
}
//删除自己的评论
-(void)deleteComment
{
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    
    [bodyDic setObject:self.chooseCId forKey:@"c_id"];
    [bodyDic setObject:[UserInfo share].uId forKey:@"uid"];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JDelComment Handler:^(NSDictionary * jsonMessage, NSError *error){
        if ([jsonMessage[@"code"] integerValue] == 1) {
            [_commentArr removeObjectAtIndex:self.chooseIndex];
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showWithString:jsonMessage[@"msg"]];
        }
    }];
}
- (UIView *)commentV
{
    if (!_commentV) {
        _commentV =  [[[NSBundle mainBundle] loadNibNamed:@"DlgCommentV" owner:nil options:nil] lastObject];
        _commentV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.7);
    }
    return _commentV;
    
}
- (UIView *)wayV
{
    if (!_wayV) {
        _wayV =  [[[NSBundle mainBundle] loadNibNamed:@"DlgCommentWayV" owner:nil options:nil] lastObject];
        _wayV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 161.5);
    }
    return _wayV;
    
}

- (void)setUpTableView
{
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.frame = CGRectMake(0, StatusBarHeight + SCREEN_WIDTH/375*213, SCREEN_WIDTH, SCREEN_HEIGHT - StatusBarHeight - SCREEN_WIDTH/375*213 - 50);
    //titleCell
    [self.tableView registerNib:[UINib nibWithNibName:@"VideoTitleTVCell" bundle:nil] forCellReuseIdentifier:@"TitleCellId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CorrelationVideoTVCell" bundle:nil] forCellReuseIdentifier:@"CorrelationCellId"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VideoCommentTVCell" bundle:nil] forCellReuseIdentifier:@"CommentCellId"];
}


-(UIView *)sofaV
{
    if (!_sofaV) {
        _sofaV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
        _sofaV.backgroundColor = [UIColor whiteColor];
        UIImageView * imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        imgV.image = IMG_Name(@"noComment");
        imgV.center = _sofaV.center;
        [_sofaV addSubview:imgV];
    }
    return _sofaV;
}
//判断是不是要显示更多
- (void)judgeTitleCellStatus
{
    NSString * content = _detailModel.news.content;
    
    CGFloat contentHeight = [GYToolKit AttribLHWithSpace:5 size:14 width:SCREEN_WIDTH - 30 str:content];
    _detailModel.news.contentHeight = contentHeight;
    //判断有没有超过一行
    if (contentHeight > 23) {
        _detailModel.news.canShowMore = YES;
    }
    for (VCommentModel * cModel in _commentArr) {
        NSString * commentStr;
        if (cModel.user_f_name.length > 0) {
            commentStr = [NSString stringWithFormat:@"回复 :%@ %@ ",cModel.user_f_name,cModel.comment_content];
        }else{
            commentStr = cModel.comment_content;
        }
        CGFloat strH = [GYToolKit AttribLHWithSpace:5 size:16 width:SCREEN_WIDTH - 67 str:commentStr];
        cModel.strHeight = strH;
    }
    if (_commentArr.count == 0) {
        self.tableView.tableFooterView = self.sofaV;
    }else{
        self.tableView.tableFooterView = nil;
    }
    //处理收藏状态
    NSInteger status = [_detailModel.news.is_collection integerValue];
    if (status == 1) {
        _collectStatus = YES;
        [self.collectBtn setImage:IMG_Name(@"isCollect") forState:UIControlStateNormal];
    }else{
        _collectStatus = NO;
        [self.collectBtn setImage:IMG_Name(@"notCollect") forState:UIControlStateNormal];
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (IBAction)collectBtnClick:(UIButton *)sender {
    if (![UserInfo share].isLogin) {
        [GYToolKit pushLoginVC];
        return;
    }
    
    if (self.detailModel.news.theId.length < 1) {
        return;
    }
    
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    
    [bodyDic setObject:@"1" forKey:@"data_type"];
    [bodyDic setObject:self.detailModel.news.theId forKey:@"id"];
    if (_collectStatus) {
        [bodyDic setObject:@"1" forKey:@"status"];
    }else{
        [bodyDic setObject:@"2" forKey:@"status"];
    }
    
    [GYPostData GetInfomationWithDic:bodyDic UrlPath:JCollectWork Handler:^(NSDictionary * jsonMessage, NSError *error){
        if ([jsonMessage[@"code"] integerValue] == 1) {
            
            _collectStatus = !_collectStatus;
            if (_collectStatus) {
                [self.collectBtn setImage:IMG_Name(@"isCollect") forState:UIControlStateNormal];
            }else{
                [self.collectBtn setImage:IMG_Name(@"notCollect") forState:UIControlStateNormal];
            }
        }else{
            [SVProgressHUD showWithString:jsonMessage[@"msg"]];
        }
    }];
    
}
- (IBAction)shareBtnClick:(UIButton *)sender {
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSMutableArray  * paramArr = [[NSMutableArray alloc]initWithArray:[self.detailModel.link componentsSeparatedByString:@"?"]];
    [paramArr removeLastObject];
    
    NSString * shareStr = [NSString stringWithFormat:@"%@?id=%@&format=view",paramArr.firstObject,self.detailModel.news.theId];
    
    NSString * shareContent;
    if (self.detailModel.news.content.length > 1) {
        shareContent = self.detailModel.news.content;
    }else{
        shareContent = @"数汇资讯-让连接更高效";
        
    }
    NSLog(@"%@",shareStr);
    //    NSArray* imageArray = @[[UIImage imageNamed:@"appIcon"]];
    [shareParams SSDKSetupShareParamsByText:shareContent
                                     images:self.detailModel.share_img
                                        url:IMG_URL(shareStr)
                                      title:self.detailModel.news.title
                                       type:SSDKContentTypeWebPage];
    [GYToolKit shareSDKToShare:shareParams];
    
}



- (XHPlayer *)player{
    if (!_player) {
        _player = [[XHPlayer alloc] init];
    }
    return _player;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.player stop];
}
#pragma mark --XHPlayerDelegate
- (void)playerPlaybackDidOver:(XHPlayer *)player{
    [self.player close];
    [self.player removeNotification];
    self.player = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    //    return UIStatusBarStyleLightContent;
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.detailModel.news.title.length <1) {
        return 0;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    }else{
        return _commentArr.count;
    }
}

//设定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //如果不超过一行
            if (_detailModel.news.content.length < 1 ) {
                return 110;
            }
            if (!_detailModel.news.canShowMore) {
                return 110 + 23 + 25;
            }
            if (_detailModel.news.isShowMore) {
                return 110 + _detailModel.news.contentHeight + 45;
            }else{
                return 110 + 23 + 45;
            }
        }else{
            return SCREEN_WIDTH * 110/375 + 155;
        }
    }else{
        VCommentModel * cModel = _commentArr[indexPath.row];
        return cModel.strHeight + 55;
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            VideoTitleTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCellId" forIndexPath:indexPath];
            //不让cell有选中状态
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.tableView = self.tableView;
            cell.titleModel = _detailModel.news;
            [cell updateWithModel];
            return cell;
        }else{
            CorrelationVideoTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CorrelationCellId" forIndexPath:indexPath];
            //不让cell有选中状态
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            WeakSelf;
            cell.videoBlock = ^(NSString * getUrl) {
                weakSelf.vGetUrl = getUrl;
                [weakSelf getVideoDta];
            };
            cell.detailModel = _detailModel;
            [cell updateWithModel];
            return cell;
        }
    }else{
        VideoCommentTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCellId" forIndexPath:indexPath];
        //不让cell有选中状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.commentModel = _commentArr[indexPath.row];
        [cell updateWithModel];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return;
    }
    if (![UserInfo share].isLogin) {
        [GYToolKit pushLoginVC];
        return;
    }
    VCommentModel * cModel = _commentArr[indexPath.row];
    self.chooseCId = cModel.c_id;
    self.chooseIndex = indexPath.row;
    
    [self commentToOtherWithModel:cModel];
    
    
}

- (void)dealloc{
    [self.player close];
    [self.player removeNotification];
    self.player = nil;
}


@end
