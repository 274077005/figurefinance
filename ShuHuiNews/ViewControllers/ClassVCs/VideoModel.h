//
//  VideoModel.h
//  Treasure
//
//  Created by zzw on 2017/1/18.
//  Copyright © 2017年 GY. All rights reserved.
//

#import "JSONModel.h"
@protocol VideoModel <NSObject>


@end
@interface VideoModel : JSONModel
@property (nonatomic,copy)NSString * nameId;
@property (nonatomic,strong)NSURL * backgroud_img;
@property (nonatomic,copy)NSString * creater;
@property (nonatomic,copy)NSString * level_name;
@property (nonatomic,copy)NSString * play_times;
@property (nonatomic,copy)NSString * scene_id;
@property (nonatomic,copy)NSString * scene_name;
@property (nonatomic,copy)NSString * teacher_id;
@property (nonatomic,copy)NSString * teacher_name;
@property (nonatomic,copy)NSString * title;
@property (nonatomic,strong)NSURL * video_url;
@property (nonatomic,copy)NSString * video_time_length;
@property (nonatomic,copy)NSString * teacher_intr;
@property (nonatomic,strong)NSURL * teacher_img;
@end
