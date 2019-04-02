//
//  ReplyMeModel.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/22.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EvalerModel : NSObject


@property(nonatomic,copy)NSString * theId;
@property(nonatomic,copy)NSURL * image;
@property(nonatomic,copy)NSString * nickname;

@end

@interface DeliveryModel : NSObject


@property(nonatomic,copy)NSString * theId;

@property(nonatomic,copy)NSString * question;


@property(nonatomic,strong)EvalerModel * user;

@end






@interface ReplyMeModel : NSObject

@property(nonatomic,copy)NSString * eval;
@property(nonatomic,copy)NSString * theId;
@property(nonatomic,copy)NSString * created_at;
@property(nonatomic,copy)NSString * eval_id;
@property(nonatomic,copy)NSString * delivery_id;


@property(nonatomic,assign)CGFloat cellHeight;

@property (strong, nonatomic) EvalerModel * evaler;
@property (strong, nonatomic) DeliveryModel * delivery;


@end
