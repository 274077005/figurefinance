//
//  YYGetData+Main.h
//  Finance
//
//  Created by 耿一 on 2017/9/6.
//  Copyright © 2017年 GY. All rights reserved.
//

#import "YYGetData.h"

@interface YYGetData (Main)
//获取验证码
+(void)getVerifyNumWithPhoneNum:(NSString *)phoneNum Handler:(GetDataHandler)handler;

@end
