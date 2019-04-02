//
//  StockDetailModel.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/6/21.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockDetailModel : NSObject


//id
@property (copy,nonatomic) NSString * theId;
//请求用的
@property (copy,nonatomic) NSString * key;
//显示的英文名字
@property (copy,nonatomic) NSString * keyRemark;

@property (copy,nonatomic) NSString * keyWord;
//名称
@property (copy,nonatomic) NSString * name;
//现在买入价
@property (copy,nonatomic) NSString * buy;
//现在的售价
@property (copy,nonatomic) NSString * sell;
//开盘价
@property (copy,nonatomic) NSString * open;
//最高价
@property (copy,nonatomic) NSString *top;
//最低价
@property (copy,nonatomic) NSString *low;

//涨跌幅
@property (copy,nonatomic) NSString * margin;

//涨跌幅
@property (copy,nonatomic) NSString * mp;

//昨日收盘价
@property (copy,nonatomic) NSString *lastClose;
//总量
@property (copy,nonatomic) NSString * volume;

//更新时间
@property (copy,nonatomic) NSString * time;
//日期
@property (copy,nonatomic) NSString * date;
//买入量
@property (copy,nonatomic) NSString * buyV;
//卖出量
@property (copy,nonatomic) NSString * sellV;
//总交易量
@property (copy,nonatomic) NSString * bothV;
//总成交量
@property (copy,nonatomic) NSString * dealV;
//国际名称
@property (copy,nonatomic) NSString * code;

//最新价
@property (copy,nonatomic) NSString * nowP;

//结算价
@property (copy,nonatomic) NSString * clearP;

//行情日期
@property (copy,nonatomic) NSString * stockDate;

//行情时间
@property (copy,nonatomic) NSString * stockTime;

//按位与
@property (copy,nonatomic) NSString * AND;

//颜色
@property (copy,nonatomic) NSString *color;
//未知名称
@property (copy,nonatomic) NSString * code2;
@end
