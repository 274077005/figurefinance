//
//  ZWOrderDetailViewController.m
//  ShuHuiNews
//
//  Created by zhaowei on 2019/4/20.
//  Copyright © 2019 耿一. All rights reserved.
//

#import "ZWOrderDetailViewController.h"
#import "OrderBookDetailCell.h"
#import "PriceDetailTableViewCell.h"
#import "OrderIntroView.h"
@interface ZWOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (copy,nonatomic)NSString *money;

@end

@implementation ZWOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单结算";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //[self addTableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderBookDetailCell" bundle:nil] forCellReuseIdentifier:@"bookCell"];
    [self.tableView registerClass:[PriceDetailTableViewCell class] forCellReuseIdentifier:@"priceCell"];
    
    OrderIntroView *footView = [[NSBundle mainBundle] loadNibNamed:@"OrderIntroView" owner:nil options:nil].lastObject ;
    self.tableView.tableFooterView = footView;
    
    self.tableView.scrollEnabled = NO;
    
    [self addBottomButton];
    
    //读取钱包余额
    [self getMyMoneyData];
    
}

- (void)getMyMoneyData
{
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JMyWallet Handler:^(NSDictionary * jsonDic, NSError *error){
        if ([jsonDic[@"code"] integerValue] == 1) {
            NSString * moneyStr = [NSString stringWithFormat:@"%@",jsonDic[@"data"][@"balance"][@"balance"]];
            _money = moneyStr;
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showWithString:jsonDic[@"msg"]];
        }
    }];
}

- (void)addBottomButton{
    
    UIButton *payButton = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_WINDOW_HEIGHT-60, SCREEN_WIDTH, 60)];
    _payButton = payButton;
    [payButton setTitle:@"立即支付" forState:UIControlStateNormal];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payButton.backgroundColor = [UIColor colorWithRed:35/255.0 green:122/255.0 blue:229/255.0 alpha:1.0];
    [payButton addTarget:self action:@selector(clickPayButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payButton];
 
    
}

- (void)clickPayButton{
    //弹出
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请问确定要购买么?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //购买  判断是否余额不足
        if([self.price floatValue] > [self.money floatValue]){
            [self lessMoney];
        }else{
            //pay
            [self pay];
        }
        
        
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:sureAction];
    [alert addAction:cancleAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)pay{
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setObject:self.bookDict[@"id"] forKey:@"book_id"];
    [bodyDic setObject:self.price forKey:@"price"];
    
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JPay Handler:^(NSDictionary * jsonDic, NSError *error){
        if ([jsonDic[@"code"] integerValue] == 1) {
            //购买成功
            [self successPay];
        }else{
            [SVProgressHUD showWithString:jsonDic[@"msg"]];
        }
    }];
    
}

- (void)successPay{
    //购买成功
    self.paySuccessBlock();
    
    //弹出
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"支付成功" message:@"您已成功购买本作品,可在我的书城查看或继续阅读." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"继续阅读" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //返回
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"前往书城" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //返回到书城
        NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2] animated:NO];
        
    }];
    [alert addAction:sureAction];
    [alert addAction:cancleAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)lessMoney{
    //弹出
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前余额不足请充值" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳转到我的钱包页面
        
        
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:sureAction];
    [alert addAction:cancleAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//- (void)addTableView{
//
//    UITableView *orderTableView = [[UITableView alloc] initWithFrame:CGRectZero];
//    //_orderTableView = orderTableView;
//    [self.view addSubview:orderTableView];
//    orderTableView.delegate = self;
//    orderTableView.dataSource = self;
//    [orderTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.offset(0);
//    }];
//
//
//}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        OrderBookDetailCell *bookCell = [tableView dequeueReusableCellWithIdentifier:@"bookCell" forIndexPath:indexPath];
        NSDictionary *userDict = self.bookDict[@"userInfo"];
        [bookCell.coverImgV sd_setImageWithURL:[NSURL URLWithString:self.bookDict[@"img"]]];
        bookCell.titleLab.text = self.bookDict[@"name"];
        [bookCell.userAvatar sd_setImageWithURL:[NSURL URLWithString:userDict[@"image"]]];
        bookCell.authorLabel.text = userDict[@"nickname"];
        bookCell.priceLabel.text = [NSString stringWithFormat:@"%@金豆",self.price];
        return bookCell;
    }else if(indexPath.row == 1){
        PriceDetailTableViewCell *bookCell = [tableView dequeueReusableCellWithIdentifier:@"priceCell" forIndexPath:indexPath];
        bookCell.textLabel.text = @"商品合计(金豆)";
        bookCell.detailTextLabel.text = self.price;
        return bookCell;
    }else{
        PriceDetailTableViewCell *bookCell = [tableView dequeueReusableCellWithIdentifier:@"priceCell" forIndexPath:indexPath];
        bookCell.textLabel.text = @"账户余额(金豆)";
        bookCell.detailTextLabel.text = self.money;
        return bookCell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 120;
    }else{
        return 40;
    }
}

@end
