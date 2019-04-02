//
//  GYPostData+main.m
//  Finance
//
//  Created by 耿一 on 2017/9/7.
//  Copyright © 2017年 GY. All rights reserved.
//

#import "GYPostData+main.h"
#import "AFHTTPSessionManager.h"




@implementation GYPostData (main)


//发送信息
+(void) PostInfomationWithDic:(NSMutableDictionary *)bodyDic UrlPath:(NSString *)UrlPath Handler:(PostDataHandler)handler
{
    //    [bodyDic setObject:[GYToolKit GetUUID] forKey:@"deviceId"];
    [bodyDic setObject:@"json" forKey:@"format"];
    if ([UserInfo share].isLogin) {
        [bodyDic setObject:[UserInfo share].uId forKey:@"uid"];
    }
    
    NSString * signStr = [GYToolKit GetSignWithBody:bodyDic];
    [bodyDic setObject:signStr forKey:@"signs"];
    NSMutableString * URLStr = [[NSMutableString alloc] initWithString:Main_Url];
    [URLStr appendFormat:@"%@",UrlPath];
    NSLog(@"%@",bodyDic);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:URLStr]];
    //去除数据中的null
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = YES;
    manager.responseSerializer = response;
    
    manager.requestSerializer.timeoutInterval = 20.0f;
    //    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"UUURL:%@",URLStr);
    //    NSLog(@"%@",[GYToolKit dictionaryToJsonStr:bodyDic]);
    [manager POST:URLStr parameters:bodyDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str = [GYToolKit dictionaryToJsonStr:responseObject];
        
        NSLog(@"成功%@",str);
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        
        NSDictionary *jsonMessage = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        
        //踢出操作
        if ([jsonMessage[@"code"]integerValue] == 60001 && [UserInfo share].isLogin == YES) {
            
            [SVProgressHUD showWithString:@"登陆超时,请重新登陆"];
            [UserInfo share].isLogin = NO;
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loginOrQuitSuccess" object:nil];
            [GYToolKit pushLoginVC];
            return;
        }
        
        handler(jsonMessage,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showWithString:@"服务器连接失败"];
        
        NSLog(@"error:%@",error.description);
        handler(nil,error);
    }];
    
}
//Get发送信息
+(void) GetInfomationWithDic:(NSMutableDictionary *)bodyDic UrlPath:(NSString *)UrlPath Handler:(PostDataHandler)handler{
    [bodyDic setObject:@"json" forKey:@"format"];
    
    if ([UserInfo share].isLogin) {
        [bodyDic setObject:[UserInfo share].uId forKey:@"uid"];
    }
    
    NSString * signStr = [GYToolKit GetSignWithBody:bodyDic];
    [bodyDic setObject:signStr forKey:@"signs"];
    
    NSString * filterStr = [GYToolKit dictionaryToPostStr:bodyDic];
    NSString * UrlStr = [NSString stringWithFormat:@"%@%@",UrlPath,filterStr];
    
    NSString * endStr = [GYToolKit URLEncode:UrlStr];
    
    NSMutableString * URLStr = [[NSMutableString alloc] initWithString:Main_Url];
    [URLStr appendFormat:@"%@",endStr];
    
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:URLStr]];
    //去除数据中的null
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = YES;
    manager.responseSerializer = response;
    
    manager.requestSerializer.timeoutInterval = 10.0f;
    
    //    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSLog(@"GETUUUUUUU:%@",URLStr);
    
    [manager GET:URLStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSString *str = [GYToolKit dictionaryToJsonStr:responseObject];
        
        //        if (str.length < 50) {
        //            return ;
        //        }
        NSLog(@"成功%@",str);
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSDictionary *jsonMessage = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        
        //踢出操作
        if ([jsonMessage[@"code"]integerValue] == 60001 && [UserInfo share].isLogin == YES) {
            
            [SVProgressHUD showWithString:@"登陆超时,请重新登陆"];
            [UserInfo share].isLogin = NO;
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loginOrQuitSuccess" object:nil];
            
            [GYToolKit pushLoginVC];
            
            //如果当前选择了我的页面
            if ([URLStr containsString:JMainRoot]) {
                [GYPostData performSelector:@selector(goHomeVC) withObject:nil afterDelay:1.0];
            }
            
            return;
        }
        
        
        handler(jsonMessage,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showWithString:@"服务器连接失败"];
        
        NSLog(@"error:%@",error.description);
        handler(nil,error);
    }];
}
//发送图片
+(void) PostImgsWithDic:(NSMutableDictionary *)bodyDic ImgsArr:(NSMutableArray *)imgsArr UrlPath:(NSString *)UrlPath Handler:(PostDataHandler)handler
{
    //    [bodyDic setObject:[GYToolKit GetUUID] forKey:@"deviceId"];
    
    if ([UserInfo share].token != nil && !bodyDic[@"token"]) {
        [bodyDic setObject:[UserInfo share].token forKey:@"token"];
    }
    
    NSMutableString * URLStr = [[NSMutableString alloc] initWithString:Main_Url];
    [URLStr appendFormat:@"%@",UrlPath];
    NSLog(@"%@",UrlPath);
    NSLog(@"%@",bodyDic);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:URLStr]];
    //    [manager setSecurityPolicy:[GYToolKit customSecurityPolicy]];
    manager.requestSerializer.timeoutInterval = 10.0f;
    //    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"UUURL:%@",URLStr);
    
    [manager POST:URLStr parameters:bodyDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (UIImage * img in imgsArr) {
            
            NSInteger index = [imgsArr indexOfObject:img];
            NSString * name = [NSString stringWithFormat:@"card[]%ld.jpg",index];
            NSData* fileData = UIImageJPEGRepresentation(img, 0.7);
            [formData appendPartWithFileData:fileData name:@"card[]"
                                    fileName:name
                                    mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [GYToolKit dictionaryToJsonStr:responseObject];
        
        NSLog(@"成功%@",str);
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSDictionary *jsonMessage = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        
        handler(jsonMessage,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showWithString:@"服务器连接失败"];
        
        NSLog(@"error:%@",error.description);
        handler(nil,error);
    }];
}
+(void) GetQRCodeInfomationWithHeaderUrl:(NSString *)headerUrl UrlPath:(NSString *)urlPath Handler:(PostDataHandler)handler{
    NSMutableString * URLStr = [[NSMutableString alloc] initWithString:headerUrl];
    [URLStr appendFormat:@"%@",urlPath];
    
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:URLStr]];
    //    [manager setSecurityPolicy:[GYToolKit customSecurityPolicy]];
    manager.requestSerializer.timeoutInterval = 10.0f;
    //    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSLog(@"GETUUUUUUU:%@",URLStr);
    
    [manager GET:URLStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str = [GYToolKit dictionaryToJsonStr:responseObject];
        
        //        if (str.length < 50) {
        //            return ;
        //        }
        NSLog(@"成功%@",str);
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSDictionary *jsonMessage = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        
        handler(jsonMessage,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showWithString:@"服务器连接失败"];
        
        NSLog(@"error:%@",error.description);
        handler(nil,error);
    }];
}
+(void)GetFastInfomationWithUrlPath:(NSString *)UrlPath bodyUrl:(NSString *)bodyUrl Handler:(PostDataHandler)handler{
    NSMutableString * URLStr = [[NSMutableString alloc] initWithString:Main_Url];
    [URLStr appendFormat:@"%@",UrlPath];
    [URLStr appendFormat:@"%@",bodyUrl];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:URLStr]];
    
    //去除数据中的null
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = YES;
    manager.responseSerializer = response;
    manager.requestSerializer.timeoutInterval = 10.0f;
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSLog(@"GETUUUUUUU:%@",URLStr);
    
    [manager GET:URLStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str = [GYToolKit dictionaryToJsonStr:responseObject];
        
        //        if (str.length < 50) {
        //            return ;
        //        }
        NSLog(@"成功%@",str);
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSDictionary *jsonMessage = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        
        handler(jsonMessage,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showWithString:@"服务器连接失败"];
        
        NSLog(@"error:%@",error.description);
        handler(nil,error);
    }];
}

