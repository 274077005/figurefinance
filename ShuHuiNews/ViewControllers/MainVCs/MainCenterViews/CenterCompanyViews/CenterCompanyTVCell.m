//
//  CenterCompanyTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/22.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "CenterCompanyTVCell.h"
#import "EditCompanyVC.h"
@implementation CenterCompanyTVCell
{
    CALayer * _BVLayer;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _BVLayer = [[CALayer alloc] init];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.clipsToBounds = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TheCompanyTVCell" bundle:nil] forCellReuseIdentifier:@"CompanyCellId"];
    // Initialization code
}
- (IBAction)editBtnClick:(UIButton *)sender {
    EditCompanyVC * editVC = [[EditCompanyVC alloc]init];
    editVC.comModel = _centerModel.company_info;
    [self.viewContoller.navigationController pushViewController:editVC animated:YES];
    
}
-(void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    self.contentView.layer.masksToBounds = YES;
    
    _BVLayer.position = _shadowBV.layer.position;
    _BVLayer.frame = _shadowBV.frame;
    _BVLayer.cornerRadius = _shadowBV.layer.cornerRadius;
    _BVLayer.backgroundColor = [UIColor whiteColor].CGColor;
    _BVLayer.shadowColor = [UIColor grayColor].CGColor;
    _BVLayer.shadowOffset = CGSizeMake(2, 2);
    _BVLayer.shadowOpacity = 0.3;
    [self.contentView.layer addSublayer:_BVLayer];
    [self.contentView bringSubviewToFront:_shadowBV];
    
    
}
-(void)updateWithModel
{
    
    CenterCompanyModel * coModel  = _centerModel.company_info;
    self.nameLab.text = coModel.attestation_name;
    self.timeLab.text = coModel.start_date;
    self.countryLab.text = coModel.company_country;
    [self.tableView reloadData];
    [self.contentView layoutIfNeeded];
    [self.contentView layoutSubviews];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    CenterCompanyModel * coModel  = _centerModel.company_info;
    
    return coModel.urls.count;
}

//设定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TheCompanyTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CompanyCellId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CenterCompanyModel * coModel  = _centerModel.company_info;
    cell.coModel = coModel.urls[indexPath.row];
    
    [cell updateWithModel];
    
    return cell;
    
}

@end
