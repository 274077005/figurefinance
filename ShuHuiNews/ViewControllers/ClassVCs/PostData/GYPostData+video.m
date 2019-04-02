//
//  GYPostData+video.m
//  Treasure
//
//  Created by zzw on 2017/1/17.
//  Copyright © 2017年 GY. All rights reserved.
//

#import "GYPostData+video.h"
#import "teacherNameAndSceneModles.h"
#import "VideoModels.h"
#import "VideoModel.h"
@implementation GYPostData (video)


+ (void)getTeacherNameAndScene:(PostDataHandler)handler{
    NSString * version = @"11.1";
    NSString * deviceType = @"iPhone8";
    NSString * deviceFrame = [NSString stringWithFormat:@"%f*%f",SCREEN_WIDTH,SCREEN_HEIGHT];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"GetAllTags",@"act",@"ios",@"os",deviceType,@"dt",version,@"dv",@"123456",@"token",deviceFrame,@"ss",@"123456",@"uid", nil];
    // NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"MemberReg",@"act", nil];
    
    NSMutableString * URLStr = [[NSMutableString alloc] initWithString:VIDEO_PRO];
    NSString * str = [GYToolKit dictionaryToJsonStr:dic];
    
    NSString * strh =[GYDes encode:str key:@"aBcDE#G0"];
    [URLStr appendFormat:@"?h=%@",strh];

    [[GYURLConnection defaultSession]accessServerWithURLStr:URLStr HTTPBody:nil Handler:^(NSData* data, NSError * error) {
        if (!error) {
            NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString * message = [GYDes decode:str key:@"aBcDE#G0"];
            if (!message) {
                [SVProgressHUD showWithString:@"网络故障"];
                return ;
            }
            NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary * jsonMessage = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
           

            
            if (jsonMessage[@"d"]) {
            teacherNameAndSceneModles * model = [[teacherNameAndSceneModles alloc] initWithDictionary:jsonMessage[@"d"] error:nil];
                handler(model,nil);
            }else{
                            NSLog(@"error:%@",error);
            }
        }else{
           
            handler(nil,error);
        }
    }];


}

+(void)getVideoListWith:(NSDictionary *)messageDic handler:(PostDataHandler)handler{
    
    NSString * version = @"11.1";
    NSString * deviceType = @"iPhone8";
    NSString * deviceFrame = [NSString stringWithFormat:@"%f*%f",SCREEN_WIDTH,SCREEN_HEIGHT];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"GetVideoPageList",@"act",@"ios",@"os",deviceType,@"dt",version,@"dv",@"123456",@"token",deviceFrame,@"ss",@"123456",@"uid", nil];
    // NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"MemberReg",@"act", nil];
    
    NSMutableString * URLStr = [[NSMutableString alloc] initWithString:VIDEO_PRO];
    NSString * str = [GYToolKit dictionaryToJsonStr:dic];
    
    NSString * strh =[GYDes encode:str key:@"aBcDE#G0"];
    [URLStr appendFormat:@"?h=%@",strh];
    
    NSString * str2 = [GYToolKit dictionaryToJsonStr:messageDic];
    
    NSString * str10 =[GYDes encode:str2 key:@"aBcDE#G0"];
    [URLStr appendFormat:@"&p=%@",str10];
    [[GYURLConnection defaultSession]accessServerWithURLStr:URLStr HTTPBody:nil Handler:^(NSData* data, NSError * error) {
        if (!error) {
            NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString * message = [GYDes decode:str key:@"aBcDE#G0"];
            if (!message) {
                [SVProgressHUD showWithString:@"网络故障"];
                return ;
            }
            NSLog(@"%@",message);
            
            NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary * jsonMessage = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
            
           
            if (jsonMessage[@"d"]) {
                VideoModels * v = [[VideoModels alloc] initWithDictionary:jsonMessage[@"d"] error:nil];
                handler(v.d,error);
            }else{
                NSLog(@"error:%@",error);
            }
        }else{
            handler(nil,error);
        }
    }];


}


