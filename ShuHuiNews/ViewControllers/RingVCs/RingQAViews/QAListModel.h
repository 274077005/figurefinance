//
//  QAListModel.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/14.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EvaluationModel : NSObject

@property (copy,nonatomic) NSString * theId;
@property (copy,nonatomic) NSURL * image;
@property (copy,nonatomic) NSString * nickname;


@end
@interface AnswersModel : NSObject

@property (copy,nonatomic) NSString * eval;
@property (copy,nonatomic) NSString * created_at;
@property (copy,nonatomic) NSString * eval_id;
@property (copy,nonatomic) NSString * theId;
@property (copy,nonatomic) NSString * isParise;
@property (copy,nonatomic) NSString * user_id;
@property (copy,nonatomic) NSString * delivery_id;
@property (copy,nonatomic) NSString * num;
@property (nonatomic,assign)CGFloat cellHeight;

@property (strong, nonatomic) EvaluationModel * evaler;

@end


@interface QAUserModel : NSObject

@property (copy,nonatomic) NSString * theId;
@property (copy,nonatomic) NSURL * image;
@property (copy,nonatomic) NSString * nickname;

@end


@interface QATypeModel : NSObject

@property (copy,nonatomic) NSString * theId;
@property (copy,nonatomic) NSString * name;

@end


@interface QAListModel : NSObject
@property (copy,nonatomic) NSString * end_time;
@property (copy,nonatomic) NSString * answers_count;
@property (copy,nonatomic) NSString * theId;
@property (copy,nonatomic) NSString * price;
@property (copy,nonatomic) NSString * created_at;
@property (copy,nonatomic) NSString * question;
@property (copy,nonatomic) NSString * user_id;
@property (copy,nonatomic) NSString * place;
@property (copy,nonatomic) NSString * isCollect;
@property (copy,nonatomic) NSString * share_link;


@property (strong, nonatomic) QATypeModel * type;

@property (strong, nonatomic) QAUserModel * user;


@property (strong, nonatomic) NSArray * answers;



@end
