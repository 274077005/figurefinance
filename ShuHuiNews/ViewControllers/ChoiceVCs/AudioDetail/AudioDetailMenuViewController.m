//
//  AudioDetailMenuViewController.m
//  ShuHuiNews
//
//  Created by zhaowei on 2019/4/25.
//  Copyright © 2019 耿一. All rights reserved.
//

#import "AudioDetailMenuViewController.h"
#import "NSData+CommonCrypto.h"

@interface AudioDetailMenuViewController ()

@end

@implementation AudioDetailMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _dataAry = @[@"一生一世",@"二两心思",@"三言两语",@"四海升平",@"五湖四海",@"六畜兴旺",@"七上八下",@"八仙过海",@"九牛一毛",@"十全十美",@"一生一世",@"二两心思",@"三言两语",@"四海升平",@"五湖四海",@"六畜兴旺",@"七上八下",@"八仙过海",@"九牛一毛",@"十全十美"];
    
    [self readData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readData) name:@"fresh" object:nil];
}

- (void)readData{
    NSDictionary *dataDict = [UserDefaults objectForKey:@"dataDetail"];
    
    NSArray *chapterArr = dataDict[@"audioTypeData"];
    _dataAry = chapterArr;
    
    [self.tableView reloadData];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!self.vcCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        self.vcCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        //到顶通知父视图改变状态
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataAry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rank"];
    if (cell==nil) {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"rank"];
    }
    NSDictionary *dict = _dataAry[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",dict[@"chapterName"]];
    
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    if ([dict[@"isFree"] integerValue] == 0) {
        cell.detailTextLabel.text = @"购买";
        cell.textLabel.textColor= RGBCOLOR(166, 166, 166);
    }else{
        cell.detailTextLabel.text = @" ";
        cell.textLabel.textColor= RGBCOLOR(30, 30, 30);
    }
    cell.detailTextLabel.textColor = RGBCOLOR(166, 166, 166);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *sortLb = [[UILabel alloc] initWithFrame:CGRectMake(16, 1, 100, 49)];
    sortLb.textColor = RGBCOLOR(30, 30, 30);
    sortLb.font = [UIFont systemFontOfSize:13];
    sortLb.text = @"章节排序";
    sortLb.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:sortLb];
    
    UIButton *sortBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-45, 15, 40, 20)];
    //CGPoint center = self.center;
    sortBtn.center = headerView.center;
    [sortBtn setTitle:@"正序" forState:UIControlStateNormal];
    [sortBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [sortBtn setTitleColor:RGBCOLOR(166, 166, 166) forState:UIControlStateNormal];
    [sortBtn addTarget:self action:@selector(sortBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:sortBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 49, SCREEN_WIDTH-30, 1)];
    line.backgroundColor = RGBCOLOR(237, 237, 237);
    [headerView addSubview:line];
    return headerView;
}
- (void)sortBtnClicked:(UIButton *)sender{
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    [_VC.navigationController pushViewController:[NewSkipViewController new] animated:YES];
    
    //点击播放音频
    //先判断是否是免费
    NSDictionary *dict = _dataAry[indexPath.row];
    if([dict[@"isFree"] integerValue] == 1){
        //购买
        if(![UserInfo share].isLogin){
            LoginViewController * loginVC = [[LoginViewController alloc]init];
            SystemNVC * navC = [[SystemNVC alloc]initWithRootViewController:loginVC];
            [self presentViewController:navC animated:YES completion:nil];
        }else{
            //跳转到订单详情页面
            ZWOrderDetailViewController *orderDetailViewController = [[ZWOrderDetailViewController alloc] initWithNibName:@"ZWOrderDetailViewController" bundle:nil];
            //获取控制器
            UINavigationController *controller = [self currentNC];
            [controller pushViewController:orderDetailViewController animated:YES];
            
        }
        
    }else if([dict[@"isFree"] integerValue] == 0){
        //获取音频数据
        //先获取公共参数
        //时间
        //443C69A3-5041-4812-BBD0-8FD347BE45B9
        //7204AE73-13A1-4874-A433-AA34C6118F4D
        NSString *dateStr = [self getCurrentTime];
        NSString *tempStr = [[NSUUID UUID] UUIDString];
        NSString *uuidStr = [tempStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSString *urlStr = @"http://vod.cn-shanghai.aliyuncs.com/?";

        
        //对url进行hmac签名
        //NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:url] invertedSet];
        //
      
        NSString *guifanStr1 = [NSString stringWithFormat:@"AccessKeyId=LTAIOUMNPxpMgkpq &Action=GetPlayInfo&Format=json&SignatureMethod=HMAC-SHA1&SignatureNonce=%@&SignatureVersion=1.0&Version=2017-03-21&Timestamp=%@&VideoId=%@",uuidStr,dateStr,dict[@"videoId"]];
          NSString *str1 = [guifanStr1 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *str2 = @"/";
        NSString *xieStr = [str2 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *stringToSign = [NSString stringWithFormat:@"GET&%@&%@",xieStr,str1];
        //对代签名字符串HMac
        NSString *accessKeySecret = @"vqqJxTE5CNQAo3C2zsE54QokFrEdFR&";
        NSString *signatureStr = [self HMacHashWithKey:accessKeySecret data:stringToSign];
        
       NSString *url = [NSString stringWithFormat:@"%@Format=json &Action=GetPlayInfo&VideoId=%@&Version=2017-03-21&SignatureMethod=HMAC-SHA1&Timestamp=%@&SignatureVersion=1.0&SignatureNonce=%@&AccessKeyId=LTAIOUMNPxpMgkpq&Signature=%@",urlStr,dict[@"videoId"],dateStr,uuidStr,signatureStr];
        [[GYUrlSession defaultSession] accessServerWithURLStr:url Handler:^(id dict, NSError *error) {
            //获取返回信息
            NSLog(@"%@",dict);
        }];
        
        
    }
}

//hmac转化
-  (NSString *)HMacHashWithKey:(NSString *)key data:(NSString *)data{
    
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    //关键部分
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC
                                          length:sizeof(cHMAC)];
    
    //将加密结果进行一次BASE64编码。
    NSString *hash = [HMAC base64EncodedStringWithOptions:0];
    return hash;
    
}


//获取时间戳
- (NSString *)getCurrentTime{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-ddTHH:mm:ssZ"];
    NSDate *dateNow = [NSDate date];
    NSString *currentTime = [dateFormatter stringFromDate:dateNow];
    return currentTime;
}

- (UINavigationController *)currentNC
{
    if (![[UIApplication sharedApplication].windows.lastObject isKindOfClass:[UIWindow class]]) {
        NSAssert(0, @"未获取到导航控制器");
        return nil;
    }
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self getCurrentNCFrom:rootViewController];
}

//递归
- (UINavigationController *)getCurrentNCFrom:(UIViewController *)vc
{
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UINavigationController *nc = ((UITabBarController *)vc).selectedViewController;
        return [self getCurrentNCFrom:nc];
    }
    else if ([vc isKindOfClass:[UINavigationController class]]) {
        if (((UINavigationController *)vc).presentedViewController) {
            return [self getCurrentNCFrom:((UINavigationController *)vc).presentedViewController];
        }
        return [self getCurrentNCFrom:((UINavigationController *)vc).topViewController];
    }
    else if ([vc isKindOfClass:[UIViewController class]]) {
        if (vc.presentedViewController) {
            return [self getCurrentNCFrom:vc.presentedViewController];
        }
        else {
            return vc.navigationController;
        }
    }
    else {
        NSAssert(0, @"未获取到导航控制器");
        return nil;
    }
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
