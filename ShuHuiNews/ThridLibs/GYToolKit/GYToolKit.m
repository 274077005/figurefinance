//
//  GYToolKit.m
//  HomeForPets
//
//  Created by xz on 2017/6/9.
//  Copyright © 2017年 耿一. All rights reserved.
//

#import "GYToolKit.h"
#import "KeychainItemWrapper.h"
#import "sys/utsname.h"
@implementation GYToolKit



+ (NSString *)GetIphoneType {
    
    // 需要导入头文件：
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return @"iPad 7s";
    
}

//字符串转字典
+ (NSDictionary*)jsonStrToDictionary:(NSString *)jsonStr
{
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    return jsonDic;
}
//字典转字符串
+ (NSString*)dictionaryToJsonStr:(NSDictionary *)dic
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    str =[str stringByReplacingOccurrencesOfString:@"  " withString:@""];
    str =[str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    return str;
}

//字典转拼接字符串
+ (NSString *)dictionaryToPostStr:(NSDictionary *)params{
    
    NSMutableArray *result = [NSMutableArray new];
    
    for (NSString * key in params) {
        NSString * keyAndValue = [NSString stringWithFormat:@"%@=%@",key,[params valueForKey:key]];
        [result addObject:keyAndValue];
    }
    NSString * str = [NSString stringWithFormat:@"?%@",[result componentsJoinedByString:@"&"]];
    return str;
    
}

+ (NSString *)URLEncode:(NSString *)url {
    
    NSString* newString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSString *newString =
//    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                              (CFStringRef)url,
//                                                              NULL,
//                                                              CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    if (newString) {
        return newString;
    }
    return url;
}
// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|6[5-6]|7[0-9]|8[0-9]|9[8-9])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}
//把NSDictionary解析成post格式的NSString字符串
+ (NSString *)parseParams:(NSDictionary *)params{
    NSMutableArray *result = [NSMutableArray new];
    
    for (NSString * key in params) {
        NSString * keyAndValue = [NSString stringWithFormat:@"%@=%@",key,[params valueForKey:key]];
        [result addObject:keyAndValue];
    }
    return [result componentsJoinedByString:@"&"];
    
}
+ (NSString *)GetUUID {
    //    添加设备唯一标识
    //获取uuid之后，存到钥匙串里
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"kUUID" accessGroup:nil];
    NSString *aliaStr = [wrapper objectForKey:(id)CFBridgingRelease(kSecValueData)];
    
    if (aliaStr.length > 0) {
        NSLog(@"*********%@",aliaStr);
    } else {
        aliaStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        //保存数据
        [wrapper resetKeychainItem];
        [wrapper setObject:aliaStr forKey:(id)CFBridgingRelease(kSecValueData)];
        
    }
    return aliaStr;
}
/**
 *  跳转到系统设置页面，iOS8之后可用
 */
+ (void)gotoSettings{
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString: UIApplicationOpenSettingsURLString]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: UIApplicationOpenSettingsURLString]];
    }
}
//导入https证书
+ (AFSecurityPolicy*)customSecurityPolicy {
    
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"nginx" ofType:@"cer"];//证书的路径
    NSLog(@"%@",cerPath);
    
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    securityPolicy.pinnedCertificates = @[certData];
    return securityPolicy;
}

//获取当前显示页面的控制器
+ (UIViewController *)topViewController{
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    
    
    return nil;
}

/**
 *  计算富文本字体高度
 *
 *  @param lineSpace 行高
 *  @param font       字体
 *  @param width      字体所占宽度
 *
 *  @return 高度
 */
+(CGFloat)AttribLHWithSpace:(CGFloat)lineSpace size:(NSInteger)font width:(CGFloat)width str:(NSString*)str {
    if (str.length < 1) {
        str = @"   ";
    }
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = lineSpace;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font],NSParagraphStyleAttributeName:paraStyle};
    
    NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, 0) options:option attributes:attribute context:nil].size;
    
    return size.height;

}
//计算HTML文本高度
+(CGFloat)HTMLLHWithSpace:(CGFloat)lineSpace size:(NSInteger)font width:(CGFloat)width str:(NSString*)str {
    if (str.length < 1) {
        str = @"   ";
    }
    
    
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = lineSpace;
    
    NSMutableAttributedString * attStr=  [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSParagraphStyleAttributeName:paraStyle} documentAttributes:nil error:nil];
    
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, attStr.length)];
    
    NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    CGRect rect = [attStr boundingRectWithSize:CGSizeMake(width, 0) options:option context:nil];
    
    return rect.size.height;
    
}
/**
 *  计算普通文本字体高度
 *

 *  @param font       字体
 *  @param width      字体所占宽度
 *
 *  @return 高度
 */
+(CGFloat)NormalLHWithSize:(NSInteger)font width:(CGFloat)width str:(NSString*)str {

    if (str.length < 1) {
        str = @"   ";
    }
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 5000)];
    
    label.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:font];
    label.text = str;
    [label sizeToFit];
    CGSize size = label.frame.size;
    return size.height;
}
//获取字体宽度
+(CGFloat)LabelWidthWithSize:(NSInteger)font height:(CGFloat)height str:(NSString*)str {
    
    if (str.length < 1) {
        str = @"   ";
    }
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};  //指定字号
    CGRect rect = [str boundingRectWithSize:CGSizeMake(0, height)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}
