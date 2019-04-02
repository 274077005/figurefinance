//
//  FlashModel.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/9/12.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FlashImgsModel : NSObject

@property(nonatomic,copy)NSURL * imgurl;

@property(nonatomic,copy)NSString * width;

@property(nonatomic,copy)NSString * height;
@end

@interface FlashModel : NSObject

@property(nonatomic,copy)NSString * theId;
@property(nonatomic,copy)NSString * is_praise;
@property(nonatomic,copy)NSString * origin_link;
@property(nonatomic,assign)NSInteger timestamp;
@property(nonatomic,copy)NSString * addtime;
@property(nonatomic,copy)NSString * minutes;
@property(nonatomic,copy)NSString * flash_type;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * auth_id;
@property(nonatomic,copy)NSURL * image;
@property(nonatomic,copy)NSString * hits;
@property(nonatomic,copy)NSString * content;

@property (strong, nonatomic) NSArray * imageArr;

@property(nonatomic,assign)CGFloat cellHeight;




@end
