//
//  HomeRecommendV.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/9.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendFlashTVCell.h"
#import "HomeImgsTVCell.h"
#import "HomeNormalTVCell.h"
#import "HomeSpecialTVCell.h"
#import "HomeColumnTVCell.h"
#import "HomeVideoTVCell.h"
#import "QAListTVCell.h"
#import "HomeQATVCell.h"
#import "HomeBannerV.h"
#import "CommentWebVC.h"
#import "SpecialDetailVC.h"
#import "QADetailVC.h"
#import "VideoDetailVC.h"
#import "SpecialHeaderV.h"
#import "HomeAdvertTVCell.h"
#import "BaseWebVC.h"
#import "MainCenterVC.h"
#import "HomeWorldAdvertTVCell.h"
@interface HomeRecommendV : UIView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSString * titleStr;

@property(nonatomic,copy)NSString * theId;
//搜索用的
@property(nonatomic,copy)NSString * searchStr;
@property(nonatomic,assign)BOOL searchToHere;
//专题用的
@property(nonatomic,copy)NSString * specailId;
@property(nonatomic,assign)BOOL specailToHere;

//精选用的
@property(nonatomic,copy)NSString * choiceId; //这个没有了
@property(nonatomic,assign)BOOL choiceToHere;

//收藏来这里的
@property(nonatomic,assign)BOOL collectToHere;

//我的文章来这里
@property(nonatomic,assign)BOOL workToHere;

//专栏用的
@property(nonatomic,assign)BOOL columnToHere;

//微圈过来用的
@property(nonatomic,copy)NSString * ringTypeId;
@property(nonatomic,assign)BOOL ringToHere;
@property(nonatomic,copy)NSString * industryId;



@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)HomeBannerV * bannerV;
@property(nonatomic,strong)SpecialHeaderV * specialHV;

- (void)loadRefreshData;
//首页用
- (id)initWithFrame:(CGRect)frame withId:(NSString *)theId;
//其他页面用
- (id)initWithFrame:(CGRect)frame withType:(NSInteger)comeType valueStr:(NSString *)valueStr;
@end
