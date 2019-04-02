//
//  GYStockKPIModel.m
//  Treasure
//
//  Created by 蓝蓝色信子 on 2017/3/20.
//  Copyright © 2017年 GY. All rights reserved.
//

#import "GYStockKPIModel.h"

@implementation GYStockKPIModel

-(id)init
{
    //调用父类的init方法进行初始化，将初始化得到的对象赋值给self对象
    //如果self对象不为nil，表明父类init方法初始化成功
    if (self = [super init]) {
        self.MA1 = 5;
        self.MA2 = 10;
        self.MA3 = 20;
        
        self.BOLL1 = 20;
        self.BOLL2 = 2;
        
        self.ENV1 = 14;
        
        self.MACD1 = 12;
        self.MACD2 = 26;
        self.MACD3 = 9;
        
        self.RSI1 = 6;
        self.RSI2 = 12;
        self.RSI3 = 24;
        
        self.KDJ1 = 9;
        self.KDJ2 = 3;
        self.KDJ3 = 3;
        
        self.WR1 = 14;
    }
    return self;
}
@end
