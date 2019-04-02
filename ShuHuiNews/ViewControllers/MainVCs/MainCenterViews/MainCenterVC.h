//
//  MainCenterVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/20.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "CenterHeaderTVCell.h"
#import "CenterRelationTVCell.h"
#import "CenterRegulationTVCell.h"
#import "CenterEnvironmentTVCell.h"
#import "CenterCompanyTVCell.h"
#import "CenterTagInfoTVCell.h"
#import "CenterAttestationTVCell.h"
#import "CenterAdvertTVCell.h"
#import "CenterPersonalBasicTVCell.h"
#import "MainCenterModel.h"
@interface MainCenterVC : BaseViewController


@property(nonatomic,strong)MainCenterModel * centerModel;
@end
