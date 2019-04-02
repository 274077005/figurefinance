//
//  RingQAVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/14.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "RingDetailModel.h"
#import "TheRDComTVCell.h"
#import "DlgCommentV.h"
#import "DlgCommentWayV.h"
@interface RDCommentVC : BaseViewController

//计算用户数据每个Cell的高度
- (NSMutableArray *)getCellHWithArr:(NSArray *)array;


@property(nonatomic,strong)DlgCommentV * commentV;

@property(nonatomic,strong)DlgCommentWayV * wayV;

@property(nonatomic,assign)BOOL comToOther;
@property(nonatomic,copy)NSString * commentStr;

@property(nonatomic,copy)NSString * chooseCId;

@property(nonatomic,copy)NSString * companyId;
@end
