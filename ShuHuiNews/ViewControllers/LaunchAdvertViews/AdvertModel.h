//
//  AdvertModel.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/28.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdvertModel : NSObject

@property(nonatomic,copy)NSString * is_show;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSURL * pic_url;
@property(nonatomic,copy)NSString * href_url;
@property(nonatomic,copy)NSString * auth_id;

@end
