//
//  ZWWorksListViewController.m
//  ShuHuiNews
//
//  Created by zhaowei on 2019/5/7.
//  Copyright © 2019 耿一. All rights reserved.
//

#import "ZWWorksListViewController.h"
#import "RDWorksCell.h"

@interface ZWWorksListViewController ()

@end

@implementation ZWWorksListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"作品列表";
    
    [self createTableView];
    
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
    [self.tableView registerNib:[UINib nibWithNibName:@"RDWorksCell" bundle:nil] forCellReuseIdentifier:@"worksId"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefreshData)];
    //self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    //self.tableView.mj_footer.hidden = YES;
}

- (void)loadRefreshData{
    [self.tableView.mj_header endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _worksList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RDWorksCell *cell = [tableView dequeueReusableCellWithIdentifier:@"worksId" forIndexPath:indexPath];
    HomeAuthorModel *worksModel = _worksList[indexPath.row];
    cell.worksModel = worksModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
@end
