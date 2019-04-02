//
//  MyQAVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/18.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "ReplyMeV.h"
@interface MyQCommentVC : BaseViewController<UIScrollViewDelegate>


@property(nonatomic,strong)UIScrollView * scrollV;


@property(nonatomic,strong)ReplyMeV * replyMeV;
@property(nonatomic,strong)ReplyMeV * commentOtherV;
@end
