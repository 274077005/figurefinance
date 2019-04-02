//
//  MainRootModel.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/19.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainRootModel : NSObject

@property(nonatomic,copy)NSString * nickname;
@property(nonatomic,copy)NSURL * image;
@property(nonatomic,copy)NSString * attent_num;
@property(nonatomic,copy)NSString * collect_num;
@property(nonatomic,copy)NSString * comment_num; //粉丝

@end