//验证内购
+(void) PostIAPWithDic:(NSDictionary *)bodyDic UrlPath:(NSString *)UrlPath Handler:(PostDataHandler)handler
{
    //    [bodyDic setObject:[GYToolKit GetUUID] forKey:@"deviceId"];
    
    
    NSMutableString * URLStr = [[NSMutableString alloc] initWithString:UrlPath];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:URLStr]];
    //    [manager setSecurityPolicy:[GYToolKit customSecurityPolicy]];
    manager.requestSerializer.timeoutInterval = 10.0f;
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSLog(@"UUURL:%@",URLStr);
    [manager POST:URLStr parameters:bodyDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        NSString *str = [GYToolKit dictionaryToJsonStr:responseObject];
        
        NSLog(@"成功%@",str);
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        
        
        NSDictionary *jsonMessage = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        
        
        handler(jsonMessage,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showWithString:@"服务器连接失败"];
        
        NSLog(@"error:%@",error.description);
        handler(nil,error);
    }];
    
}
//对接金十
+(void) PostCalendarWithDic:(NSDictionary *)bodyDic UrlPath:(NSString *)UrlPath Handler:(PostDataHandler)handler
{
    
    NSMutableString * URLStr = [[NSMutableString alloc] initWithString:Main_Url];
    [URLStr appendFormat:@"%@",UrlPath];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:URLStr]];
    //去除数据中的null
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = YES;
    manager.responseSerializer = response;
    manager.requestSerializer.timeoutInterval = 15.0f;
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSLog(@"UUURL:%@",URLStr);
    NSLog(@"%@",bodyDic);
    [manager POST:URLStr parameters:bodyDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str = [GYToolKit dictionaryToJsonStr:responseObject];
        
        NSLog(@"成功%@",str);
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        
        
        NSDictionary *jsonMessage = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        
        
        handler(jsonMessage,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showWithString:@"服务器连接失败"];
        
        NSLog(@"error:%@",error.description);
        handler(nil,error);
    }];
    
}

