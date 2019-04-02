//
//  CenterRegulationTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/21.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "CenterRegulationTVCell.h"
#import "EditRegulationVC.h"
@implementation CenterRegulationTVCell{
    CALayer * _BVLayer;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _BVLayer = [[CALayer alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"TheRegulationTVCell" bundle:nil] forCellReuseIdentifier:@"TheRegulationCellId"];

    // Initialization code
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
- (IBAction)editBtnClick:(UIButton *)sender {
    
    EditRegulationVC * editVC = [[EditRegulationVC alloc]init];
    editVC.centerModel = self.centerModel;
    [self.viewContoller.navigationController pushViewController:editVC animated:YES];
}
-(void)updateWithModel
{
    
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.centerModel.regulatory.count;
}

//设定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TheRegulationTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TheRegulationCellId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.regulationModel = self.centerModel.regulatory[indexPath.row];
    
    [cell updateWithModel];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditRegulationVC * editVC = [[EditRegulationVC alloc]init];
    editVC.isEdit = YES;
    editVC.centerModel = self.centerModel;
    editVC.reModel = self.centerModel.regulatory[indexPath.row];
    [self.viewContoller.navigationController pushViewController:editVC animated:YES];
}
@end
