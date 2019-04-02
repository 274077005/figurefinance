//
//  RDRelationTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/30.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "RDRelationTVCell.h"
#import "TheRDRelationTVCell.h"
@implementation RDRelationTVCell{
    CALayer * _BVLayer;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _BVLayer = [[CALayer alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"TheRDRelationTVCell" bundle:nil] forCellReuseIdentifier:@"TheRDRelationCellId"]; 
    
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
    
    return _deModel.relationArr.count;
}

//设定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TheRDRelationTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TheRDRelationCellId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DetailArrModel * arrModel = _deModel.relationArr[indexPath.row];
    
    cell.titleLab.text = arrModel.name;
    cell.contentLab.text = arrModel.content;

    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
@end
