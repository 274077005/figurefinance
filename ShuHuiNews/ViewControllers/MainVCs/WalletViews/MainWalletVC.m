//
//  MainWalletVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/22.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "MainWalletVC.h"
#import "TradingRecordVC.h"
@interface MainWalletVC ()
{
    NSMutableArray * _btnArr;
    NSString * _buyId;
}
@end

@implementation MainWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的钱包";
    self.topHeight.constant =  TopHeight + 15;
    _btnArr = [[NSMutableArray alloc]init];
    
    [self getMyMoneyData];
    
    
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"交易记录" style:UIBarButtonItemStyleDone target:self action:@selector(recordBtnClick)];
    [self.navigationItem.rightBarButtonItem setTintColor:WD_BLUE];

    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self buildPriceBtns];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}
- (void)recordBtnClick
{
    TradingRecordVC * recordVC = [[TradingRecordVC alloc]init];
    [self.navigationController pushViewController:recordVC animated:YES];
}
- (void)getMyMoneyData
{
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JMyWallet Handler:^(NSDictionary * jsonDic, NSError *error){
        if ([jsonDic[@"code"] integerValue] == 1) {
            NSString * moneyStr = [NSString stringWithFormat:@"%@",jsonDic[@"data"][@"balance"][@"balance"]];
            self.moneyLab.text = moneyStr;
        }else{
            [SVProgressHUD showWithString:jsonDic[@"msg"]];
        }
    }];
}
- (void)buildPriceBtns {
    NSLog(@"BBBB:%f",_chargeLab.bottom);
    
    NSArray* list = @[@"6", @"18", @"68", @"108"];
    NSArray* priceList = @[@"6", @"18", @"68", @"108"];
    CGFloat fx = 16,  fy = _chargeLab.bottom + 20, fe = 10, btn_w = (SCREEN_WIDTH-fx*2-fe)/2, btn_h = btn_w*0.4;

    CGFloat spacing = 3;
    CGFloat priceBottom = 0.0;
    for (NSInteger i = 0;i < list.count;i++) {
        NSString * item = list[i];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(fx, fy, btn_w, btn_h);
      
        [self.view addSubview:btn];
        btn.titleLabel.font = Font(18);
        [btn setTitle:formatSTR(@"%@", item) forState:0];
        [btn setTitleColor:RGBCOLOR(31, 31, 31) forState:UIControlStateNormal];
        NSDictionary * paramDic = @{@"key":formatSTR(@"com.figure.dou_%@", item)};
        btn.paramDic = paramDic;
        btn.clipsToBounds = YES;
        btn.backgroundColor = RGB(0xffffff);
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = RGB(0xececec).CGColor;
        btn.layer.cornerRadius = 3;

        [btn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setImage:[UIImage imageNamed:@"goldDou"] forState:UIControlStateNormal];
        [btn setImagePosition:GYImagePositionRight spacing:spacing];
        
        [_btnArr addObject:btn];
        if ([list indexOfObject:item] == 0) {
            [self buyBtnClick:btn];
        }
        UILabel * priceLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, btn.width, 10)];
        priceLab.center = CGPointMake(btn.center.x, btn.bottom - 12);
        priceLab.font = [UIFont systemFontOfSize:12];
        priceLab.textAlignment = NSTextAlignmentCenter;
        priceLab.textColor = RGBCOLOR(31, 31, 31);
        priceLab.text = [NSString stringWithFormat:@"%@ 元",priceList[i]];
        [self.view addSubview:priceLab];
        
        fx = btn.ex + fe;
        if ( (fx+btn_w) > SCREEN_WIDTH ) {
            fx = 16;
            fy = btn.ey + 10;
        }
        priceBottom = fy;
    }
    UILabel * alertLab = [[UILabel alloc]initWithFrame:CGRectMake(15, priceBottom, SCREEN_WIDTH - 30, 10)];
    alertLab.numberOfLines = 0;
    alertLab.font = [UIFont systemFontOfSize:12];
    alertLab.textColor = RGBCOLOR(118, 118, 118);
    NSString * text = @"充值说明:\n"
    @"1、礼品豆购买成功后无法退款，不能提现。\n"
    @"2、如果出现充值购买问题，可以联系客服，我们会及时给予解答。\n"
    @"3、1元可以购买1金豆。";
    alertLab.text = text;
    [alertLab sizeToFit];
    [self.view addSubview:alertLab];
    
    UIButton * buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.frame = CGRectMake(0, 0, 300, 50);
    buyBtn.center = CGPointMake(SCREEN_WIDTH/2, alertLab.bottom + 50);
    buyBtn.layer.cornerRadius = 25;
    buyBtn.backgroundColor = RGBCOLOR(14, 123, 243);
    [buyBtn setTitle:@"充值" forState:UIControlStateNormal];
    [buyBtn setTintColor:[UIColor whiteColor]];
    buyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [buyBtn addTarget:self action:@selector(buyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyBtn];
}
-(void)buyBtnClick
{
    NSLog(@"%@",_buyId);
    [[ApplePay shared] toPay:_buyId WithCount:1];
    WeakSelf;
    [ApplePay shared].submitBlock = ^{
        [weakSelf getMyMoneyData];
    };
}
-(void)buyBtnClick:(UIButton *)btn
{
    NSLog(@"%@",btn.paramDic);
    
    _buyId = btn.paramDic[@"key"];
    NSLog(@"%@",_buyId);
    
    for (UIButton * btn in _btnArr) {
        btn.layer.borderColor = RGB(0xececec).CGColor;
    }
    btn.layer.borderColor = RGBCOLOR(135, 190, 250).CGColor;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
