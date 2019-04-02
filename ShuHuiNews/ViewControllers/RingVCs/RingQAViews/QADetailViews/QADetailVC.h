//
//  QADetailVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/15.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "AnswerListTVCell.h"
#import "QAListModel.h"
#import "DlgCommentV.h"
@interface QADetailVC : BaseViewController

@property (weak, nonatomic) IBOutlet UIView *tfBV;

@property(nonatomic,strong)QAListModel * QAModel;

@property(nonatomic,copy)NSString * QAId;


@property(nonatomic,strong)DlgCommentV * commentV;
//评论的内容
@property(nonatomic,copy)NSString * commentStr;

@property (weak, nonatomic) IBOutlet UIButton *collectBtn;




@end
