//
//  MainCenterVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/20.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "MainCenterVC.h"

@interface MainCenterVC ()
{
    //标明用户类型
    NSInteger _userType;
    BOOL _alreadyAppear; //用来处理头部显示
    
}

@end

@implementation MainCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    UIView *backBar = self.navigationController.navigationBar.subviews.firstObject;
    backBar.subviews.firstObject.hidden = YES;//这是那个线
    backBar.subviews.lastObject.alpha = 0.0;
    [self createTableView];
    
    [self setUpTableView];
    _userType = [[UserInfo share].type integerValue];
//    [self getCenterData];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getCenterData];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    UIView *backBar = self.navigationController.navigationBar.subviews.firstObject;
    backBar.subviews.firstObject.hidden = YES;//这是那个线
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_alreadyAppear) {
        UIView *backBar = self.navigationController.navigationBar.subviews.firstObject;
        backBar.subviews.firstObject.alpha = 0.0;
        backBar.subviews.lastObject.alpha = 0.0;
        self.navigationItem.title = @"";
    }
    _alreadyAppear = YES;
}
- (void)setUpTableView
{
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CenterPersonalBasicTVCell" bundle:nil] forCellReuseIdentifier:@"PersonalBasicCellId"];
    
    
    //注册cell类型及复用标识
    [self.tableView registerNib:[UINib nibWithNibName:@"CenterHeaderTVCell" bundle:nil] forCellReuseIdentifier:@"HeaderCellId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CenterRelationTVCell" bundle:nil] forCellReuseIdentifier:@"RelationCellId"];

    [self.tableView registerNib:[UINib nibWithNibName:@"CenterRegulationTVCell" bundle:nil] forCellReuseIdentifier:@"RegulationCellId"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CenterEnvironmentTVCell" bundle:nil] forCellReuseIdentifier:@"EnvironmentCellId"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CenterCompanyTVCell" bundle:nil] forCellReuseIdentifier:@"CompanyCellId"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CenterTagInfoTVCell" bundle:nil] forCellReuseIdentifier:@"TagCellId"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CenterAttestationTVCell" bundle:nil] forCellReuseIdentifier:@"AttestationCellId"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CenterAdvertTVCell" bundle:nil] forCellReuseIdentifier:@"AdvertCellId"];
    
}
-(void)getCenterData
{
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JMainCenter Handler:^(NSDictionary *jsonDic, NSError * error) {
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                self.centerModel = [MainCenterModel mj_objectWithKeyValues:jsonDic[@"data"]];
                [self calculateCellHeight];
                [self.tableView reloadData];
            }
        }
    }];
}
-(void)calculateCellHeight
{
    if (_centerModel.environment.count > 0) {
        
        CenterEnvironmentModel * enModel = _centerModel.environment.firstObject;
        _centerModel.environmentCH = enModel.content.count * 30 +110;
        
    }else{
        _centerModel.environmentCH = 110;
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_centerModel.basic.nickname.length < 1) {
        return 0;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_userType == 2) {
        return 5;
    }
    return 8;
}

//设定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_userType == 2) {
        if (indexPath.row == 0) {
            return 300;
        }else if (indexPath.row == 1) {
            //基础信息
            return (SCREEN_WIDTH - 50)*190/325 + 170;
        }else if (indexPath.row == 2) {
            //联系方式
            return 135;
        }else if (indexPath.row == 3) {
            //标签
            return 90;
        }else if (indexPath.row == 4) {
            //广告
            return SCREEN_WIDTH * 125/375 + 70;
        }
    }
    
    if (indexPath.row == 0) {
        return 300;
    }else if (indexPath.row == 1) {
        return 135;
    }else if (indexPath.row == 2) {
        
        return 55 *  _centerModel.regulatory.count + 40;
    
    }else if (indexPath.row == 3) {
        //交易环境
//        return 260;
        if (_centerModel.environmentCH > 110) {
            return _centerModel.environmentCH;
        }
        return 110;
        
    }else if (indexPath.row == 4) {
        //公司信息
        CenterCompanyModel * coModel = _centerModel.company_info;
//        NSLog(@"AAAAAAAAAA:%lu",coModel.urls.count * 20 + 115);
        return coModel.urls.count * 20 + 185;
        
    }else if (indexPath.row == 5) {
        //标签信息
        return 90;
        
    }else if (indexPath.row == 6) {
        //认证信息
        return (SCREEN_WIDTH - 50) * 190/325 + 50;
        
    }else if (indexPath.row == 7) {
        //广告
        return SCREEN_WIDTH * 125/375 + 70;
        
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_userType == 2) {
        if (indexPath.row == 0) {
            CenterHeaderTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCellId" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.centerModel = self.centerModel;
            [cell updateWithModel];
            return cell;
        }else if (indexPath.row == 1) {
            CenterPersonalBasicTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalBasicCellId" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.centerModel = self.centerModel;
            [cell updateWithModel];
            return cell;
        }else if (indexPath.row == 2) {
            CenterRelationTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RelationCellId" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.centerModel = self.centerModel;
            [cell updateWithModel];
            return cell;
        }else if (indexPath.row == 3) {
            CenterTagInfoTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TagCellId" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.centerModel = self.centerModel;
            [cell updateWithModel];
            return cell;
        }else if (indexPath.row == 4) {
            CenterAdvertTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AdvertCellId" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.centerModel = self.centerModel;
            [cell updateWithModel];
            return cell;
        }
    }
    
    
    if (indexPath.row == 0) {
      CenterHeaderTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCellId" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.centerModel = self.centerModel;
        [cell updateWithModel];
        return cell;
    }else if (indexPath.row == 1) {
       CenterRelationTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RelationCellId" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.centerModel = self.centerModel;
        [cell updateWithModel];
        return cell;
    }else if (indexPath.row == 2) {
      CenterRegulationTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RegulationCellId" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.centerModel = self.centerModel;
        [cell updateWithModel];
        return cell;
    }else if (indexPath.row == 3) {
        CenterEnvironmentTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EnvironmentCellId" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.centerModel = self.centerModel;
        [cell updateWithModel];
        return cell;
    }else if (indexPath.row == 4) {
        CenterCompanyTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CompanyCellId" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.centerModel = self.centerModel;
        [cell updateWithModel];
        return cell;
    }else if (indexPath.row == 5) {
        CenterTagInfoTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TagCellId" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.centerModel = self.centerModel;
        [cell updateWithModel];
        return cell;
    }else if (indexPath.row == 6) {
        CenterAttestationTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AttestationCellId" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.centerModel = self.centerModel;
        [cell updateWithModel];
        return cell;
    }else if (indexPath.row == 7) {
        CenterAdvertTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AdvertCellId" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.centerModel = self.centerModel;
        [cell updateWithModel];
        return cell;
    }else{
        CenterRegulationTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AttestationCellId" forIndexPath:indexPath];
        [cell updateWithModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.centerModel = self.centerModel;
        [cell updateWithModel];
        return cell;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.y > 190) {
        [UIView animateWithDuration:0.5 animations:^{
            UIView *backBar = self.navigationController.navigationBar.subviews.firstObject;
            backBar.subviews.firstObject.alpha = 1.0;
            backBar.subviews.lastObject.alpha = 1.0;
            self.navigationItem.title = @"我的资料";
        } completion:^(BOOL finished) {
            
        }];
        
        
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            UIView *backBar = self.navigationController.navigationBar.subviews.firstObject;
            backBar.subviews.firstObject.alpha = 0.0;
            backBar.subviews.lastObject.alpha = 0.0;
            self.navigationItem.title = @"";
        } completion:^(BOOL finished) {
            
        }];
    }
}
@end
