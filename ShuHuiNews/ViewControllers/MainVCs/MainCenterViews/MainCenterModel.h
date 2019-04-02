//
//  MainCenterModel.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/21.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CenterAgencyModel : NSObject
@property(nonatomic,copy)NSString * theId;
@property(nonatomic,copy)NSString * logo_url;
@property(nonatomic,copy)NSString * agency_name;
@end

@interface CenterAdvertModel : NSObject
@property(nonatomic,copy)NSString * ad_url;
@property(nonatomic,copy)NSString * theId;
@property(nonatomic,copy)NSString * modular;
@property(nonatomic,copy)NSString * ad_name;
@property(nonatomic,copy)NSString * ad_link;
@end

@interface CenterAttestationModel : NSObject
@property(nonatomic,copy)NSString * attestation_job;
@property(nonatomic,copy)NSString * attestation_company;
@property(nonatomic,copy)NSString * attestation_card;
@property(nonatomic,copy)NSString * attestation_name;
@end

@interface CenterTagInfoModel : NSObject
@property(nonatomic,copy)NSString * attestation_tag;

@end



@interface TheCompanyModel : NSObject
@property(nonatomic,copy)NSString * type;
@property(nonatomic,copy)NSString * company_url;
@end


@interface CenterCompanyModel : NSObject
@property(nonatomic,copy)NSString * attestation_name;
@property(nonatomic,copy)NSString * start_date;
@property(nonatomic,copy)NSString * company_country;
@property (strong, nonatomic) NSArray * urls;

@end


@interface TheEnvironmentModel : NSObject

@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * content;

@end


@interface CenterEnvironmentModel : NSObject
@property(nonatomic,copy)NSString * theId;
@property(nonatomic,copy)NSString * account;
@property (strong, nonatomic) NSArray * content;
@end



@interface CenterRegulationModel : NSObject
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

@interface CenterContactModel : NSObject

@property(nonatomic,copy)NSString * email;
@property(nonatomic,copy)NSString * phone;
@property(nonatomic,copy)NSString * wechat;
@property(nonatomic,copy)NSString * modular;

@end

@interface CenterBasicModel : NSObject

@property(nonatomic,copy)NSString * modular;
@property(nonatomic,copy)NSString * qr_code;
@property(nonatomic,copy)NSString * nickname;
@property(nonatomic,copy)NSString * image;
@property(nonatomic,copy)NSString * industry_name;
@property(nonatomic,copy)NSString * desc;
@property(nonatomic,copy)NSString * attestation_type;
@property(nonatomic,assign)NSInteger sex;
@end

@interface MainCenterModel : NSObject

@property (strong, nonatomic) CenterBasicModel * basic;

@property (strong, nonatomic) CenterContactModel * contact;
@property (strong, nonatomic) CenterCompanyModel * company_info;
@property (strong, nonatomic) CenterTagInfoModel * attestation_tag;
@property (strong, nonatomic) CenterAttestationModel * attestation_card;
@property (strong, nonatomic) CenterAttestationModel * attestation;
@property (strong, nonatomic) NSArray * regulatory;

@property (strong, nonatomic) NSArray * environment;

@property (strong, nonatomic) NSArray * ad;

@property (strong, nonatomic) NSArray * allAgency; //所有监管机构

//交易环境的一些标识
@property(nonatomic,assign)CGFloat environmentCH;
@property(nonatomic,assign)BOOL readEnv;
@end
