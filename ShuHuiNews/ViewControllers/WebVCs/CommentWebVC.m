//
//  BaseWebVC.m
//  Finance
//
//  Created by 耿一 on 2017/9/6.
//  Copyright © 2017年 GY. All rights reserved.
//

#import "CommentWebVC.h"
#import "DlgTFView.h"

@interface CommentWebVC ()
{

    //是不是对某个回复评论
    BOOL  _comToOther;
    BOOL _firstLoad;
    UIView * _rightBarV;
    UIBarButtonItem * _rightItem;
    UILabel * _titleLab;
    UIView * _navBackBar;
}
@end

@implementation CommentWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _firstLoad = YES;

    if (self.isAdvert) {
        
        self.cloumnVHeight.constant = 0;
        self.cloumnV.hidden = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginWithWeb) name:@"loginOrQuitSuccess" object:nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _navBackBar = self.navigationController.navigationBar.subviews.firstObject;
    _navBackBar.subviews.firstObject.hidden = YES;//这是那个线
    //给Tabbar加阴影
    _navBackBar.layer.cornerRadius = 1;
    _navBackBar.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    _navBackBar.layer.shadowOffset = CGSizeMake(0,2);//shadowOffset阴影偏移
    _navBackBar.layer.shadowOpacity = 0;

//    实例化
    [self createWebView];
    UIColor* color = [UIColor blackColor];
    NSDictionary* dict= [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes= dict;
    UIImage *backButtonImage = [UIImage imageNamed:@"navGoBack"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[backButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(webGoBack)];


    UITapGestureRecognizer * tfBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tfBVClick)];
    [self.tfBV addGestureRecognizer: tfBVTGR];


    WeakSelf;
    self.commentV.submitBlock = ^(NSString *commentStr) {

            weakSelf.commentStr = commentStr;
            [weakSelf commentToWeb];
        
    };


    NSArray * arr = [_urlStr componentsSeparatedByString:@"&"];
    for (NSString * str in arr) {
        if ([str containsString:@"id="]) {
            NSArray * idArr = [str componentsSeparatedByString:@"="];
            _workId = idArr[1];
            break;
        }
    }
    
    // Do any additional setup after loading the view.
}
- (void)createRightBarView
{
    CGFloat lWidth = [GYToolKit LabelWidthWithSize:13 height:200 str:_shareModel.nickName];
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, lWidth, NavBarHeight)];
    _titleLab.text = _shareModel.nickName;
    _titleLab.font = [UIFont systemFontOfSize:13];
    _titleLab.textColor = [UIColor blackColor];
    _titleLab.textAlignment = NSTextAlignmentRight;
    
    _rightBarV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, lWidth + 22 + 5, NavBarHeight)];
    _rightBarV.layer.masksToBounds = YES;
    [_rightBarV addSubview:_titleLab];
    
    UIImageView * headerImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    headerImgV.center = CGPointMake(_rightBarV.width - headerImgV.width/2, _rightBarV.height/2);
    headerImgV.layer.masksToBounds = YES;
    headerImgV.layer.cornerRadius = headerImgV.width/2;
    [headerImgV sd_setImageWithURL:_shareModel.headerUrl];
    UITapGestureRecognizer * headerTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerImgClick)];
    [headerImgV addGestureRecognizer: headerTGR];
    headerImgV.userInteractionEnabled = YES;
    [_rightBarV addSubview:headerImgV];
    
    
    _rightItem = [[UIBarButtonItem alloc]initWithCustomView:_rightBarV];
    
//    self.navigationItem.rightBarButtonItem= _rightItem;
    
}
- (void)tfBVClick
{
//    [self commentToWeb];

    if (![UserInfo share].isLogin) {
        [GYToolKit pushLoginVC];
        return;
    }
    self.commentV.holdLab.text = @"有何见解，展开聊聊~";
    _comToOther = NO;
    [DialogView showWithPop:self.commentV];
}
- (void)commentToOtherWithDic:(NSDictionary *)dic
{
    
    NSString * nameStr = dic[@"comName"];
    self.commentV.holdLab.text = [NSString stringWithFormat:@"回复%@:",nameStr];
    if ([dic[@"oneself"]integerValue] == 1) {
        WeakSelf;
        self.wayV.submitBlock = ^(NSString *handleStr) {
            if ([handleStr isEqualToString:@"delete"]) {
                _comToOther = NO;
                [weakSelf deleteComment];
            }else{
               [DialogView showWithPop:weakSelf.commentV];
            }
        };
        [DialogView showWithPop:self.wayV];
    }else{
        
        [DialogView showWithPop:self.commentV];
    }
}

