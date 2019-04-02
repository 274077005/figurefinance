//
//  QADetailVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/15.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "QADetailVC.h"
#import "QADetailHeaderV.h"
@interface QADetailVC ()
{
    QADetailHeaderV * _headerV;
}

@end

@implementation QADetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    [self setUpTableView];
    [self createHeaderView];
    
    [self getQADetailData];
    self.navigationItem.title = @"问题详情";
    
    WeakSelf;
    self.commentV.submitBlock = ^(NSString *commentStr) {
        weakSelf.commentStr = commentStr;
        [weakSelf commentToQA];
    };
    
    
    UITapGestureRecognizer * tfBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tfBVClick)];
    [self.tfBV addGestureRecognizer: tfBVTGR];
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)commentToQA
{
    WeakSelf;
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setObject:[UserInfo share].uId forKey:@"uid"];
    [bodyDic setObject:_QAId forKey:@"delivery_id"];
    [bodyDic setObject:_commentStr forKey:@"contents"];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JQADoAnswer Handler:^(NSDictionary * jsonMessage, NSError *error){
        if (!error) {
            if ([jsonMessage[@"code"]integerValue] == 1) {
                [weakSelf getQADetailData];
            }else{
                [SVProgressHUD showWithString:jsonMessage[@"msg"]];
            }
        }
        
    }];
}
- (IBAction)shareBtnClick:(UIButton *)sender {
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"appIcon"]];
    [shareParams SSDKSetupShareParamsByText:@"  "
                                     images:imageArray
                                        url:IMG_URL(_QAModel.share_link)
                                      title:_QAModel.question
                                       type:SSDKContentTypeWebPage];
    [GYToolKit shareSDKToShare:shareParams];
}
- (void)tfBVClick
{
    //    [self commentToWeb];
    
    if (![UserInfo share].isLogin) {
        [GYToolKit pushLoginVC];
        return;
    }
    self.commentV.holdLab.text = @"有何见解，展开聊聊~";
    
    [DialogView showWithPop:self.commentV];
}
- (IBAction)collectBtnClick:(UIButton *)sender {
    
//    return;
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    
    [bodyDic setObject:@"3" forKey:@"data_type"];
    [bodyDic setObject:[UserInfo share].uId forKey:@"uid"];
    [bodyDic setObject:_QAId forKey:@"id"];
    if ([_QAModel.isCollect isEqualToString:@"1"]) {
        [bodyDic setObject:@"1" forKey:@"status"];
    }else{
        [bodyDic setObject:@"2" forKey:@"status"];
    }
    
    [GYPostData GetInfomationWithDic:bodyDic UrlPath:JCollectWork Handler:^(NSDictionary * jsonMessage, NSError *error){
        if ([jsonMessage[@"code"] integerValue] == 1) {
            
            if ([_QAModel.isCollect isEqualToString:@"1"]) {
                _QAModel.isCollect = @"0";
            }else{
                _QAModel.isCollect = @"1";
            }
            
            if ([_QAModel.isCollect isEqualToString:@"1"]) {
                [self.collectBtn setImage:IMG_Name(@"isCollect") forState:UIControlStateNormal];
            }else{
                [self.collectBtn setImage:IMG_Name(@"notCollect") forState:UIControlStateNormal];
            }
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
- (void)createHeaderView
{
    _headerV = [[[NSBundle mainBundle] loadNibNamed:@"QADetailHeaderV" owner:nil options:nil] lastObject];
    _headerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/375* 201+50);
    WeakSelf;
    _headerV.submitBlock = ^{
        [weakSelf tfBVClick];
    };
}

- (void)setUpTableView
{
    self.tableView.frame = CGRectMake(0, TopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-TopHeight - 50);
    
    //注册cell类型及复用标识
    [self.tableView registerNib:[UINib nibWithNibName:@"AnswerListTVCell" bundle:nil] forCellReuseIdentifier:@"AnswerCellId"];

}
- (void)getQADetailData
{
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setObject:[UserInfo share].uId forKey:@"uid"];
    [bodyDic setObject:_QAId forKey:@"delivery_id"];

    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JQADetail Handler:^(NSDictionary * jsonMessage, NSError *error){
        if (!error) {
            if ([jsonMessage[@"code"]integerValue] == 1) {
                
                [self setUpContentData:jsonMessage];
            }else{
                [SVProgressHUD showWithString:jsonMessage[@"msg"]];
            }
        }
        
    }];
}
-(void)setUpContentData:(NSDictionary *)jsonDic
{
    self.QAModel = [QAListModel mj_objectWithKeyValues:jsonDic[@"data"]];
    CGFloat headerLH = [GYToolKit NormalLHWithSize:16 width:SCREEN_WIDTH - 30 str:self.QAModel.question];
    
    _headerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, headerLH + 300);
    _headerV.QAModel = self.QAModel;
    [_headerV updateWithModel];
    self.tableView.tableHeaderView = _headerV;

    for (AnswersModel * aModel in self.QAModel.answers) {
        aModel.cellHeight = [GYToolKit AttribLHWithSpace:5.0 size:16 width:SCREEN_WIDTH - 70 str:aModel.eval] + 70;
        
    }
    if ([_QAModel.isCollect isEqualToString:@"1"]) {
        [self.collectBtn setImage:IMG_Name(@"isCollect") forState:UIControlStateNormal];
    }else{
        [self.collectBtn setImage:IMG_Name(@"notCollect") forState:UIControlStateNormal];
    }
    if ([_QAModel.end_time isEqualToString:@"已结束"]) {

        self.tfBV.userInteractionEnabled = NO;
        
    }
    
    [self.tableView reloadData];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.QAModel.answers.count;
}

//设定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnswersModel * aModel = self.QAModel.answers[indexPath.row];
    return aModel.cellHeight;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AnswerListTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnswerCellId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AnswersModel * aModel = self.QAModel.answers[indexPath.row];
    cell.aModel = aModel;
    
    [cell updateWithModel];
    return cell;
    
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
