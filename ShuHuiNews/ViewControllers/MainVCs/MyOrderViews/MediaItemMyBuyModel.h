//
//  MediaItemMyBuyModel.h
//  ShuHuiNews
//
//  Created by ding on 2019/4/10.
//  Copyright © 2019年 耿一. All rights reserved.
//

#import "DXLModel.h"
/*我的订购-我的购买*/

@class UserInfoModel,MediaItemMyBuyBookDetailModel;

@interface MediaItemMyBuyModel : DXLModel
@property (nonatomic,assign) NSInteger uid;
@property (nonatomic,assign) NSInteger book_id;
@property (nonatomic,strong) UserInfoModel *userInfo;
@property (nonatomic,strong) NSArray <MediaItemMyBuyBookDetailModel *>*bookDetail;
@end

@interface UserInfoModel : NSObject
@property (nonatomic,assign) NSInteger id;
@property (nonatomic, copy)  NSString *nickname;
@property (nonatomic, copy)  NSString *image;
@property (nonatomic,assign) NSInteger fens_num;
@property (nonatomic, copy)  NSString *sign;
@property (nonatomic,assign) NSInteger balance;

@end

@interface MediaItemMyBuyBookDetailModel :NSObject

@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger book_id;
@property (nonatomic, copy)  NSString *price;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic, copy)  NSString *created_at;
@property (nonatomic, copy)  NSString *updated_at;
@property (nonatomic,assign) NSInteger status;

@end

