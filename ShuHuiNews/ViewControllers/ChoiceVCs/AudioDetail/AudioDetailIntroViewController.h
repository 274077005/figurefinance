//
//  AudioDetailIntroViewController.h
//  ShuHuiNews
//
//  Created by zhaowei on 2019/4/25.
//  Copyright © 2019 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DlgCommentV.h"
#import "DlgCommentWayV.h"

NS_ASSUME_NONNULL_BEGIN

@interface AudioDetailIntroViewController : UITableViewController
@property (nonatomic, assign) BOOL vcCanScroll;
@property (nonatomic,strong) UIViewController *VC;
@property (nonatomic,strong) NSDictionary *dataDict;
@property (strong,nonatomic)UILabel *nameLb;

@property(nonatomic,strong)DlgCommentV * commentV;

@property(nonatomic,strong)DlgCommentWayV * wayV;
//评论的内容
@property(nonatomic,copy)NSString * commentStr;

//总的评论数据
@property(strong,nonatomic)NSMutableArray *commentsArr;

@end

NS_ASSUME_NONNULL_END
