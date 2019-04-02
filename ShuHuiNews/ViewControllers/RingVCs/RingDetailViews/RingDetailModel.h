//
//  RingDetailModel.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/3.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainCenterModel.h"




@interface RDCommentModel : NSObject


//监管信息
@property(nonatomic,copy)NSString * theId;
@property(nonatomic,copy)NSString * image;
@property(nonatomic,copy)NSString * auth_id;
@property(nonatomic,copy)NSString * nickname;
@property(nonatomic,copy)NSString * comment;
@property(nonatomic,copy)NSString * comment_auth;
@property(nonatomic,copy)NSString * hits;
@property(nonatomic,copy)NSString * created_at;
@property(nonatomic,copy)NSString * replyName;
@property (copy,nonatomic)NSString * is_praise;
@property(nonatomic,assign)CGFloat cellHeight;

@end


@interface DetailArrModel : NSObject

//评分
@property(nonatomic,copy)NSString * company_name;
@property(nonatomic,copy)NSString * score;

//联系方式
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * content;

//网址
@property(nonatomic,copy)NSString * company_url;
@property(nonatomic,copy)NSString * type;

//监管信息
@property(nonatomic,copy)NSString * theId;
@property(nonatomic,copy)NSString * logo_url;
@property(nonatomic,copy)NSString * supervision_number;
@property(nonatomic,copy)NSString * modular;
@property(nonatomic,copy)NSString * institution_phone;
@property(nonatomic,copy)NSString * institution_address;
@property(nonatomic,copy)NSString * institution_url;
@property(nonatomic,copy)NSString * start_time;
@property(nonatomic,copy)NSString * institution_email;
@property(nonatomic,copy)NSString * institution;
@property(nonatomic,copy)NSString * certificate;
@property(nonatomic,copy)NSString * agency_name;
@property(nonatomic,copy)NSString * end_time;
@property(nonatomic,copy)NSString * license_type;
@property(nonatomic,copy)NSString * agency;
@property(nonatomic,copy)NSString * status;



@end

@interface RingUserModel : NSObject
@property(nonatomic,assign)NSInteger news_type;
@property(nonatomic,copy)NSString * image;
@property(nonatomic,copy)NSString * nickname;
@property(nonatomic,copy)NSString * auth_id;
@property(nonatomic,copy)NSString * company_establish_time;
@property(nonatomic,copy)NSString * company_country;
@property(nonatomic,copy)NSString * is_collection;
    
@end



@interface RingDetailModel : NSObject
@property(nonatomic,assign)NSInteger news_type;
@property(nonatomic,copy)NSString * image;
@property(nonatomic,copy)NSString * nickname;
@property(nonatomic,copy)NSString * auth_id;
@property(nonatomic,copy)NSString * company_establish_time;
@property(nonatomic,copy)NSString * company_country;
@property(nonatomic,copy)NSString * is_collection;
@property(nonatomic,copy)NSString * level;
@property(nonatomic,copy)NSString * overall;
@property (nonatomic,copy) NSString * attestation_tag;
@property (nonatomic,copy) NSString * desc;
@property(nonatomic,assign)NSInteger sex;
@property(nonatomic,copy)NSString * attestation_job;
@property (nonatomic,copy) NSString * attestation_company;
@property (nonatomic,copy) NSString * attestation_name;

@property(nonatomic,assign)CGFloat cellHeight;

@property (strong, nonatomic) NSArray * gradeArr;
@property (strong, nonatomic) NSArray * relationArr;
@property (strong, nonatomic) NSArray * urlArr;
@property (strong, nonatomic) NSArray * regulationArr;
@property (strong, nonatomic) NSArray * environmentArr;
@property (strong, nonatomic) NSArray * advertArr;
@property (strong, nonatomic) NSArray * commentArr;


@end
