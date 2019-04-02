//
//  BaseWebVC.m
//  Finance
//
//  Created by 耿一 on 2017/9/6.
//  Copyright © 2017年 GY. All rights reserved.
//

#import "BaseWebVC.h"

@interface BaseWebVC ()
{
//    //网页视图
//    WKWebView * _webView;
    

}
@end

@implementation BaseWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];

    //实例化
    [self createWebView];
    UIColor* color = [UIColor blackColor];
    NSDictionary* dict= [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes= dict;
    UIImage *backButtonImage = [UIImage imageNamed:@"navGoBack"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[backButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(webGoBack)];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //当plist里设置为NO时，这样设置有效果
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)webGoBack
{
    
    if (_webView.canGoBack) {
        [_webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    

}

- (void)createWebView
{
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    configuration.preferences = preferences;
    
    
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, TopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - TopHeight)configuration:configuration];
    _webView.scrollView.bounces= NO;
    _webView.backgroundColor = [UIColor whiteColor];
    self.webView.navigationDelegate = self;
//    self.webView.UIDelegate = self;
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
//    self.urlStr = @"https://www.baidu.com";
    
    [self.view addSubview:_webView];

    //    //调整适应比例
    //    _webView.scalesPageToFit = YES;
    //    //设置代理
    NSLog(@"%@",self.urlStr);
    _webView.navigationDelegate = self;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15.0]];
}

#pragma mark - WKWebView Delegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
//    [SVProgressHUD show];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"%@",_webView.title);
    if ([_webView.title length]>1) {
        self.navigationItem.title = _webView.title;
    }
    
//    NSString *inputValueJS = @"document.getElementsByName('input')[0].attributes['value'].value";
//
//    NSLog(@"%@",inputValueJS);
//
//    //执行JS
//    [webView evaluateJavaScript:inputValueJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {
//        NSLog(@"value: %@ error: %@", response, error);
//    }];


}
- (void)addScriptMessageHandler:(id <WKScriptMessageHandler>)scriptMessageHandler name:(NSString *)name
{
    
    NSLog(@"%@",name);
    
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
    NSLog(@"%@",message.name);
}
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == _webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }else{
        self.title = _webView.title;
        
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [SVProgressHUD showWithString:@"网络故障"];
    NSLog(@"%@",error);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 类似 UIWebView 的 -webView: shouldStartLoadWithRequest: navigationType:
    
    NSString *urlStr = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    NSLog(@"%@",urlStr);
//    NSArray *arr = [urlStr componentsSeparatedByString:@"share=1"];
//    if (arr.count < 2) {
//        self.navigationItem.rightBarButtonItem = nil;
//    }
    
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    
    
    decisionHandler(WKNavigationActionPolicyAllow);
    //    if (arr.count > 1) {
    //
    //        decisionHandler(WKNavigationActionPolicyCancel);
    //    }else{
    //        decisionHandler(WKNavigationActionPolicyAllow);
    //    }
    
}

#pragma mark - lazy

- (UIProgressView *)progressView
{
    if(!_progressView)
    {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, TopHeight, SCREEN_WIDTH, 10)];
        self.progressView.tintColor = RGBCOLOR(251, 192, 45);
        self.progressView.trackTintColor = [UIColor whiteColor];
        [self.view addSubview:self.progressView];
    }
    return _progressView;
}
- (void)dealloc
{
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"title"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//支持自签名的https
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
        
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
