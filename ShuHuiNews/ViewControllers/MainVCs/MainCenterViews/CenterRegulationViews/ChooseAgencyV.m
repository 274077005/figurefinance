//
//  ChooseInstitutionV.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/29.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "ChooseAgencyV.h"

@implementation ChooseAgencyV

-(void)awakeFromNib{
    [super awakeFromNib];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"AgencyTVCell" bundle:nil] forCellReuseIdentifier:@"AgencyCellId"];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.centerModel.allAgency.count;
}

//设定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AgencyTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AgencyCellId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CenterAgencyModel * agModel = self.centerModel.allAgency[indexPath.row];
    
    [cell.imageV sd_setImageWithURL:IMG_URL(agModel.logo_url)];
    cell.titleLab.text = agModel.agency_name;
  
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CenterAgencyModel * agModel = self.centerModel.allAgency[indexPath.row];
    self.submitBlock(agModel);
    
    [DialogView close];

}
@end
