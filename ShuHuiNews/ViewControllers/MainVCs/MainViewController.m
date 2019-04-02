//
//  MainViewController.m
//  Finance
//
//  Created by XZ on 2017/8/29.
//  Copyright © 2017年 XZ. All rights reserved.
//

#import "MainViewController.h"
#import "HeadPhotoTVCell.h"
#import "MyWritingTVCell.h"
#import "MainWalletVC.h"

@interface MainViewController ()
{
    
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createTableView];

    
    [self setUpTableView];
    [self initializeData];
    //初始化IPA支付;
    [ApplePay shared];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMainData) name:@"loginOrQuitSuccess" object:nil];
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getMainData];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}
-(void)initializeData
{
    
    NSDictionary * jsonDic = [UserDefaults dictionaryForKey:@"MainDic"];
    self.mainModel = [MainRootModel mj_objectWithKeyValues:jsonDic[@"data"]];
    [self.tableView reloadData];
    
}
- (void)getMainData
{
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    
    [GYPostData GetInfomationWithDic:bodyDic UrlPath:JMainRoot Handler:^(NSDictionary *jsonDic, NSError * error) {
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                
                [UserDefaults setObject:jsonDic forKey:@"MainDic"];
                self.mainModel = [MainRootModel mj_objectWithKeyValues:jsonDic[@"data"]];
                [self.tableView reloadData];
            }
        }
    }];
}

- (void)setUpTableView
{
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TabBarHeight);
    //注册cell类型及复用标识
    [self.tableView registerNib:[UINib nibWithNibName:@"HeadPhotoTVCell" bundle:nil] forCellReuseIdentifier:@"PhotoCellId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyWritingTVCell" bundle:nil] forCellReuseIdentifier:@"WritingCellId"];
//    [self.tableView registerNib:[UINib nibWithNibName:@"InformationTVCell" bundle:nil] forCellReuseIdentifier:@"InfoCellId"];
//    [self.tableView registerNib:[UINib nibWithNibName:@"SetTVCell" bundle:nil] forCellReuseIdentifier:@"SetCellId"];
    [self.view addSubview:self.tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    

    return 2;
}

//设定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 206 + StatusBarHeight;
    }else{
        return 54*7;
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        HeadPhotoTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCellId" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.mainModel = self.mainModel;
        [cell updateWithModel];
        return cell;
    }else{
        MyWritingTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WritingCellId" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

}
//scrollView开始滚动
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    
//    //让头视图失去黏性
//    CGFloat sectionHeaderHeight = 40;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
//    
//    
//}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

