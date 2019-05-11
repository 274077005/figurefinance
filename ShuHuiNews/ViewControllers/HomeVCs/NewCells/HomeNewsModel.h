//
//  HomeNewsModel.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/10.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HQListModel : NSObject

@property(nonatomic,copy)NSString * question;
@property(nonatomic,copy)NSString * theId;
@property(nonatomic,copy)NSString * price;
@property(nonatomic,copy)NSString * datetime;
@property(nonatomic,copy)NSString * nickname;
@property(nonatomic,copy)NSString * type_name;
@property(nonatomic,copy)NSString * num;

@end



@interface ColumnListModel : NSObject

@property(nonatomic,copy)NSString * type_name;
@property(nonatomic,copy)NSString * auth_id;
@property(nonatomic,copy)NSURL * head_portrait;
@property(nonatomic,copy)NSString * updatetime;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSURL * imgurl;
@property(nonatomic,assign)NSInteger news_type;
@property(nonatomic,copy)NSString * content;
@property(nonatomic,assign)NSInteger top_ok;
@property(nonatomic,copy)NSString * issue;


@end

@interface ImgListModel : NSObject

@property (copy,nonatomic) NSString * img_id;
@property (copy,nonatomic) NSURL * imgurl;
@property (copy,nonatomic) NSString * explain;
@property (assign,nonatomic) NSInteger sort;

@property (copy,nonatomic) NSString * uid;
@property (copy,nonatomic) NSString * news_id;
@property (copy,nonatomic) NSString * created_at;
@property (copy,nonatomic) NSString * updated_at;


@end


@interface HomeNewsModel : NSObject

@property(nonatomic,copy)NSString * theId;
@property(nonatomic,copy)NSString * type_name;
@property(nonatomic,copy)NSString * auth_id;
@property(nonatomic,copy)NSURL * head_portrait;
@property(nonatomic,copy)NSString * updatetime;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSURL * imgurl;
@property(nonatomic,assign)NSInteger news_type;
@property(nonatomic,assign)NSInteger banner_type;
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSString * noNetContent;
@property(nonatomic,assign)NSInteger top_ok;
@property(nonatomic,copy)NSString * issue;
@property(nonatomic,copy)NSString * datetime;
@property(nonatomic,copy)NSString * href_url;
@property(nonatomic,copy)NSString * duration;
@property(nonatomic,copy)NSString * price;
@property(nonatomic,copy)NSString * answer_count;


@property(nonatomic,assign)CGFloat cellHeight;
@property (strong, nonatomic) NSArray * images;
@property (strong, nonatomic) NSArray * columnist;
@property (strong, nonatomic) NSArray * question;
@end

@interface HomeBannerModel : NSObject


@property(nonatomic,copy)NSString * news_id;
@property(nonatomic,copy)NSURL * image_url;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * href_url;
@property(nonatomic,assign)NSInteger news_type;

@end

@interface HomeAuthorModel : NSObject


@property(nonatomic,copy)NSString * works_id;
@property(nonatomic,copy)NSURL * img;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * author;
@property(nonatomic,assign)NSInteger click_num;

@end

