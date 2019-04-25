//
//  ChoiceVideoDetailViewController.h
//  ShuHuiNews
//
//  Created by ding on 2019/4/19.
//  Copyright © 2019年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 视频详情
 */
@interface ChoiceVideoDetailViewController : UIViewController
@property (nonatomic,copy)NSString *url;
//id
@property (copy,nonatomic)NSString *bookId;
//类型
@property (assign,nonatomic)NSInteger type;
@end

NS_ASSUME_NONNULL_END
