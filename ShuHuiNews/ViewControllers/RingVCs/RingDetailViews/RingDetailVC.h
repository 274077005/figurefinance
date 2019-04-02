//
//  RingDetailVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/2.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "RDHeaderTVCell.h"
#import "RDGradeTVCell.h"
#import "RDRelationTVCell.h"
#import "RDURLTVCell.h"
#import "RDRelationTVCell.h"
#import "RDRegulationTVCell.h"
#import "RDEnvironmentTVCell.h"
#import "RDTagInfoTVCell.h"
#import "RDAdvertTVCell.h"
#import "RDCommentTVCell.h"

#import "RDPersonalHeaderTVCell.h"
#import "RDPersonalBasicTVCell.h"
#import "RDIntroduceTVCell.h"
#import "RecommendFlashTVCell.h"
#import "HomeImgsTVCell.h"
#import "HomeNormalTVCell.h"
#import "HomeSpecialTVCell.h"
#import "HomeColumnTVCell.h"
#import "HomeVideoTVCell.h"
#import "CommentWebVC.h"
#import "SpecialDetailVC.h"
#import "VideoDetailVC.h"
#import "RingDetailModel.h"
@interface RingDetailVC : BaseViewController



@property(nonatomic,copy)NSString * writeId;

@property(nonatomic,strong)RingUserModel * userModel;

@end