+(void)getVideoDetailsWith:(NSDictionary*)messageDic handler:(PostDataHandler)handler{

    NSString * version = @"11.1";
    NSString * deviceType = @"iPhone8";
    NSString * deviceFrame = [NSString stringWithFormat:@"%f*%f",SCREEN_WIDTH,SCREEN_HEIGHT];

    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"GetVideoInfo",@"act",@"ios",@"os",deviceType,@"dt",version,@"dv",@"123456",@"token",deviceFrame,@"ss",@"123456",@"uid", nil];
    // NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"MemberReg",@"act", nil];
    
    NSMutableString * URLStr = [[NSMutableString alloc] initWithString:VIDEO_PRO];
    NSString * str = [GYToolKit dictionaryToJsonStr:dic];
    
    NSString * strh =[GYDes encode:str key:@"aBcDE#G0"];
    [URLStr appendFormat:@"?h=%@",strh];
    
    NSString * str2 = [GYToolKit dictionaryToJsonStr:messageDic];
    
    NSString * str10 =[GYDes encode:str2 key:@"aBcDE#G0"];
    [URLStr appendFormat:@"&p=%@",str10];
    [[GYURLConnection defaultSession]accessServerWithURLStr:URLStr HTTPBody:nil Handler:^(NSData* data, NSError * error) {
        if (!error) {
            NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString * message = [GYDes decode:str key:@"aBcDE#G0"];
            if (!message) {
                [SVProgressHUD showWithString:@"网络故障"];
                return ;
            }
            NSLog(@"%@",message);
            NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary * jsonMessage = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
            
           
            if (jsonMessage[@"d"]) {
                NSDictionary * d = jsonMessage[@"d"];
                NSMutableArray * arr = [[NSMutableArray alloc] init];
                
                VideoModel * m = [[VideoModel alloc] initWithDictionary:d[@"main"] error:nil];
                [arr addObject:m];
                
                VideoModels * v = [[VideoModels alloc] initWithDictionary:d[@"rele"] error:nil];
               
                
                [arr addObjectsFromArray:v.d];
                handler(arr,error);
            }else{
                NSLog(@"error:%@",error);
            }
        }else{
            handler(nil,error);
        }
    }];


}


+ (void)postVideoPalyWith:(NSDictionary*)messageDic{


    NSString * version = @"11.1";
    NSString * deviceType = @"iPhone8";
    NSString * deviceFrame = [NSString stringWithFormat:@"%f*%f",SCREEN_WIDTH,SCREEN_HEIGHT];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"UpdateVideoPlayTimes",@"act",@"ios",@"os",deviceType,@"dt",version,@"dv",@"123456",@"token",deviceFrame,@"ss",@"123456",@"uid", nil];
    // NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"MemberReg",@"act", nil];
    
    NSMutableString * URLStr = [[NSMutableString alloc] initWithString:VIDEO_PRO];
    NSString * str = [GYToolKit dictionaryToJsonStr:dic];
    
    NSString * strh =[GYDes encode:str key:@"aBcDE#G0"];
    [URLStr appendFormat:@"?h=%@",strh];
    
    NSString * str2 = [GYToolKit dictionaryToJsonStr:messageDic];
    
    NSString * str10 =[GYDes encode:str2 key:@"aBcDE#G0"];
    [URLStr appendFormat:@"&p=%@",str10];
    [[GYURLConnection defaultSession]accessServerWithURLStr:URLStr HTTPBody:nil Handler:^(NSData* data, NSError * error) {
        if (!error) {
            NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString * message = [GYDes decode:str key:@"aBcDE#G0"];
            if (!message) {
                [SVProgressHUD showWithString:@"网络故障"];
                return ;
            }
            
//            NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary * jsonMessage = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
            
        }else{
          
        }
    }];

}
@end
