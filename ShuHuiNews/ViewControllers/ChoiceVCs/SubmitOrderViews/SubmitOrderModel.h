//
//  SubmitOrderModel.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/25.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SBookModel : NSObject
@property(nonatomic,copy)NSString * author;
@property(nonatomic,copy)NSString * theId;
@property(nonatomic,copy)NSString * category_id;
@property(nonatomic,copy)NSString * price;
@property(nonatomic,copy)NSString * category_name;
@property(nonatomic,copy)NSURL * img_info;
@property(nonatomic,copy)NSString * is_display;
@property(nonatomic,copy)NSString * publish;
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSString * name;
@end

@interface SAddressModel : NSObject
@property(nonatomic,copy)NSString * theId;
@property(nonatomic,copy)NSString * telephone;
@property(nonatomic,copy)NSString * user_id;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * is_default;
@property(nonatomic,copy)NSString * city;
@property(nonatomic,copy)NSString * address;
@end
@interface SubmitOrderModel : NSObject

@property (strong, nonatomic) SBookModel * book_detail;

@property (strong, nonatomic) SAddressModel * address_detail;

@end


@interface SubmitNumModel : NSObject

@property (assign, nonatomic) NSInteger bookNum;



@end

