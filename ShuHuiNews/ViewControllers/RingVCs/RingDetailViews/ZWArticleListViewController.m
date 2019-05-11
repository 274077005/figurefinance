//
//  ZWArticleListViewController.m
//  ShuHuiNews
//
//  Created by zhaowei on 2019/5/7.
//  Copyright © 2019 耿一. All rights reserved.
//

#import "ZWArticleListViewController.h"
#import "HomeNormalTVCell.h"

@interface ZWArticleListViewController ()

@end

@implementation ZWArticleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"文章快讯";
    
    [self createTableView];
    NSLog(@"%ld",_articleList.count);
    
    [self setUpTableView];
    
}
- (void)didTapBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createTableView
{
    self.tableView = [[UITableView alloc]init];
    CGRect tableFrame = CGRectMake(0, TopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - TopHeight - TabBarHeight);
    if (self.hidesBottomBarWhenPushed == YES) {
        tableFrame.size.height = tableFrame.size.height + TabBarHeight;
    }
    
    self.tableView.frame = tableFrame;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = WD_BACKCOLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    [self.view addSubview:self.tableView];
    
    //UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    
    
    // [self.tableView addGestureRecognizer:singleTap];
    
}
- (void)createBlackNavStyle
{
    [self.navigationController.navigationBar setBackgroundImage:[GYToolKit createImageWithColor:RGBCOLOR(50, 50, 50)] forBarMetrics:UIBarMetricsDefault];
    
    UIColor *color = [UIColor whiteColor];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    UIImage *backButtonImage = [UIImage imageNamed:@"whiteNavGoBack"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[backButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(didTapBackButton)];
}


- (void)setUpTableView
{
    
    //注册cell类型及复用标识
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeNormalTVCell" bundle:nil] forCellReuseIdentifier:@"articlesId"];
    //self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefreshData)];
    //self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    //self.tableView.mj_footer.hidden = YES;
}

- (void)loadRefreshData{
    [self.tableView.mj_header endRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _articleList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeNormalTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"articlesId" forIndexPath:indexPath];
    HomeNewsModel *newsModel = _articleList[indexPath.row];
    cell.newsModel = newsModel;
    [cell updateWithModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeNewsModel *newsModel = _articleList[indexPath.row];
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
