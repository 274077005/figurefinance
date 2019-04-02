//
//  TheEnvironmentCVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/21.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "TheEnvironmentICVCell.h"

@implementation TheEnvironmentICVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"TheEnvironmentTVCell" bundle:nil] forCellReuseIdentifier:@"EnvironmentCellId"];
    // Initialization code
}
-(void)updateWithModel
{
    self.tableView.backgroundColor = [UIColor greenColor];
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.enModel.content.count;
}

//设定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TheEnvironmentTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EnvironmentCellId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.enModel = self.enModel.content[indexPath.row];
    
    [cell updateWithModel];
    
    return cell;
    
}
@end
