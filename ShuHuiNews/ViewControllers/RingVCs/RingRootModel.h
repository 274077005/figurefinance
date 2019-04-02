//
//  RingRootModel.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/26.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface RingTagModel : NSObject

@property(nonatomic,copy)NSString * f_id;
@property(nonatomic,copy)NSString * theId;
@property(nonatomic,copy)NSString * f_id2;
@property(nonatomic,copy)NSString * created_at;
@property(nonatomic,copy)NSString * remember_token;
@property(nonatomic,copy)NSString * type;
@property(nonatomic,copy)NSString * kind;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * updated_at;
@end

@interface RingListModel : NSObject

@property(nonatomic,copy)NSString * theId;
@property(nonatomic,copy)NSString * num;
@property(nonatomic,copy)NSString * nickname;
@property(nonatomic,copy)NSURL * image;
@property(nonatomic,copy)NSString * attestation_audit;
@property(nonatomic,copy)NSString * attestation_tag;

@end

@interface RingRootModel : NSObject


@property (strong, nonatomic) NSArray * person;
@property (strong, nonatomic) NSArray * person_tag;
@property (strong, nonatomic) NSArray * company;
@property (strong, nonatomic) NSArray * company_tag;
@end

//记录状态的模型
@interface RingStatusModel : NSObject

@property(nonatomic,assign)BOOL personAll; //用来记录是否是展开状态
@property(nonatomic,assign)BOOL companyAll;
@property(nonatomic,copy)NSString * sCompanyTag;
@property(nonatomic,copy)NSString * sCompanyId;
@property(nonatomic,copy)NSString * sPersonTag;
@property(nonatomic,copy)NSString * sPersonId;
@property(nonatomic,copy)NSString * menuId;
@end