- (IBAction)collectBtnClick:(UIButton *)sender {
    if (![UserInfo share].isLogin) {
        [GYToolKit pushLoginVC];
        return;
    }
    if (_shareModel.data_type.length < 1) {
        return;
    }
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    
    [bodyDic setObject:_shareModel.data_type forKey:@"data_type"];
    [bodyDic setObject:_workId forKey:@"id"];
    if (_collectStatus) {
        [bodyDic setObject:@"1" forKey:@"status"];
    }else{
        [bodyDic setObject:@"2" forKey:@"status"];
    }

    [GYPostData GetInfomationWithDic:bodyDic UrlPath:JCollectWork Handler:^(NSDictionary * jsonMessage, NSError *error){
        if ([jsonMessage[@"code"] integerValue] == 1) {
        
            _collectStatus = !_collectStatus;
            if (_collectStatus) {
                [self.collectBtn setImage:IMG_Name(@"isCollect") forState:UIControlStateNormal];
            }else{
                [self.collectBtn setImage:IMG_Name(@"notCollect") forState:UIControlStateNormal];
            }
        }else{
            [SVProgressHUD showWithString:jsonMessage[@"msg"]];
        }
    }];
}
- (IBAction)shareBtnClick:(UIButton *)sender {
    
    NSLog(@"%@",self.urlStr);
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSMutableArray  * paramArr = [[NSMutableArray alloc]initWithArray:[self.urlStr componentsSeparatedByString:@"&"]];
//    [paramArr removeLastObject];
    NSLog(@"%@",paramArr);
    
    NSString * contentStr = [paramArr componentsJoinedByString:@"&"];
    NSString * shareStr = [NSString stringWithFormat:@"%@&type=share",contentStr];
    
    
    NSLog(@"shareUrl:%@",shareStr);
//    NSArray* imageArray = @[[UIImage imageNamed:@"appIcon"]];
    [shareParams SSDKSetupShareParamsByText:self.shareTitle
                                     images:_shareModel.share_img
                                        url:IMG_URL(shareStr)
                                      title:self.shareTitle
                                       type:SSDKContentTypeWebPage];
    [GYToolKit shareSDKToShare:shareParams];
    
    //告诉后台让后台统计
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setObject:_workId forKey:@"id"];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JShareTell Handler:^(NSDictionary * jsonMessage, NSError *error){
        
    }];
}
- (UIView *)commentV
{
    if (!_commentV) {
        _commentV =  [[[NSBundle mainBundle] loadNibNamed:@"DlgCommentV" owner:nil options:nil] lastObject];
        _commentV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.7);
    }
    return _commentV;
    
}
- (UIView *)wayV
{
    if (!_wayV) {
        _wayV =  [[[NSBundle mainBundle] loadNibNamed:@"DlgCommentWayV" owner:nil options:nil] lastObject];
        _wayV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 161.5);
    }
    return _wayV;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //当plist里设置为NO时，这样设置有效果
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"whetherLogin"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"goIosComment"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"getCollection"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"headerClick"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"commentHeaderClick"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 因此这里要记得移除handlers
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"whetherLogin"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"goIosComment"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"getCollection"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"headerClick"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"commentHeaderClick"];
}
-(void)webGoBack
{
    
    if (_webView.canGoBack) {
        [_webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)createWebView
{
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    configuration.preferences = preferences;
    

    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, TopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-_cloumnVHeight.constant-TopHeight)configuration:configuration];
    _webView.scrollView.bounces= NO;
    _webView.scrollView.delegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    self.webView.UIDelegate = self;
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];

    //    //设置代理
    NSLog(@"%@",self.urlStr);
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0]];
//    [self performSelector:@selector(test) withObject:nil afterDelay:10.0];
    
}


