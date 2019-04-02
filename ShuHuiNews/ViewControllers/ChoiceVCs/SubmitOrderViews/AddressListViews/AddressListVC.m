//
//  AddressListVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/26.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "AddressListVC.h"

@interface AddressListVC ()
{
    NSArray * _listArr;
}

@end

@implementation AddressListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择收货地址";
    [self createTableView];
    [self setUpTableView];
     [self.view bringSubviewToFront:self.addBV];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getListDetail];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addBtnClick:(UIButton *)sender {
    AddAddressVC * addVC = [[AddAddressVC alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)getListDetail
{
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setObject:[UserInfo share].uId forKey:@"uid"];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JAddressList Handler:^(NSDictionary *jsonDic, NSError * error) {
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                _listArr = [SAddressModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
                [self.tableView reloadData];
            }else{
                [SVProgressHUD showWithString:jsonDic[@"msg"]];
            }
        }
    }];
}
- (void)setUpTableView
{
    self.tableView.frame = CGRectMake(0, TopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - TopHeight- 60);
    self.tableView.backgroundColor = [UIColor whiteColor];
    //注册cell类型及复用标识
    [self.tableView registerNib:[UINib nibWithNibName:@"AddressListTVCell" bundle:nil] forCellReuseIdentifier:@"ListCellId"];
    [self.view addSubview:self.tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _listArr.count;
}

//设定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 95;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddressListTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCellId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.addModel = _listArr[indexPath.row];
    if ([cell.addModel.theId isEqualToString:self.selectId]) {
        
        cell.imgV.image = IMG_Name(@"lSelect");
    }else{
        cell.imgV.image = IMG_Name(@"lNoSelect");
    }
    [cell updateWithModel];
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SAddressModel * addModel = _listArr[indexPath.row];
    [self.delegate selectAddressWithModel:addModel];
    [self.navigationController popViewControllerAnimated:YES];
    
    
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
