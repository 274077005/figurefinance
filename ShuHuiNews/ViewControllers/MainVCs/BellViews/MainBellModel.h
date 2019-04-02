//
//  MainBellModel.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/23.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainBellModel : NSObject
@property(nonatomic,copy)NSURL * img;
@property(nonatomic,copy)NSString * theId;
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSString * author;
@property(nonatomic,copy)NSString * updated_at;
@property(nonatomic,assign)CGFloat cellHeight;

@end