//1970年到现在的秒数
+ (NSInteger)getSecondTimeSince1970
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString * nowTime = [NSString stringWithFormat:@"%f",time];
    
    return [nowTime integerValue];
}
//1970年到现在的毫秒数
+ (NSString *)getTimeIntervalSince1970
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSInteger date = time * 1000;
    
    NSString * dateStr =[NSString stringWithFormat:@"%ld",date];
    return dateStr;
}
//秒数转时间
+ (NSString *)SecondChangeToTime:(NSInteger)timeValue{
    
    NSInteger hour = timeValue / 3600;
    NSInteger minute = timeValue / 60;
    NSInteger second = timeValue % 60;
    if (hour > 0) {
        return [NSString stringWithFormat:@"%ld:%ld:%ld", hour, minute, second];
    } else {
        return [NSString stringWithFormat:@"%02ld:%02ld", minute, second];
    }
}
//判断数字是不是整形
+ (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
//判断是不是为数字类型
+ (BOOL)isNum:(NSString *)checkNumStr {
    if (checkNumStr.length == 0) {
        return NO;
    }
    NSString *regex = @"^[0-9]+(.[0-9]+)?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:checkNumStr]) {
        return YES;
    }
    return NO;
    

}

//获取签名字符串
+(NSString *)GetSignWithBody:(NSMutableDictionary *)body
{
    NSMutableDictionary * signDic = [[NSMutableDictionary alloc]initWithDictionary:body];
    if ([UserInfo share].isLogin) {
        [signDic setObject:[UserInfo share].token forKey:@"app_token"];
    }
    NSArray *keyArray = [signDic allKeys];
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];

//    NSLog(@"%@",sortArray);
    
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortString in sortArray) {
        [valueArray addObject:[signDic objectForKey:sortString]];
    }
//    NSMutableArray *signArray = [NSMutableArray array];
//    for (int i = 0; i < sortArray.count; i++) {
//        NSString *keyValueStr = [NSString stringWithFormat:@"%@:%@",sortArray[i],valueArray[i]];
//        [signArray addObject:keyValueStr];
//    }
    NSString *arrayStr = [valueArray componentsJoinedByString:@","];
    NSString *sign = [arrayStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    sign = [MD5Tool MD5ForLower32Bate:sign];

    sign = [MD5Tool MD5ForLower32Bate:sign];

    
    return sign;
    
}

//如果没有登录
+ (void)pushLoginVC{
    LoginViewController * loginVC = [[LoginViewController alloc]init];
    SystemNVC * navC = [[SystemNVC alloc]initWithRootViewController:loginVC];
    
    [[GYToolKit topViewController] presentViewController:navC animated:YES completion:nil];
}

//压缩图片质量
+ (NSData *)compressImageQuality:(UIImage *)image toKb:(NSInteger)Kb {
    NSInteger maxLength = Kb *1024;
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) {
        return data;
    }
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    return data;
}
//截图
+ (UIImage *)snapshotSingleView:(UIView *)view
{
    //获取指定View的图片
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
//判断字符串是否包含汉字
+ (BOOL)includeChinese:(NSString *)string
{
    for(int i=0; i< [string length];i++)
    {
        int a =[string characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}
+ (UIImage *)createImageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
+ (void)createAlertWith:(NSString *)titleStr message:(NSString *)message action:(void(^)(UIAlertAction * _Nonnull action))action target:(id)target{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:titleStr message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:action];
    
    [alert addAction:cancleAction];
    [alert addAction:confirmAction];
    
    [target presentViewController:alert animated:YES completion:nil];
}
//精确字符串
//几位小数，folat字符
+ (NSString *)changeWithFormat:(NSInteger)format FloatNumber:(float)floatNumber
{
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSMutableString * formatStr = [[NSMutableString alloc]initWithString:@"0"];
    if (format > 0) {
        [formatStr appendString:@"."];
    }
    for (NSInteger i = 0; i <format; i++) {
        [formatStr appendString:@"0"];
    }
    [numberFormatter setPositiveFormat:formatStr];
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatNumber]];
    
}

//调用share进行分享
+(void)shareSDKToShare:(NSMutableDictionary*)shareParams{
//    设置简介版UI 需要
    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
    SSUIShareActionSheetController *sheet =   [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                                                       items:nil
                                                                 shareParams:shareParams
                                                         onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                             
                                                             switch (state) {
                                                                 case SSDKResponseStateSuccess:
                                                                 {
                                                                     if (platformType == SSDKPlatformTypeCopy) {
                                                                         [SVProgressHUD showWithString:@"链接已拷贝到剪贴板"];
                                                                     }else{
                                                                         [SVProgressHUD showWithString:@"分享成功"];
                                                                     }
                                                                     
                                                                     break;
                                                                 }
                                                                     
                                                                 case SSDKResponseStateFail:
                                                                 {
                                                                     NSLog(@"%@",error);
                                                                     
                                                                     [SVProgressHUD showWithString:@"分享失败"];
                                                                     break;
                                                                 }
                                                                 default:
                                                                     break;
                                                             }
                                                         }
                                               ];
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeCopy)];
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
}


@end
