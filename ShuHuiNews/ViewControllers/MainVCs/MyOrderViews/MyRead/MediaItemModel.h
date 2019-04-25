//
//  MediaItemModel.h
//  ShuHuiNews
//
//  Created by ding on 2019/4/3.
//  Copyright © 2019年 耿一. All rights reserved.
//

#import "DXLModel.h"
/*我的订购-我的订阅*/
@class MediaItemBookTypeModel;

@interface MediaItemModel : DXLModel
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *count;
@property (nonatomic,strong) NSString *playCount;
@property (nonatomic,strong) NSString *timeCount;

@property (nonatomic,assign) NSInteger id;
@property (nonatomic,copy)   NSString *uid;
@property (nonatomic,assign) NSInteger book_id;
@property (nonatomic, copy)  NSString *status;
@property (nonatomic,strong) NSDictionary *bookInfo;
@property (nonatomic,strong) NSArray <MediaItemBookTypeModel *> *bookType;

@end
@interface BookInfoModel : NSObject

@property (nonatomic,assign) NSInteger id;
@property (nonatomic, copy)  NSString  *name;
@property (nonatomic, copy)  NSString  *img;
@property (nonatomic,assign) NSInteger uid;
@property (nonatomic, copy)  NSString  *author;
@property (nonatomic,assign) NSInteger click_num;

@end

@interface MediaItemBookTypeModel : NSObject
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger book_id;
@property (nonatomic, copy)  NSString *price;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic, copy)  NSString *created_at;
@property (nonatomic, copy)  NSString *updated_at;
@property (nonatomic,assign) NSInteger status;

@end

