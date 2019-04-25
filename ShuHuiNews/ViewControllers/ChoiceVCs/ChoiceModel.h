//
//  ChoiceModel.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/18.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ComListModel : NSObject

@property(nonatomic,copy)NSString * theId;
@property(nonatomic,copy)NSString * price;
//@property(nonatomic,copy)NSURL * img_info;
@property(nonatomic,copy)NSURL * img;
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * publish;
@property(nonatomic,copy)NSString * author;
@property(strong, nonatomic) NSArray *extendInfo;
@property(strong, nonatomic) NSDictionary *userInfo;
@end

@interface ChoiceBookModel : NSObject

@property(nonatomic,copy)NSString * category_name;
@property(nonatomic,copy)NSString * category_id;

@property (strong, nonatomic) NSArray * comList;
@end


@interface ChoiceBannerModel : NSObject

@property(nonatomic,copy)NSString * theId;
@property(nonatomic,copy)NSString * book_id;
@property(nonatomic,copy)NSString * href_url;
//@property(nonatomic,copy)NSURL * image_url;

@property(nonatomic,copy)NSURL * banner;
@property(nonatomic,copy)NSString * title;

@end

@interface ChoiceModel : NSObject

@property (strong, nonatomic) NSArray * banner;
@property (strong, nonatomic) NSArray * book_list;

@end

@interface ExtendModel : NSObject

@property (strong,nonatomic) NSString*  price;
@property (strong,nonatomic) NSString*  type;


@end

@interface UserInfoModel : NSObject

@property (strong,nonatomic) NSString*  userId;
@property (strong,nonatomic) NSString*  nickname;
@property (strong,nonatomic) NSString*  userAvatar;
@property (strong,nonatomic) NSString*  fens_num;

@end


