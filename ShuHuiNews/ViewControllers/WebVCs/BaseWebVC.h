//
//  BaseWebVC.h
//  Finance
//
//  Created by 耿一 on 2017/9/6.
//  Copyright © 2017年 GY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface BaseWebVC : UIViewController<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>


@property (strong, nonatomic) UIProgressView *progressView;

@property (copy,nonatomic) NSString * urlStr;
@property (strong,nonatomic) JSContext * jsContext;

@property (strong,nonatomic)WKWebView *webView;

@end
