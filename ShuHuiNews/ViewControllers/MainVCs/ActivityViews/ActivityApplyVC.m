//
//  ActivityApplyVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/5.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "ActivityApplyVC.h"

@interface ActivityApplyVC ()
{
    NSMutableArray * _activityArr;
}

@end

@implementation ActivityApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"活动报名";
    _activityArr = [[NSMutableArray alloc]init];
    
    [self createTableView];
    
    [self setUpTableView];
    [self getListData];
    // Do any additional setup after loading the view.
}

- (void)getListData
{
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JActicityList Handler:^(NSDictionary *jsonDic, NSError * error) {
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                NSArray * dataArr = [ActivityModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
                NSString * imgUrl = jsonDic[@"msg"];
                UIImageView * headerImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH /375*70)];
                [headerImgV sd_setImageWithURL:IMG_URL(imgUrl) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    self.tableView.tableHeaderView = headerImgV;
                }];
                
                [_activityArr addObjectsFromArray:dataArr];
                
                [self.tableView reloadData];
            }
        }
    }];
}

- (void)setUpTableView
{
    //注册cell类型及复用标识
    [self.tableView registerNib:[UINib nibWithNibName:@"ApplyTVCell" bundle:nil] forCellReuseIdentifier:@"ApplyCellId"];
    [self.view addSubview:self.tableView];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return _activityArr.count;
}

//设定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
    
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ApplyTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyCellId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.acModel = _activityArr[indexPath.row];
    [cell updateWithModel];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityModel * acModel = _activityArr[indexPath.row];
    NSString * aesStr= [GYAES encryptUseAES:[UserInfo share].uId key:@"6461772803150152" iv:@"8105547186756005"];
    NSString * shareStr;
    if ([acModel.herf_url containsString:@"?"]) {
        shareStr = [NSString stringWithFormat:@"%@&user_msg=%@",acModel.herf_url,aesStr];
    }else{
        shareStr = [NSString stringWithFormat:@"%@?user_msg=%@",acModel.herf_url,aesStr];
    }
    
    
    BaseWebVC * webVC = [[BaseWebVC alloc]init];
    
    webVC.urlStr = shareStr;
    [self.navigationController pushViewController:webVC animated:YES];
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
