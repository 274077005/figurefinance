//
//  GYPostData+video.h
//  Treasure
//
//  Created by zzw on 2017/1/17.
//  Copyright © 2017年 GY. All rights reserved.
//

#import "GYPostData.h"
#import "YYNetHeader.h"
#import "GYDes.h"
@interface GYPostData (video)

//获取老师姓名和标签
+ (void)getTeacherNameAndScene:(PostDataHandler)handler;
//获取视频列表
+(void)getVideoListWith:(NSDictionary *)messageDic handler:(PostDataHandler)handler;
//获取视频详情
+(void)getVideoDetailsWith:(NSDictionary*)messageDic handler:(PostDataHandler)handler;
//统计播放次数
+ (void)postVideoPalyWith:(NSDictionary*)messageDic;
@end
