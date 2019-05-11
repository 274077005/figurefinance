//
//  AudioDetailIntroViewController.m
//  ShuHuiNews
//
//  Created by zhaowei on 2019/4/25.
//  Copyright © 2019 耿一. All rights reserved.
//

#import "AudioDetailIntroViewController.h"
#import "AuthorAutoCell.h"
#import "LableMessageCell.h"
#import "DlgTFView.h"
#import "ZWCommentCell.h"

@interface AudioDetailIntroViewController (){
    NSMutableArray *_labalArr;
}

@end

@implementation AudioDetailIntroViewController

- (void)viewWillAppear:(BOOL)animated{
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self createTableHeaderView];
    
 
    
    //读取数据
    [self readData];
    
    WeakSelf;
    self.commentV.submitBlock = ^(NSString *commentStr) {
        
        weakSelf.commentStr = commentStr;
        [weakSelf comment];
        
    };
    
    //对标签进行重组
    NSDictionary *labalDict = self.dataDict[@"labal"];
    NSMutableArray *labalArr = [NSMutableArray array];
    [labalDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [labalArr addObject:obj];
    }];
    _labalArr = labalArr;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZWCommentCell" bundle:nil] forCellReuseIdentifier:@"rank"];
    
}

- (void)comment{
    //评论
    //获取评论内容---然后添加新的评论在第0个位置----刷新tableView
    //发送评论
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
     NSDictionary *bookDetail = _dataDict[@"bookDetail"];
    [params setObject:bookDetail[@"id"] forKey:@"book_id"];
    [params setObject:_commentStr forKey:@"comment"];
    [GYPostData PostInfomationWithDic:params UrlPath:JMyAddComment Handler:^(NSDictionary *jsonDict, NSError *error) {
        if(!error){
            if([jsonDict[@"code"] integerValue] == 1){
                //评论成功
                [SVProgressHUD showSuccessWithStatus:@"评论成功!"];
                [SVProgressHUD dismissWithDelay:0.7];
            }else{
                [SVProgressHUD showErrorWithStatus:@"评论失败!"];
                [SVProgressHUD dismissWithDelay:0.7];
            }
            
        }
    }];
    //添加
    NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *commentDict = [NSMutableDictionary dictionary];
    [userInfoDict setObject:[UserInfo share].nickName forKey:@"nickname"];
    NSString *imageString = @"https://www.fifin.com/img/default_head.jpg";
    if([UserInfo share].imageUrl != nil){
        imageString =[UserInfo share].imageUrl;
    }
    [userInfoDict setObject:imageString forKey:@"image"];
    
    [commentDict setObject:_commentStr forKey:@"comment"];
    NSString *currentTime = [self getCurrentTime];
    [commentDict setObject:currentTime forKey:@"created_at"];
    [commentDict setObject:@0 forKey:@"hits"];
    [commentDict setObject:@0 forKey:@"is_praise"];
    [commentDict setObject:userInfoDict forKey:@"userInfo"];
    
    NSDictionary *dict = (NSDictionary *)commentDict;
    [_commentsArr insertObject:dict atIndex:0];
    
    [self.tableView reloadData];
    
}

- (NSString *)getCurrentTime{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *dateNow = [NSDate date];
    NSString *currentTime = [dateFormatter stringFromDate:dateNow];
    return currentTime;
}

- (void)readData {
    NSDictionary *dataDict = [UserDefaults objectForKey:@"dataDetail"];
    _dataDict = dataDict;
    NSDictionary *bookDetail = dataDict[@"bookDetail"];
    _nameLb.text = bookDetail[@"name"];
    NSArray *comments = dataDict[@"commentLists"];
    _commentsArr = [NSMutableArray arrayWithArray:comments];
    
}

