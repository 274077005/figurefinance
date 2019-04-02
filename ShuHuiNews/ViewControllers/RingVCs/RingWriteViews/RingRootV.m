//
//  RingRootV.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/27.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "RingRootV.h"

@implementation RingRootV

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.statusModel = [[RingStatusModel alloc]init];
        [self createTableView];
        [self setUpTableView];
        
    }
    return self;
}
- (void)setUpContentView
{
    [self getRingRootData];
    NSDictionary * jsonDic = [UserDefaults dictionaryForKey:@"RingRootDic"];
    if (jsonDic) {
        self.tableView.tableHeaderView = self.bannerV;
        self.ringModel = [RingRootModel mj_objectWithKeyValues:jsonDic[@"data"]];
        [self.tableView reloadData];
    }
}

- (UIView *)bannerV
{
    if (!_bannerV) {
        _bannerV =  [[[NSBundle mainBundle] loadNibNamed:@"RingBannerV" owner:nil options:nil] lastObject];
        _bannerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 120);
        //        [self.contentView addSubview:_recommendV];
        
    }
    return _bannerV;
    
}
- (void)getRingRootData
{
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    
    if (_statusModel.sCompanyId.length > 0) {
        
        [bodyDic setObject:_statusModel.sCompanyId forKey:@"company_tag"];
    }
    if (_statusModel.sPersonId.length > 0) {
        [bodyDic setObject:_statusModel.sPersonId forKey:@"person_tag"];
    }
    [bodyDic setObject:_statusModel.menuId forKey:@"industry"];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JRingRoot Handler:^(NSDictionary *jsonDic, NSError * error) {
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                if (!_notFirstToHere && _cellIndex == 0) {
                    [UserDefaults setObject:jsonDic forKey:@"RingRootDic"];
                    _notFirstToHere = YES;
                }
                self.tableView.tableHeaderView = self.bannerV;
                self.bannerV.industryId = _statusModel.menuId;
                self.ringModel = [RingRootModel mj_objectWithKeyValues:jsonDic[@"data"]];
                [self.tableView reloadData];
            }
        }
    }];
}
-(void)createTableView
{
    self.tableView = [[UITableView alloc]init];
    CGRect tableFrame = self.bounds;
    
    self.tableView.frame = tableFrame;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = WD_BACKCOLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    [self addSubview:self.tableView];
}
- (void)setUpTableView
{
    self.tableView.frame = self.bounds;
    //注册cell类型及复用标识
    [self.tableView registerNib:[UINib nibWithNibName:@"RingTagTVCell" bundle:nil] forCellReuseIdentifier:@"TagCellId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RingNormalTVCell" bundle:nil] forCellReuseIdentifier:@"NormalCellId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonTagTVCell" bundle:nil] forCellReuseIdentifier:@"PersonTagCellId"];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_ringModel.person_tag.count ==0  &&_ringModel.company_tag.count == 0) {
        return 0;
    }
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return _ringModel.company.count;
    }else if (section == 3){
        return _ringModel.person.count;
    }
    return 1;
}

//设定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.statusModel.companyAll) {
            NSInteger lineCount = (self.ringModel.company_tag.count +4)/4;
            return lineCount * 44 + 80 + (lineCount - 1)*10;
        }else{
            NSInteger lineCount = 2;
            return lineCount * 44 + 80 + (lineCount - 1)*10;
        }
    }else if (indexPath.section == 1 ||indexPath.section == 3){
        return 72;
    }else if (indexPath.section == 2) {
        if (self.statusModel.personAll) {
            NSInteger lineCount = (self.ringModel.person_tag.count +4)/4;
            return lineCount * 44 + 80 + (lineCount - 1)*10;
        }else{
            NSInteger lineCount = 2;
            return lineCount * 44 + 80 + (lineCount - 1)*10;
        }
    }
    return 200;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    if (indexPath.section == 0 ) {
        RingTagTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TagCellId" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.ringModel = self.ringModel;
        cell.statusModel = self.statusModel;
        cell.tableView = self.tableView;
        [cell updateWithRingModel];
        
        cell.refreshBlock = ^{
            [weakSelf getRingRootData];
        };
        return cell;
    }else if (indexPath.section == 1 ||indexPath.section == 3){
        RingListModel * listModel;
        if (indexPath.section == 1) {
            listModel = _ringModel.company[indexPath.row];
        }else{
            listModel = _ringModel.person[indexPath.row];
        }
        RingNormalTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCellId" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.listModel = listModel;
        [cell updateWithModel];
        return cell;
    }else if (indexPath.section == 2){
        PersonTagTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonTagCellId" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.ringModel = self.ringModel;
        cell.statusModel = self.statusModel;
        cell.tableView = self.tableView;
        [cell updateWithRingModel];
        
        cell.refreshBlock = ^{
            [weakSelf getRingRootData];
        };
        return cell;
    }
    
    return nil;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 ||indexPath.section == 3){
        RingListModel * listModel;
        if (indexPath.section == 1) {
            listModel = _ringModel.company[indexPath.row];
        }else{
            listModel = _ringModel.person[indexPath.row];
        }
        RingDetailVC * detailVC = [[RingDetailVC alloc]init];
        detailVC.writeId = listModel.theId;
        [self.viewContoller.navigationController pushViewController:detailVC animated:YES];
    }


}
@end
