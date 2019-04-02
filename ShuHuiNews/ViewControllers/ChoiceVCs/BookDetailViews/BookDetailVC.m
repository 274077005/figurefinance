//
//  BookDetailVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/24.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BookDetailVC.h"

@interface BookDetailVC ()

@end

@implementation BookDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"书籍详情";
    [self createTableView];
    [self setUpTableView];
    [self getBookDetail];
    [self.view bringSubviewToFront:self.byBtnBV];
    // Do any additional setup after loading the view.
}
- (void)getBookDetail
{
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setObject:self.bookId forKey:@"book_id"];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JBookDetail Handler:^(NSDictionary *jsonDic, NSError * error) {
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                self.detailModel = [BookDetailModel mj_objectWithKeyValues:jsonDic[@"data"]];

                [self.tableView reloadData];
            }
        }
    }];
}
- (IBAction)buyBtnClick:(UIButton *)sender {
    if (![UserInfo share].isLogin) {
        [GYToolKit pushLoginVC];
        return;
    }
    if (self.detailModel.theId.length < 1) {
        return;
    }
    SubmitOrderVC * orderVC = [[SubmitOrderVC alloc]init];
    orderVC.moreListToHere = self.moreListToHere;
    orderVC.bookId = self.detailModel.theId;
    [self.navigationController pushViewController:orderVC animated:YES];
}
- (void)setUpTableView
{
    self.tableView.frame = CGRectMake(0, TopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - TopHeight - 50);
    self.tableView.backgroundColor = [UIColor whiteColor];
    //注册cell类型及复用标识
    [self.tableView registerNib:[UINib nibWithNibName:@"BookBannerTVCell" bundle:nil] forCellReuseIdentifier:@"BannerCellId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BookInfoTVCell" bundle:nil] forCellReuseIdentifier:@"InfoCellId"];
    [self.view addSubview:self.tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.detailModel.name.length < 1) {
        return 0;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}

//设定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 360;
    }else{
        CGFloat cellHeight = [GYToolKit AttribLHWithSpace:5 size:14 width:SCREEN_WIDTH - 60 str:self.detailModel.content];
        
        return cellHeight + 20;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BookBannerTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BannerCellId" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailModel = self.detailModel;
        [cell updateWithModel];
        return cell;
    }else{
        BookInfoTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCellId" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_detailModel.content];
        NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5.0];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_detailModel.content length])];
        cell.contentLab.attributedText = attributedString;
        return cell;
    }

}

@end