#pragma mark - WKWebView Delegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    //    [SVProgressHUD show];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
//    _firstLoad = NO;
    NSLog(@"获取到了title:%@",_webView.title);
    if ([_webView.title length]>1) {
        self.shareTitle = _webView.title;
    }
    
}
- (void)addScriptMessageHandler:(id <WKScriptMessageHandler>)scriptMessageHandler name:(NSString *)name
{
    NSLog(@"%@",name);
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"%@",message.body);
    NSLog(@"%@",message.frameInfo);
    NSLog(@"%@",message.name);

    if ([message.name isEqualToString:@"whetherLogin"]) {
        LoginViewController * loginVC = [[LoginViewController alloc]init];
        SystemNVC * navC = [[SystemNVC alloc]initWithRootViewController:loginVC];
        [self presentViewController:navC animated:YES completion:nil];
        //web调原生评论
    }else if ([message.name isEqualToString:@"goIosComment"]) {
        _comToOther = YES;
        
        [self commentToOtherWithDic:message.body];
        
    }else if ([message.name isEqualToString:@"getCollection"]) {
        
        NSInteger status = [message.body[@"is_collection"] integerValue];
        NSLog(@"%@",message.body);
        _shareModel = [ShareDetailModel mj_objectWithKeyValues:message.body];
        [self createRightBarView];
        if ([_shareModel.isType isEqualToString:@"6"]) {
            self.tfBV.hidden = YES;
        }
        if (status == 1) {
            _collectStatus = YES;
            [self.collectBtn setImage:IMG_Name(@"isCollect") forState:UIControlStateNormal];
        }else{
            _collectStatus = NO;
            [self.collectBtn setImage:IMG_Name(@"notCollect") forState:UIControlStateNormal];
        }
    }else if ([message.name isEqualToString:@"commentHeaderClick"]) {
        
        [self commentHeaderClickWithUserId:[NSString stringWithFormat:@"%@",message.body[@"userId"]]];
        
    }else if ([message.name isEqualToString:@"headerClick"]) {
        
        [self headerImgClick];
        
    }
    
}
- (void)commentHeaderClickWithUserId:(NSString *)userId
{
    RingDetailVC * detailVC = [[RingDetailVC alloc]init];
    detailVC.writeId = userId;
    [self.navigationController pushViewController:detailVC animated:YES];
}
//用户头像点击
-(void)headerImgClick
{
    
    RingDetailVC * detailVC = [[RingDetailVC alloc]init];
    detailVC.writeId = _shareModel.auth_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == _webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == YES) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }else{
//        self.title = _webView.title;
        
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    if (self.noNetContent.length > 1) {
        NSString *htmlString = [NSString stringWithFormat:@"<html> \n"   //html跟标签
                                "<head> \n"                         //html头部标签
                                "<meta name=\"viewport\" content=\"width=device-width,minimum-scale=1.0,maximum-scale=1.0\"/>\n"
                                "<style type=\"text/css\"> \n"      //css内部样式的写法
                                //css里面的标签选择器, 以及两条声明,一个控制到父标签的边距,一个控制字体的大小
                                "*{margin:0;padding:0;}"
                                "body {padding:0 15px;font-size: %fpx;} \n"
                                "img {width: 100%%;}\n"
                                "</style> \n"
                                "</head> \n"
                                "<body>%@</body> \n"               //html里面的主体标签
                                "</html>",16.0,self.noNetContent];
        NSLog(@"%@",htmlString);
        
        [_webView loadHTMLString:htmlString baseURL:nil];
        
    }
    NSLog(@"超时啦啊啊啊");
    [SVProgressHUD showWithString:@"服务器连接失败"];
//    NSLog(@"%@",error);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 类似 UIWebView 的 -webView: shouldStartLoadWithRequest: navigationType:
    
    NSString *urlStr = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    NSLog(@"%@",urlStr);
    NSLog(@"%@",self.urlStr);
    //    NSArray *arr = [urlStr componentsSeparatedByString:@"share=1"];
    //    if (arr.count < 2) {
    //        self.navigationItem.rightBarButtonItem = nil;
    //    }
    
    if (_firstLoad) {
        _firstLoad = NO;
        decisionHandler(WKNavigationActionPolicyAllow);

    }else if([urlStr isEqualToString:self.urlStr]){
        //如果先加载了传过来的的html字符串，又去请求正常的数据
        decisionHandler(WKNavigationActionPolicyAllow);
        
    }else if([urlStr containsString:@"about:blank"]){
        //文章中打开不是自己服务器的图片需要允许下
        decisionHandler(WKNavigationActionPolicyAllow);
        
    }else if([urlStr containsString:@"qq.com"]){
        //微信复制文章中图片展示有关
        decisionHandler(WKNavigationActionPolicyAllow);
    }else if([urlStr containsString:@"advert="]){
        //文章中的广告跳转
        NSArray * urlArr = [urlStr componentsSeparatedByString:@"advert="];
        BaseWebVC * webVC = [[BaseWebVC alloc]init];
        webVC.urlStr = urlArr.lastObject;
        [self.navigationController pushViewController:webVC animated:YES];

        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        
        CommentWebVC * commentVC = [[CommentWebVC alloc]init];
        commentVC.urlStr = urlStr;
        [self.navigationController pushViewController:commentVC animated:YES];
         decisionHandler(WKNavigationActionPolicyCancel);
    }
}

