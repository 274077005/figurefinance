//
//  SubmitOrderVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/25.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "SubmitOrderVC.h"

@interface SubmitOrderVC ()

@end

@implementation SubmitOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";

    self.numModel = [[SubmitNumModel alloc]init];
    self.numModel.bookNum = 1;
//
    [self createTableView];
    [self setUpTableView];
    [self getOrderDetail];
    [self.view bringSubviewToFront:self.holdBV];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPayStatus) name:NPayStatus object:nil];
    // Do any additional setup after loading the view from its nib.
}
- (UIView *)payV
{
    if (!_payV) {
        _payV =  [[[NSBundle mainBundle] loadNibNamed:@"DlgPayWayV" owner:nil options:nil] lastObject];
        _payV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.55);
    }
    return _payV;
    
}
- (IBAction)submitBtnClick:(UIButton *)sender {
    CGFloat money = self.numModel.bookNum * [self.orderModel.book_detail.price floatValue];
    
    self.payV.moneyStr = [NSString stringWithFormat:@"%0.2f",money];
    [DialogView showWithPop:self.payV];
    WeakSelf;
    self.payV.submitBlock = ^(NSString *payStr) {
        [SVProgressHUD show];
        if ([payStr isEqualToString:@"wePay"]) {
            [weakSelf clickWeChatPay];
        }else{
            [weakSelf clickALiPay];
        }
        
    };


}
- (void)getPayStatus
{
    
    [SVProgressHUD showWithString:@"支付成功~"];
    
    [self performSelector:@selector(goOrderListVC)  withObject:nil afterDelay:0.5];
}
-(void)goOrderListVC
{
    OrderListVC * listVC = [[OrderListVC alloc]init];
    listVC.moreListToHere = self.moreListToHere;
    [self.navigationController pushViewController:listVC animated:YES];
}
-(void)clickALiPay
{
        NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
        [bodyDic setObject:self.bookId forKey:@"book_id"];
        [bodyDic setObject:self.orderModel.address_detail.theId forKey:@"address_id"];
        [bodyDic setObject:@(self.numModel.bookNum) forKey:@"number"];
        [bodyDic setObject:@"1" forKey:@"pay_type"];
        [bodyDic setObject:[UserInfo share].uId forKey:@"uid"];
        [GYPostData PostInfomationWithDic:bodyDic UrlPath:JSubmitOrder Handler:^(NSDictionary *jsonDic, NSError * error) {
            if (!error) {
                if ([jsonDic[@"code"] integerValue] == 1) {
                    [self goALiPay:jsonDic[@"data"]];
    
                }
            }
        }];
}
- (void)clickWeChatPay
{
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setObject:self.bookId forKey:@"book_id"];
    [bodyDic setObject:self.orderModel.address_detail.theId forKey:@"address_id"];
    [bodyDic setObject:@(self.numModel.bookNum) forKey:@"number"];
    [bodyDic setObject:@"0" forKey:@"pay_type"];
    [bodyDic setObject:[UserInfo share].uId forKey:@"uid"];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JSubmitOrder Handler:^(NSDictionary *jsonDic, NSError * error) {
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                //需要创建这个支付对象
                PayReq *req   = [[PayReq alloc] init];
                //由用户微信号和AppID组成的唯一标识，用于校验微信用户
                req.openID = jsonDic[@"appid"];
                // 商家id，在注册的时候给的
                req.partnerId = jsonDic[@"partnerid"];
                // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
                req.prepayId  = jsonDic[@"prepayid"];
                // 根据财付通文档填写的数据和签名
                //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
                req.package   = jsonDic[@"package"];
                // 随机编码，为了防止重复的，在后台生成
                req.nonceStr  = jsonDic[@"noncestr"];
                // 这个是时间戳，也是在后台生成的，为了验证支付的
                NSString * stamp = jsonDic[@"timestamp"];
                req.timeStamp = stamp.intValue;
                // 这个签名也是后台做的
                req.sign = jsonDic[@"sign"];
                //发送请求到微信，等待微信返回onResp
                [WXApi sendReq:req];
            }
        }
    }];
}
-(void)goALiPay:(NSString *)payStr
{
    [[AlipaySDK defaultService] payOrder:payStr fromScheme:@"wb1330909803" callback:^(NSDictionary *resultDic) {
        if ([resultDic[@"resultStatus"] integerValue] == 9000) {
            [self getPayStatus];
        }else if ([resultDic[@"resultStatus"] integerValue] == 6001){
            [SVProgressHUD showWithString:@"支付取消"];
        }else if ([resultDic[@"resultStatus"] integerValue] == 4000){
            [SVProgressHUD showWithString:@"支付失败"];
        }
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)getOrderDetail
{
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setObject:self.bookId forKey:@"book_id"];
    [bodyDic setObject:[UserInfo share].uId forKey:@"uid"];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JOrderDetail Handler:^(NSDictionary *jsonDic, NSError * error) {
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                self.orderModel = [SubmitOrderModel mj_objectWithKeyValues:jsonDic[@"data"]];
                self.priceLab.text = [NSString stringWithFormat:@"总金额￥%@",_orderModel.book_detail.price];
                [self.tableView reloadData];
            }
        }
    }];
}
- (void)setUpTableView
{
    self.tableView.frame = CGRectMake(0, TopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - TopHeight - 50);
    self.tableView.backgroundColor = [UIColor whiteColor];
    //注册cell类型及复用标识
    [self.tableView registerNib:[UINib nibWithNibName:@"SubmitAddressTVCell" bundle:nil] forCellReuseIdentifier:@"AddressCellId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SNoAdTVCell" bundle:nil] forCellReuseIdentifier:@"NoAdCellId"]; 
    [self.tableView registerNib:[UINib nibWithNibName:@"SBookTVCell" bundle:nil] forCellReuseIdentifier:@"BookCellId"];
    [self.view addSubview:self.tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.orderModel.book_detail.name.length < 1) {
        return 0;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}

//设定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (self.orderModel.address_detail.name.length < 1) {
            return 85;
        }
        return 90;
    }else{
       
        return 190;
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (self.orderModel.address_detail.name.length < 1) {
            SNoAdTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoAdCellId" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            SubmitAddressTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddressCellId" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.adModel = self.orderModel.address_detail;
            [cell updateWithModel];
            return cell;
        }
       
    }else{
        SBookTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookCellId" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        WeakSelf;
        cell.changeBlock = ^{
            CGFloat money = weakSelf.numModel.bookNum * [weakSelf.orderModel.book_detail.price floatValue];
            weakSelf.priceLab.text = [NSString stringWithFormat:@"总金额￥%0.2f",money];
        };
        cell.bookModel = self.orderModel.book_detail;
        cell.numModel = self.numModel;
        [cell updateWithModel];
        return cell;
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        WeakSelf;
        if (self.orderModel.address_detail.name.length < 1) {
            
            AddAddressVC * addVC = [[AddAddressVC alloc]init];
            addVC.saveBlock = ^{
                [weakSelf getOrderDetail];
            };
            [self.navigationController pushViewController:addVC animated:YES];
        }else{
            AddressListVC * listVC = [[AddressListVC alloc]init];
            listVC.delegate = self;

            listVC.selectId = self.orderModel.address_detail.theId;
            [self.navigationController pushViewController:listVC animated:YES];
        }
    }
}
//选择了某个地址
-(void)selectAddressWithModel:(SAddressModel *)adModel
{
    self.orderModel.address_detail = adModel;
    [self.tableView reloadData];
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
