//
//  VideoDetailVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/3.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "XHPlayer.h"
#import "VideoDetailModel.h"
#import "VideoTitleTVCell.h"
#import "CorrelationVideoTVCell.h"
#import "VideoCommentTVCell.h"
#import "DlgCommentV.h"
#import "DlgCommentWayV.h"
@interface VideoDetailVC : BaseViewController<XHPlayerDelegate>

@property(nonatomic,copy)NSString * theId;

@property(nonatomic,copy)NSString * videoUrl;

@property(nonatomic,copy)NSString * dateTime;

@property(nonatomic,copy)NSString * durationTime;

@property (nonatomic, strong) XHPlayer * player;

@property(nonatomic,copy)NSString * vGetUrl;

@property(nonatomic,strong)VideoDetailModel * detailModel;
@property (weak, nonatomic) IBOutlet UIView *tfBV;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property(nonatomic,strong)DlgCommentV * commentV;

@property(nonatomic,strong)DlgCommentWayV * wayV;

@property(nonatomic,strong)UIView * sofaV;
//评论的内容
@property(nonatomic,copy)NSString * commentStr;

@property(nonatomic,copy)NSString * commentName;

@property(nonatomic,copy)NSString * chooseCId;  //点击评论的Id
@property(nonatomic,assign)NSInteger chooseIndex;  //删除的话要用到下标

@property(nonatomic,assign)BOOL collectStatus; //收藏状态
@end
