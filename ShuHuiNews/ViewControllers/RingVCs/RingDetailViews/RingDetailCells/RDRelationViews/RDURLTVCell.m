//
//  RDRelationTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/30.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "RDURLTVCell.h"

@implementation RDURLTVCell{
    CALayer * _BVLayer;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _BVLayer = [[CALayer alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"TheRDURLTVCell" bundle:nil] forCellReuseIdentifier:@"URLCellId"];
    
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
-(void)updateWithModel
{
    
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return _deModel.urlArr.count;
}

//设定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TheRDURLTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"URLCellId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DetailArrModel * arrModel = _deModel.urlArr[indexPath.row];
    if ([arrModel.type isEqualToString:@"0"]) {
        cell.titleLab.text =@"中文网址";
    }else{
        cell.titleLab.text =@"英文网址";
    }
    cell.contentLab.text = arrModel.company_url;

    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailArrModel * arrModel = _deModel.urlArr[indexPath.row];
    BaseWebVC * webVC = [[BaseWebVC alloc]init];
    webVC.urlStr = arrModel.company_url;
    [self.viewContoller.navigationController pushViewController:webVC animated:YES];
}
@end
