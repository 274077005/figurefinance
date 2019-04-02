//
//  RingQAVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/14.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "RDCommentVC.h"
#import "MyQAListVC.h"
@interface RDCommentVC ()
{
    NSMutableArray * _newsArr;
    GetDataType _getDataType;
    NSInteger _index;
}

@end

@implementation RDCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _newsArr = [[NSMutableArray alloc]init];
    self.navigationItem.title = @"全部评论";
    [self createTableView];
    [self setUpTableView];
    [self loadRefreshData];
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"立即评论" style:UIBarButtonItemStyleDone target:self action:@selector(commentBtnClick)];
    [self.navigationItem.rightBarButtonItem setTintColor:WD_BLUE];
    WeakSelf;
    self.commentV.submitBlock = ^(NSString *commentStr) {
        
        
        weakSelf.commentStr = commentStr;
        [weakSelf commentToCompany];
        
        
    };
    // Do any additional setup after loading the view.
}
- (void)commentBtnClick
{
    if (![UserInfo share].isLogin) {
        [GYToolKit pushLoginVC];
        return;
    }
    self.commentV.holdLab.text = @"有何见解，展开聊聊~";
    
    [DialogView showWithPop:self.commentV];
}
- (void)commentToCompany
{
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    NSLog(@"%@",self.commentStr);
    if (_comToOther) {
        [bodyDic setObject:self.chooseCId forKey:@"comment_id"];
    }
    [bodyDic setObject:[UserInfo share].uId forKey:@"uid"];
    [bodyDic setObject:self.commentStr forKey:@"comment"];
    [bodyDic setObject:self.companyId forKey:@"auth_id"];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JSaveCompanyComment Handler:^(NSDictionary * jsonMessage, NSError *error){
        if ([jsonMessage[@"code"] integerValue] == 1) {
            [SVProgressHUD showWithString:@"评论成功~"];
            [self loadRefreshData];
            
        }else{
            [SVProgressHUD showWithString:jsonMessage[@"msg"]];
        }
    }];
}
//评论某个人
- (void)commentToOtherWithModel:(RDCommentModel *)cModel
{
    _comToOther = YES;
    NSString * nameStr = cModel.nickname;
    self.commentV.holdLab.text = [NSString stringWithFormat:@"回复%@:",nameStr];
    if ([cModel.comment_auth isEqualToString:[UserInfo share].uId]) {
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
    
    [bodyDic setObject:self.chooseCId forKey:@"comment_id"];
    [bodyDic setObject:[UserInfo share].uId forKey:@"uid"];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JDelCompanyComment Handler:^(NSDictionary * jsonMessage, NSError *error){
        if ([jsonMessage[@"code"] integerValue] == 1) {
            [SVProgressHUD showWithString:@"删除成功~"];
            [self loadRefreshData];
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
    
    //注册cell类型及复用标识
    [self.tableView registerNib:[UINib nibWithNibName:@"TheRDComTVCell" bundle:nil] forCellReuseIdentifier:@"ListCellId"];
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
    
    [bodyDic setObject:_companyId forKey:@"auth_id"];
    [bodyDic setObject:@(_index) forKey:@"count"];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JCompanyMoreComment Handler:^(NSDictionary *jsonDic, NSError * error) {
        [self.tableView.mj_header endRefreshing];
        self.tableView.mj_footer.hidden = NO;
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                NSArray *modelArr;
                modelArr = [RDCommentModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
                
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
                [self getCellHWithArr:modelArr];
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
//计算用户数据每个Cell的高度
- (NSMutableArray *)getCellHWithArr:(NSArray *)array{
    NSMutableArray * calculateArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < array.count; i++) {
        RDCommentModel * cModel = array[i];
        NSString * commentStr;
        if (cModel.replyName.length > 0) {
            commentStr = [NSString stringWithFormat:@"回复 :%@ %@ ",cModel.replyName,cModel.comment];
        }else{
            commentStr = cModel.comment;
        }
        CGFloat strH = [GYToolKit AttribLHWithSpace:5 size:16 width:SCREEN_WIDTH - 67 str:commentStr];
        cModel.cellHeight = strH + 55;
        [calculateArr addObject:cModel];
    }
    return calculateArr;
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
    RDCommentModel * coModel = _newsArr[indexPath.row];
    return coModel.cellHeight;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TheRDComTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCellId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RDCommentModel * model = _newsArr[indexPath.row];
    
    cell.commentModel = model;
    
    [cell updateWithModel];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![UserInfo share].isLogin) {
        [GYToolKit pushLoginVC];
        return;
    }
    RDCommentModel * coModel = _newsArr[indexPath.row];
    self.chooseCId = coModel.theId;
    [self commentToOtherWithModel:coModel];
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
