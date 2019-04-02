//
//  CalendarModel.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/9.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarModel : NSObject

@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * country;
@property(nonatomic,copy)NSString * datename;
@property(nonatomic,copy)NSString * consensus;
@property(nonatomic,copy)NSString * previous;
@property(nonatomic,copy)NSString * timestr;
@property(nonatomic,copy)NSString * status_class;
@property(nonatomic,copy)NSString * dataname;
@property(nonatomic,copy)NSString * time_show;
@property(nonatomic,copy)NSString * dataId;
@property(nonatomic,copy)NSString * star;
@property(nonatomic,copy)NSString * status_name;
@property(nonatomic,copy)NSString * yingxiang;
@property(nonatomic,copy)NSString * unit;
@property(nonatomic,copy)NSString * publictime;
@property(nonatomic,copy)NSString * actual;
@property(nonatomic,copy)NSString * datanameId;

@property(nonatomic,assign)CGFloat cellHeight;
@end
