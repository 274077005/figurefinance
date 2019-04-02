//
//  BookDetailModel.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/24.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookBannerModel : NSObject

@property(nonatomic,copy)NSURL * img_url;

@end

@interface BookDetailModel : NSObject
@property(nonatomic,copy)NSString * theId;
@property(nonatomic,copy)NSString * category_id;
@property(nonatomic,copy)NSString * price;
@property(nonatomic,copy)NSString * category_name;
@property(nonatomic,copy)NSString * is_display;
@property(nonatomic,copy)NSString * publish;
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSString * author;
@property(nonatomic,copy)NSString * name;

@property (strong, nonatomic) NSArray * img_info;
@end
