//
//  RDCommentTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/31.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "RDCommentTVCell.h"
#import "ZWArticleListViewController.h"

@implementation RDCommentTVCell
{
    BOOL _comToOther;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"TheRDComTVCell" bundle:nil] forCellReuseIdentifier:@"TRDCCellId"];
    WeakSelf;
    self.commentV.submitBlock = ^(NSString *commentStr) {
        
        
        weakSelf.commentStr = commentStr;
        [weakSelf commentToCompany];
        
        
    };
    // Initialization code
}
- (IBAction)commentBtnClick:(UIButton *)sender {
    if (![UserInfo share].isLogin) {
        [GYToolKit pushLoginVC];
        return;
    }
    self.commentV.holdLab.text = @"有何见解，展开聊聊~";
    _comToOther = NO;
    [DialogView showWithPop:self.commentV];
}
- (IBAction)moreBtnClick:(UIButton *)sender {
    RDCommentVC * listVC = [[RDCommentVC alloc]init];
    listVC.companyId = _companyId;
    [self.viewContoller.navigationController pushViewController:listVC animated:YES];
}

//更多资讯
- (IBAction)moreArticle:(id)sender {
    
    
}


-(void)updateWithModel
{
    if (self.deModel.commentArr.count == 0) {
        [self.contentView bringSubviewToFront:_noCommentBV];
    }else{
        [self.contentView bringSubviewToFront:_listBV];
    }
    if (self.deModel.commentArr.count > 1) {
        _moreBtn.hidden = NO;
    }else{
        _moreBtn.hidden = YES;
    }
    [self.tableView reloadData];
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
            
            self.commentBlock();
//            [self.tableView reloadData];

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
            self.commentBlock();
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return _deModel.commentArr.count;
}

//设定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RDCommentModel * coModel = _deModel.commentArr[indexPath.row];
    
    return coModel.cellHeight;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TheRDComTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TRDCCellId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.commentModel = _deModel.commentArr[indexPath.row];
    
    [cell updateWithModel];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![UserInfo share].isLogin) {
        [GYToolKit pushLoginVC];
        return;
    }
    RDCommentModel * coModel = _deModel.commentArr[indexPath.row];
    self.chooseCId = coModel.theId;
    [self commentToOtherWithModel:coModel];
}

- (IBAction)clickMoreArticle:(id)sender {
    ZWArticleListViewController *articleController = [[ZWArticleListViewController alloc] init];
    articleController.articleList = _articleList;
    [self.viewContoller.navigationController pushViewController:articleController animated:YES];
    
}
@end
