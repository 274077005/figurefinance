//
//  ChainDetailModel.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/15.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTickerModel : NSObject

@property (assign,nonatomic) CGFloat volume;
@property (assign,nonatomic) CGFloat date;
@property (assign,nonatomic) CGFloat high;
@property (assign,nonatomic) CGFloat last;
@property (assign,nonatomic) CGFloat low;
@property (assign,nonatomic) CGFloat buy;
@property (assign,nonatomic) CGFloat sell;
@property (assign,nonatomic) CGFloat price_24h_before;

@end




@interface ChainDetailModel : NSObject
@property (strong, nonatomic) CTickerModel * ticker;

@property (copy,nonatomic) NSString * fee;
@property (copy,nonatomic) NSString * name;
@property (copy,nonatomic) NSString * exchange;
@property (copy,nonatomic) NSString * currency;
@property (assign,nonatomic) CGFloat convert_cny;
@property (copy,nonatomic) NSString * key;
@property (copy,nonatomic) NSString * url;
@property (copy,nonatomic) NSString * coin;
@property (assign,nonatomic) CGFloat chinaP; //人民币价格
@property (assign,nonatomic) CGFloat mp; //涨跌百分比

@end
