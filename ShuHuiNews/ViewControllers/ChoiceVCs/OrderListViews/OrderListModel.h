//
//  OrderListModel.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/30.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderListModel : NSObject


@property(nonatomic,copy)NSString * theId;
@property(nonatomic,copy)NSString * delivery_id;
@property(nonatomic,copy)NSString * book_id;
@property(nonatomic,copy)NSString * number;
@property(nonatomic,copy)NSString * total_price;
@property(nonatomic,copy)NSString * status;
@property(nonatomic,copy)NSString * created_at;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * author;
@property(nonatomic,copy)NSString * price;
@property(nonatomic,copy)NSURL * img_info;
@property(nonatomic,copy)NSString * publish;

@end
