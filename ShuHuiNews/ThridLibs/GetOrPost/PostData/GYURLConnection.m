//
//  ZZWUrlSession.m
//  ZZWFashionShows
//
//  Created by qianfeng on 16/1/14.
//  Copyright © 2016年 zhuzhiwen. All rights reserved.
//

#import "GYURLConnection.h"
#import "GYToolKit.h"

@implementation GYURLConnection
{
    NSURLSession * _session;

}
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    }
    return self;
}
+ (GYURLConnection*)defaultSession{

    static GYURLConnection * session;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [[GYURLConnection alloc] init];
    });
    
    return session;
}


- (void)accessServerWithURLStr:(NSString*)urlStr HTTPBody:(NSDictionary*)bodyDic Handler:(NetHandler)handler{
    
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    request.HTTPMethod = @"POST";
    NSString *parseParamsResult = [self parseParams:bodyDic];
    
    NSData * dataData = [parseParamsResult dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = dataData;

    
    NSURLSessionDataTask *  datatask = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (handler) {  
                handler(data,error);
            }
            
        });
    }];
    [datatask resume];
}

#pragma mark - 接口方法 -
- (void)accessServerWithURLStr:(NSString*)urlStr HeaderFieldArray:(NSArray *)fieldArray HTTPBody:(NSDictionary*)body Handler:(NetHandler)handler{
    
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    

    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    request.HTTPMethod = @"POST";
    NSString *parseParamsResult = [self parseParams:body];

    NSData * data1 = [parseParamsResult dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data1;

    [request setValue:fieldArray.firstObject forHTTPHeaderField:@"User-Agent"];
    
    [request setValue:fieldArray.lastObject forHTTPHeaderField:@"authorization"];
    NSURLSessionDataTask *  datatask = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
     
        
        dispatch_async(dispatch_get_main_queue(), ^{
         
            if (handler) {
                handler(data,error);
            }
            
        });
    }];
    [datatask resume];
}
- (void)accessServerWithURLStr:(NSString*)urlStr HeaderFieldArray:(NSArray *)fieldArray HTTPJsonStr:(NSString*)jsonStr Handler:(NetHandler)handler
{
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    request.HTTPMethod = @"POST";

    NSString *parseParamsResult = [GYToolKit URLEncode:jsonStr];

    NSData * data1 = [parseParamsResult dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data1;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:fieldArray.firstObject forHTTPHeaderField:@"User-Agent"];

    [request setValue:fieldArray.lastObject forHTTPHeaderField:@"authorization"];
    
    NSURLSessionDataTask *  datatask = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (handler) {
                handler(data,error);
            }
            
        });
    }];
    [datatask resume];
}
//把NSDictionary解析成post格式的NSString字符串
- (NSString *)parseParams:(NSDictionary *)params{
    NSMutableArray *result = [NSMutableArray new];
    
    for (NSString * key in params) {
        NSString * keyAndValue = [NSString stringWithFormat:@"%@=%@",key,[params valueForKey:key]];
        [result addObject:keyAndValue];
    }
    return [result componentsJoinedByString:@"&"];

}

@end