//- (void)getDataDict:(NSNotification*)data{
//
//    NSDictionary *dataDict = data.userInfo;
//    self.dataDict = dataDict;
//
//    NSDictionary *bookDetailDict = self.dataDict[@"bookDetail"];
//    _nameLb.text = [NSString stringWithFormat:@"%@",bookDetailDict[@"name"]];
//    NSLog(@"获取到了通知")
//    
//}

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
- (void)createTableHeaderView
{
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    tableHeader.backgroundColor = [UIColor whiteColor];
    UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
    _nameLb = nameLb;
    nameLb.textColor = RGBCOLOR(30, 30, 30);
    nameLb.font = kFont_Lable_15;
    [tableHeader addSubview:nameLb];
    nameLb.font = [UIFont boldSystemFontOfSize:15];
    //nameLb.text = @"数汇资讯";
    NSDictionary *bookDetailDict = self.dataDict[@"bookDetail"];
    _nameLb.text = [NSString stringWithFormat:@"%@",bookDetailDict[@"name"]];
    self.tableView.tableHeaderView = tableHeader;
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!self.vcCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        self.vcCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        //到顶通知父视图改变状态
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==3) {
        if(_commentsArr.count > 2){
            return 2;
        }else{
            return _commentsArr.count;
        }
        
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0||indexPath.section==1) {
        static NSString *const cid = @"cid";
        NSDictionary *bookDetailDict = self.dataDict[@"bookDetail"];
        NSDictionary *userInfoDict = bookDetailDict[@"userInfo"];
        AuthorAutoCell *cell = [tableView dequeueReusableCellWithIdentifier:cid];
        if (!cell) {
            cell = [[AuthorAutoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
        }
        if(indexPath.section==0)
        {
            
            [cell setContent:bookDetailDict[@"description"]];
        }else{
            [cell setContent:userInfoDict[@"sign"]];
        }
        return cell;
    }else if(indexPath.section == 2){
        static NSString *const labelCid = @"labelCid";
        LableMessageCell *cell = [tableView  dequeueReusableCellWithIdentifier:labelCid];
        if (!cell) {
            cell =[[LableMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:labelCid];
        }
        cell.labelAry = _labalArr;
        return cell;
    }else{
        ZWCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rank"];
        if (cell==nil) {
            cell = [[ZWCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rank"];
        }
        NSDictionary*dict = _commentsArr[indexPath.row];
        cell.commentDict = dict;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    header.backgroundColor = [UIColor whiteColor];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 20)];
    NSString *text;
    if (section==0) {
        text = @"内容简介";
    }else if(section==1){
        text = @"作者简介";
    }else if (section==2){
        text = @"标签信息";
    }else{
        text = @"精彩评论";
    }
    lb.textColor = RGBCOLOR(30, 30, 30);
    lb.font = [UIFont boldSystemFontOfSize:15];
    lb.text = text;
    [header addSubview:lb];
    if(section==3){
        UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 10, 60, 20)];
        [commentBtn setTitle:@"立即评论" forState:UIControlStateNormal];
        [commentBtn setTitleColor:RGBCOLOR(35, 122, 229) forState:UIControlStateNormal];
        [commentBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [commentBtn addTarget:self action:@selector(quickCommentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:commentBtn];
    }
    return header;
}
- (void)quickCommentBtnClicked:(UIButton *)btn{
    if (![UserInfo share].isLogin) {
        [GYToolKit pushLoginVC];
        return;
    }
    self.commentV.holdLab.text = @"有何见解，展开聊聊~";
    //_comToOther = NO;
    [DialogView showWithPop:self.commentV];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0||indexPath.section==1) {
        CGFloat height = [AuthorAutoCell whc_CellHeightForIndexPath:indexPath tableView:tableView];
        return height;
    }else{
        return 80;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //    [_VC.navigationController pushViewController:[NewSkipViewController new] animated:YES];
    
}


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        dispatch_async(dispatch_get_main_queue(),^{
            //加载完成后接收通知

            
        });
    }
}
@end