//获取k线列表数据
+(void)GetStockDataWithUrlPath:(NSString *)UrlPath Handler:(PostDataHandler)handler{
    
    NSString * URLStr = @"https://www.figurefinance.com/klines";
    
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    NSLog(@"%@",UrlPath);
    NSString * aesStr= [GYAES encryptUseAES:UrlPath key:@"6461772803150152" iv:@"8105547186756005"];
    
    [bodyDic setObject:aesStr forKey:@"urls"];
    
    //    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:URLStr]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.baseURL = [NSURL URLWithString:URLStr];
    manager.requestSerializer.timeoutInterval = 10.0f;
    
    NSLog(@"%@",bodyDic);
    
    NSLog(@"POSTUUUUUUU:%@",URLStr);
    [manager POST:URLStr parameters:bodyDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str = [GYToolKit dictionaryToJsonStr:responseObject];
        
        NSLog(@"成功%@",str);
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        
        NSDictionary *jsonMessage = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        if ([jsonMessage[@"code"] integerValue]==4001) {
            [SVProgressHUD showWithString:@"服务器连接失败"];
            return;
        }
        
        handler(jsonMessage,nil);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //这个表示取消
        if (error.code != -999) {
            [SVProgressHUD showWithString:@"服务器连接失败"];
            
            NSLog(@"error:%@",error.description);
            handler(nil,error);
        }
    }];
    
}
//获取k线详情数据
+(void)GetStockKLineDataWithUrlPath:(NSString *)UrlPath Handler:(PostDataHandler)handler{
    
    NSString * URLStr = @"https://www.figurefinance.com/klines";
    
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    
    NSString * aesStr= [GYAES encryptUseAES:UrlPath key:@"6461772803150152" iv:@"8105547186756005"];
    
    [bodyDic setObject:aesStr forKey:@"urls"];
    
    //    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:URLStr]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager shareManager];
    //    manager.baseURL = [NSURL URLWithString:URLStr];
    manager.requestSerializer.timeoutInterval = 10.0f;
    
    //    NSLog(@"%@",bodyDic);
    //    NSLog(@"POSTUUUUUUU:%@",URLStr);
    [manager POST:URLStr parameters:bodyDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str = [GYToolKit dictionaryToJsonStr:responseObject];
        
        //        NSLog(@"成功%@",str);
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        
        NSDictionary *jsonMessage = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        if ([jsonMessage[@"code"] integerValue]==4001) {
            [SVProgressHUD showWithString:@"服务器连接失败"];
            return;
        }
        
        handler(jsonMessage,nil);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //这个表示取消
        if (error.code != -999) {
            [SVProgressHUD showWithString:@"服务器连接失败"];
            
            NSLog(@"error:%@",error.description);
            handler(nil,error);
        }
    }];
    
}
//获取巴比特的区块链数据
+(void) PostBBTInfoWithDic:(NSMutableDictionary *)bodyDic UrlPath:(NSString *)UrlPath Handler:(PostDataHandler)handler
{
    //    [bodyDic setObject:[GYToolKit GetUUID] forKey:@"deviceId"];
    
    
    
    NSMutableString * URLStr = [[NSMutableString alloc] initWithString:Main_Url];
    [URLStr appendFormat:@"%@",UrlPath];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    NSLog(@"线程个数:%ld",manager.tasks.count);
    //去除数据中的null
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = YES;
    manager.responseSerializer = response;
    
    manager.requestSerializer.timeoutInterval = 20.0f;
    //    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"UUURL:%@",URLStr);
    NSLog(@"%@",bodyDic);
    [manager POST:URLStr parameters:bodyDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str = [GYToolKit dictionaryToJsonStr:responseObject];
        
        NSLog(@"成功%@",str);
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        
        id jsonMessage = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        
        
        handler(jsonMessage,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showWithString:@"服务器连接失败"];
        NSLog(@"error:%@",error.description);
        handler(nil,error);
        
    }];
    
}
//获取巴比特的区块链K线数据
+(void)PostBBTKDataInfoWithDic:(NSMutableDictionary *)bodyDic UrlPath:(NSString *)UrlPath Handler:(PostDataHandler)handler
{
    //    [bodyDic setObject:[GYToolKit GetUUID] forKey:@"deviceId"];
    
    
    
    NSMutableString * URLStr = [[NSMutableString alloc] initWithString:Main_Url];
    [URLStr appendFormat:@"%@",UrlPath];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager shareManager];
    
    
    NSLog(@"线程个数:%ld",manager.tasks.count);
    //去除数据中的null
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = YES;
    manager.responseSerializer = response;
    
    manager.requestSerializer.timeoutInterval = 20.0f;
    //    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //    NSLog(@"UUURL:%@",URLStr);
    //    NSLog(@"%@",bodyDic);
    [manager POST:URLStr parameters:bodyDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str = [GYToolKit dictionaryToJsonStr:responseObject];
        
        NSLog(@"成功%@",str);
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        
        id jsonMessage = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        
        
        handler(jsonMessage,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code != -999) {
            [SVProgressHUD showWithString:@"服务器连接失败"];
            NSLog(@"error:%@",error.description);
            handler(nil,error);
        }
    }];
    
}
//发送比特币
+(void) GetBTCDic:(NSMutableDictionary *)bodyDic UrlPath:(NSString *)UrlPath Handler:(PostDataHandler)handler
{
    
    NSMutableString * URLStr = [[NSMutableString alloc] initWithString:@""];
    [URLStr appendFormat:@"%@",UrlPath];
    //    NSLog(@"%@",bodyDic);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager shareManager];
    //去除数据中的null
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = YES;
    manager.responseSerializer = response;
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.requestSerializer.timeoutInterval = 20.0f;
    
    
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    [manager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    //    [manager.requestSerializer setValue:@"Yes" forHTTPHeaderField:@"Kept Alive"];
    //    [manager.requestSerializer setValue:@"/192.168.1.112" forHTTPHeaderField:@"Client Address"];
    //    [manager.requestSerializer setValue:@"app.blockmeta.com/183.131.214.106" forHTTPHeaderField:@"Remote Address"];
    //    [manager.requestSerializer setValue:@"e554508fdd333ba0bffd791cddb897f3a198d279" forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"from"];
    
    
    //    [manager.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //    [manager.requestSerializer setValue:@"https://wechatx.34580.com/activitys/egg/" forHTTPHeaderField:@"Referer"];
    //    [manager.requestSerializer setValue:@"zh-cn" forHTTPHeaderField:@"Accept-Language"];
    
    
    NSLog(@"%@",bodyDic);
    
    NSLog(@"UUURL:%@",URLStr);
    [manager GET:URLStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str = [GYToolKit dictionaryToJsonStr:responseObject];
        NSLog(@"%@",str);
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSDictionary *jsonMessage = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        
        handler(jsonMessage,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        NSLog(@"error:%@",error.description);
        handler(nil,error);
    }];
    
}
//Get启动广告
+(void) GetAdvertInfoWithDic:(NSMutableDictionary *)bodyDic UrlPath:(NSString *)UrlPath Handler:(PostDataHandler)handler{
    
    NSMutableString * URLStr = [[NSMutableString alloc] initWithString:Main_Url];
    [URLStr appendFormat:@"%@",UrlPath];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:URLStr]];
    //去除数据中的null
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = YES;
    manager.responseSerializer = response;
    
    manager.requestSerializer.timeoutInterval = 5.0f;
    
    //    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSLog(@"GETUUUUUUU:%@",URLStr);
    
    [manager GET:URLStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSString *str = [GYToolKit dictionaryToJsonStr:responseObject];
        NSLog(@"成功%@",str);
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSDictionary *jsonMessage = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        
        handler(jsonMessage,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showWithString:@"服务器连接失败"];
        
        NSLog(@"error:%@",error.description);
        handler(nil,error);
    }];
}
+(void)goHomeVC
{
    SystemNVC *nvc = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers[0];
    nvc.tabBarController.selectedIndex = 0;
}
@end