#pragma mark - lazy

- (UIProgressView *)progressView
{
    if(!_progressView)
    {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, -StatusBarHeight + 1, SCREEN_WIDTH, 10)];
        self.progressView.tintColor = RGBCOLOR(251, 192, 45);
        self.progressView.trackTintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar addSubview:self.progressView];
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
//登陆之后告诉web
-(void)loginWithWeb
{
    NSString *jsStr = [NSString stringWithFormat:@"login(%@)", [UserInfo share].uId];
    NSLog(@"%@",jsStr);
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        if (error) {
            NSLog(@"和JS交互错误:%@", error.localizedDescription);
        }
    }];
}
//评论
- (void)commentToWeb
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:_commentStr forKey:@"commentStr"];
    if (_comToOther) {
        [dic setObject:@"0" forKey:@"initiativeCom"];
        _comToOther = 0;
    }else{
        [dic setObject:@"1" forKey:@"initiativeCom"];
    }
    NSString * jsonStr = [GYToolKit dictionaryToJsonStr:dic];
    NSString *jsStr = [NSString stringWithFormat:@"goWebComment('%@')",jsonStr];

    NSLog(@"%@",jsStr);
    
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        if (error) {
            NSLog(@"和JS交互错误:%@", error.localizedDescription);
        }
    }];
}
//删除某个评论
- (void)deleteComment{
    
    NSString *delStr = [NSString stringWithFormat:@"deleteComment()"];
    
    [self.webView evaluateJavaScript:delStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        if (error) {
            NSLog(@"和JS交互错误:%@", error.localizedDescription);
        }
    }];

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.y > SCREEN_WIDTH * 187/375) {
        self.navigationItem.rightBarButtonItem= _rightItem;
        [UIView animateWithDuration:0.5 animations:^{

            _rightBarV.alpha = 1.0;
            _navBackBar.layer.shadowOpacity = 0.1;
        } completion:^(BOOL finished) {
            [self showRightItem];

        }];
        
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            _rightBarV.alpha = 0.0;
            self.navigationItem.rightBarButtonItem= nil;
            _navBackBar.layer.shadowOpacity = 0;
        } completion:^(BOOL finished) {
            _titleLab.frame = CGRectMake(100, 0, _titleLab.width, NavBarHeight);
            
        }];
    }
}
- (void)showRightItem
{
    [UIView animateWithDuration:0.5 animations:^{
        _titleLab.frame = CGRectMake(0, 0, _titleLab.width, _titleLab.height);
    } completion:^(BOOL finished) {
        
    }];
}


@end
@implementation ShareDetailModel

@end

