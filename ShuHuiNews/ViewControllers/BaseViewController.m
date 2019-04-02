//
//  BaseViewController.m
//  Qianyuandai
//
//  Created by 耿一 on 2017/10/18.
//  Copyright © 2017年 耿一. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WD_BACKCOLOR;
//    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    UIImage *backButtonImage = [UIImage imageNamed:@"navGoBack"];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[backButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(didTapBackButton)];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    NSLog(@"%@",NSStringFromClass([self class]));
    [SVProgressHUD dismiss];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    
    
    [self.tableView addGestureRecognizer:singleTap];
    
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
- (void)postDataSucceed
{
   
    [self performSelector:@selector(navGoBack) withObject:self afterDelay:2];
    
}
-(void)navGoBack
{
     [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 0;
}

//设定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@""];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (void)dealloc
{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view endEditing:YES];

}


//点击屏幕任意一处取消键盘的第一响应项
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
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
