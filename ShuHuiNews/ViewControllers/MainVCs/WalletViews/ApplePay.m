#import "ApplePay.h"



#define TestStoreVerifyURL   @"https://sandbox.itunes.apple.com/verifyReceipt" //开发阶段沙盒验证URL

#define AppStoreVerifyURL  @"https://buy.itunes.apple.com/verifyReceipt" //实际购买验证URL

@interface ApplePay () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    //NSMutableArray* m_proList;
    SKProduct* m_currPro; //这是要用的
    NSDictionary * _bodyDic;//这是需要告诉后台的
    
}


@end

@implementation ApplePay

+ (ApplePay*)shared
{
    static ApplePay* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ApplePay alloc] init];
        
    });
    
    return instance;
}

- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(void)check{
    NSArray* transactions = [SKPaymentQueue defaultQueue].transactions;
    NSLog(@"CCC:%ld",transactions.count);
    
    if (transactions.count > 0) {
        //检测是否有未完成的交易
        SKPaymentTransaction* transaction = [transactions firstObject];
        
        if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            return;
        }
        
    }
}

- (id)init
{
    if (self = [super init]) {
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        [self check];
        
        
    }
    return self;
}

/**********************************************************************************************/


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"-----------收到产品反馈信息--------------");
    NSArray *myProduct = response.products;
    NSLog(@"产品Product ID:%@",response.invalidProductIdentifiers);
    NSLog(@"产品付费数量: %d", (int)[myProduct count]);
    // populate UI
    for(SKProduct *product in myProduct){
        NSLog(@"product info");
        NSLog(@"SKProduct 描述信息%@", [product description]);
        NSLog(@"产品标题 %@" , product.localizedTitle);
        NSLog(@"产品描述信息: %@" , product.localizedDescription);
        NSLog(@"价格: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
//        [self.proList addObject:product];
        m_currPro = product;
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    
//    NOTIF_POST(NT_IAP_PRICES, nil);
}

/**********************************************************************************************/


/**********************************************************************************************/

//在这里发起购买
- (void)toPay:(NSString *)proc WithCount:(int)count
{
    if (![SKPaymentQueue canMakePayments]) {
        [SVProgressHUD showWithString:@"用户禁止内购~"];
        return;
    }
    [SVProgressHUD show];
    NSSet* set = [NSSet setWithObject:proc];
    SKProductsRequest* request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];

    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions//交易结果
{
    
    
    NSLog(@"-----paymentQueue--------");
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
                
            case SKPaymentTransactionStatePurchased:{//交易完成
                [self completeTransaction:transaction];
                NSLog(@"-----交易完成 --------");

                
            } break;
            case SKPaymentTransactionStateFailed://交易失败
                
            {

                [self failedTransaction:transaction];
                NSLog(@"-----交易失败 --------");
                [SVProgressHUD dismiss];
                UIAlertView *alerView2 =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:@"购买失败，请重新尝试购买"
                                                                    delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
                
                [alerView2 show];
                
            }break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                [self restoreTransaction:transaction];
                [SVProgressHUD dismiss];
                NSLog(@"-----已经购买过该商品 --------");
            case SKPaymentTransactionStatePurchasing:      //商品添加进列表
                NSLog(@"-----商品添加进列表 --------");
                break;
            default:
                break;
        }
    }
}
-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"restoreCompletedTransactionsFailedWithError");
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    //hideLoading(NSStringFromClass(self.class));
    NSString * productIdentifier = transaction.payment.productIdentifier;
    
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    if(!receiptData) {
        return;
    }
    NSString* trans_id = transaction.transactionIdentifier;
    
    if ([productIdentifier length] > 0) {
        NSDictionary* parmas = @{
                                 //@"receipt":receipt_str,
                                 @"productId":m_currPro.productIdentifier,
                                 @"transId":trans_id,
                                 @"title":m_currPro.localizedTitle,
                                 @"price":m_currPro.price,
                                 @"quantity":@(transaction.payment.quantity),
                                 };
        _bodyDic = parmas;
        
        
        [self verifyPurchaseWithPaymentTransaction];
    }
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    
    //hideLoading(NSStringFromClass(self.class));
    NSLog(@"%@", transaction.error);

    if(transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"购买失败");
    } else {
        NSLog(@"用户取消交易");
    }

}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    // 对于已购商品，处理恢复购买的逻辑
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    //hideLoading(NSStringFromClass(self.class));
}

/**********************************************************************************************/


/**********************************************************************************************/
-(void)verifyPurchaseWithPaymentTransaction
{
    //从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];
    
    NSString *receiptString=[receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串
    


    

    NSMutableDictionary * receiptDic= [[NSMutableDictionary alloc]initWithDictionary:_bodyDic];
    
    [receiptDic setObject:receiptString forKey:@"apple_receipt"];
    
    //这里发起请求告诉后台！！！！
    
    
    [GYPostData PostInfomationWithDic:receiptDic UrlPath:JBuyDou Handler:^(NSDictionary * jsonMessage, NSError *error){

        if (!error) {

            if ([jsonMessage[@"code"] integerValue] == 1) {
                [SVProgressHUD showWithString:@"充值成功~"];
                self.submitBlock();
                
            }else{
                [SVProgressHUD showWithString:jsonMessage[@"msg"]];
            }
        }

    }];
}



/**********************************************************************************************/
@end
