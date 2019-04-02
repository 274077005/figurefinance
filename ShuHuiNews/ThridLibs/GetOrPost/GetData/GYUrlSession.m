//
//  YYUrlSession.m
//  Treasure
//
//  Created by 耿一 on 16/4/6.
//  Copyright © 2016年 GY. All rights reserved.
//

#import "GYUrlSession.h"

@implementation GYUrlSession

{

}
-(instancetype)init
{
    if (self = [super init]) {
        //实例化_session
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        //session对象
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    }
    return self;
}

//单例对象
+(GYUrlSession *)defaultSession
{
    static GYUrlSession * session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [[GYUrlSession alloc] init];
    });
    return session;
}

#pragma mark - 接口方法 -
//访问服务器
-(void)accessServerWithURLStr:(NSString *)urlStr Handler:(NetHandler)handler
{
    //url字符串utf8编码
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //创建request
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    request.HTTPMethod = @"GET";
//    [request setValue:fieldArray.firstObject forHTTPHeaderField:@"User-Agent"];
//    
//    [request setValue:fieldArray.lastObject forHTTPHeaderField:@"authorization"];
    //访问服务器
    NSURLSessionDataTask * dataTask = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //这里拿到服务器的返回结果，在这里返回
        //返回主线程
        dispatch_async(dispatch_get_main_queue(),^{
            //这里是主线程
            if(handler){
                handler(data,error);
            }
        });
    }];
    [dataTask resume];
}


@end
