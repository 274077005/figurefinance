//
//  EditRegulationVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/23.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "EditCompanyVC.h"
#import "EditCompanyURLCell.h"
#import "WeDatePicker.h"
@interface EditCompanyVC ()
{
    NSMutableArray * _urlModelArr;
    WeDatePicker * _dayPicker;
}

@end

@implementation EditCompanyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑公司信息";
    self.topHeight.constant = TopHeight;
    
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(submitBtnClick)];
    [self.navigationItem.rightBarButtonItem setTintColor:WD_BLUE];
    
    self.editTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.editTableView registerNib:[UINib nibWithNibName:@"EditCompanyURLCell" bundle:nil] forCellReuseIdentifier:@"URLCellId"];
    
    
    UITapGestureRecognizer * timeBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(timeBVClick)];
    [self.timeBV addGestureRecognizer: timeBVTGR];
    
    [self setUpContentView];
}
-(void)setUpContentView
{
    
    _nameTF.text = _comModel.attestation_name;
    _timeTF.text = _comModel.start_date;
    _countryTF.text = _comModel.company_country;
    _urlModelArr = [[NSMutableArray alloc]initWithArray:_comModel.urls];
    for (NSInteger i = _comModel.urls.count; i<2; i++) {
        TheCompanyModel * model = [[TheCompanyModel alloc]init];
        [_urlModelArr addObject:model];
    }
    [self.editTableView reloadData];
}

-(void)timeBVClick
{
    _dayPicker = [[WeDatePicker alloc]init];
    [_dayPicker showWithBlock:^(NSString * dateStr) {
        
        _timeTF.text = dateStr;
    }];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 80.0f;
    [self.view registerAsDodgeViewForMLInputDodger];
}
-(void)submitBtnClick
{
    if (_nameTF.text.length < 1 || _timeTF.text.length < 1 || _countryTF.text.length < 1) {
        [SVProgressHUD showWithString:@"尚未填写完整哦~"];
        return;
    }
    
    _comModel.attestation_name = _nameTF.text;
    _comModel.start_date = _timeTF.text;
    _comModel.company_country = _countryTF.text;
    
    _comModel.urls = _urlModelArr;
    NSDictionary * modelDic = _comModel.mj_keyValues;
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    
    [bodyDic setObject:modelDic forKey:@"company_info"];
    
    [bodyDic setObject:_timeTF.text forKey:@"start_date"];
    
    [bodyDic setObject:_countryTF.text forKey:@"company_country"];
    [SVProgressHUD show];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JSaveCompanyUrl Handler:^(NSDictionary * jsonMessage, NSError *error){
        
        if (!error) {
            if ([jsonMessage[@"code"] integerValue] == 1) {
                [SVProgressHUD showWithString:@"提交成功~"];
                [self postDataSucceed];
            }else{
                [SVProgressHUD showWithString:jsonMessage[@"msg"]];
            }
        }
        
    }];
}

- (IBAction)addBtnClick:(UIButton *)sender {
    TheCompanyModel * model = [[TheCompanyModel alloc]init];
    [_urlModelArr addObject:model];
    [self.editTableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    return _urlModelArr.count;
}

//设定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditCompanyURLCell * cell = [tableView dequeueReusableCellWithIdentifier:@"URLCellId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delBtn.tag = indexPath.row;
    [cell.delBtn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    TheCompanyModel * companyModel  = _urlModelArr[indexPath.row];
    cell.coModel = companyModel;
    [cell updateWithModel];
    return cell;
    
}
-(void)delBtnClick:(UIButton *)btn
{
    NSLog(@"%ld",btn.tag);
    [_urlModelArr removeObjectAtIndex:btn.tag];
    [self.editTableView reloadData];
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
