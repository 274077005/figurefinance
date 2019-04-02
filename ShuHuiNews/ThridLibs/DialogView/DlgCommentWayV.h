//
//  DlgCommentWayV.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/16.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "DialogView.h"

@interface DlgCommentWayV : DialogBase



@property(nonatomic,copy)void(^submitBlock)(NSString * handleStr);
@end
