//
//  VideoDetailModel.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/16.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface VNewsModel : NSObject

@property (copy,nonatomic) NSString * theId;
@property (copy,nonatomic) NSString * recycle;
@property (copy,nonatomic) NSString * keywords;
@property (copy,nonatomic) NSString * name;
@property (copy,nonatomic) NSString * issue;
@property (copy,nonatomic) NSString * is_pay;
@property (copy,nonatomic) NSString * type_name;
@property (copy,nonatomic) NSString * class3id;
@property (copy,nonatomic) NSString * head_portrait;
@property (copy,nonatomic) NSString * updatetime;
@property (copy,nonatomic) NSString * title;
@property (copy,nonatomic) NSString * imgurl;
@property (copy,nonatomic) NSString * news_type;
@property (copy,nonatomic) NSString * praise_num;
@property (copy,nonatomic) NSString * auth_id;
@property (copy,nonatomic) NSString * content;
@property (copy,nonatomic) NSString * description_type;
@property (copy,nonatomic) NSString * class1name;
@property (copy,nonatomic) NSString * class2name;
@property (copy,nonatomic) NSString * class3name;
@property (copy,nonatomic) NSString * href_url;
@property (copy,nonatomic) NSString * duration;
//@property (copy,nonatomic) NSString * count;
@property (copy,nonatomic) NSString * comment_count;
@property (copy,nonatomic) NSString * is_attention;
@property (copy,nonatomic) NSString * is_praise;
@property (copy,nonatomic) NSString * is_collection;


@property(nonatomic,assign)BOOL isShowMore; //是否显示更多状态

@property(nonatomic,assign)CGFloat contentHeight;

@property(nonatomic,assign)BOOL canShowMore; //是否超过一行能否显示更多

@end

@interface VCommentModel : NSObject
@property (copy,nonatomic) NSString * c_id;
@property (copy,nonatomic) NSString * comment_content;
@property (copy,nonatomic) NSString * user_id;
@property (copy,nonatomic) NSString * updatetime;
@property (copy,nonatomic) NSString * nickname;
@property (copy,nonatomic) NSString * image;
@property (copy,nonatomic) NSString * user_f_id;
@property (copy,nonatomic) NSString * user_f_name;
@property (copy,nonatomic) NSString * praise_num;
@property (copy,nonatomic) NSString * is_praise;
@property(nonatomic,assign)CGFloat strHeight;

@end

@interface VCorrelationModel : NSObject
@property (copy,nonatomic) NSString * type_name;
@property (copy,nonatomic) NSString * theId;
@property (copy,nonatomic) NSString * head_portrait;
@property (copy,nonatomic) NSString * updatetime;
@property (copy,nonatomic) NSString * title;
@property (copy,nonatomic) NSString * imgurl;
@property (copy,nonatomic) NSString * content;
@property (copy,nonatomic) NSString * issue;
@property (copy,nonatomic) NSString * datetime;
@property (copy,nonatomic) NSString * time;
@property (copy,nonatomic) NSString * href_url;

@end

@interface VideoDetailModel : NSObject

@property (strong, nonatomic) VNewsModel * news;

@property (strong, nonatomic) NSArray * comment;
@property (strong, nonatomic) NSArray * correlation;

@property (copy,nonatomic) NSString * link;
@property (copy,nonatomic) NSString * share_img;

@end
