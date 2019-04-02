//
//  YYGetData+Main.m
//  Finance
//
//  Created by 耿一 on 2017/9/6.
//  Copyright © 2017年 GY. All rights reserved.
//

#import "YYGetData+Main.h"

@implementation YYGetData (Main)



+(void)getVerifyNumWithPhoneNum:(NSString *)phoneNum Handler:(GetDataHandler)handler{

    
    NSString * URLStr = @"https://raw.githubusercontent.com/lanlansexinzi/GYTest111/master/qianqian.txt";
    [[GYUrlSession defaultSession] accessServerWithURLStr:URLStr Handler:^(NSData *data, NSError *error) {
        if (!error) {
            
            NSString * message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"获取验证码:%@",message);
            NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonMessage = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
            
            handler(jsonMessage,error);
            
            
        }else{
            handler(nil,error);
            
            NSLog(@"获取验证码:error:%@",error);
            
        }
    }];
}

@end
