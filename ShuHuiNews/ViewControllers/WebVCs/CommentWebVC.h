//
//  CommentWebVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/13.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "DlgCommentV.h"
#import "DlgCommentWayV.h"
#import "RingDetailVC.h"

@interface ShareDetailModel : NSObject

@property(nonatomic,copy)NSString * data_type;
@property(nonatomic,copy)NSString * is_collection;
@property(nonatomic,copy)NSString * nickName;
@property(nonatomic,copy)NSURL * headerUrl;
@property(nonatomic,copy)NSString * link;
@property(nonatomic,copy)NSString * isType;
@property(nonatomic,copy)NSURL * share_img;
@property(nonatomic,copy)NSString * auth_id;

@end

@interface CommentWebVC : BaseViewController<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,UIScrollViewDelegate>

@property (strong, nonatomic) UIProgressView *progressView;
@property (copy,nonatomic) NSString * urlStr;
@property (copy,nonatomic) NSString * noNetContent;
@property (strong,nonatomic) JSContext * jsContext;
@property (weak, nonatomic) IBOutlet UIView *tfBV;
@property (weak, nonatomic) IBOutlet UIView *cloumnV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cloumnVHeight;

@property (strong,nonatomic)WKWebView *webView;

@property(nonatomic,strong)DlgCommentV * commentV;

@property(nonatomic,strong)DlgCommentWayV * wayV;
//评论的内容
@property(nonatomic,copy)NSString * commentStr;

@property(nonatomic,copy)NSString * commentName;

@property(nonatomic,copy)NSString * shareTitle;

//文章的id
@property(nonatomic,copy)NSString * workId;

@property(nonatomic,assign)BOOL collectStatus;

@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

//如果是广告的话 不需要评论功能
@property(nonatomic,assign)BOOL isAdvert;

@property (nonatomic,strong)ShareDetailModel * shareModel;

@end


