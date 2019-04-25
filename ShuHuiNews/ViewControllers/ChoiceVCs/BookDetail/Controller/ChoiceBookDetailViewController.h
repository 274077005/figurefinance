//
//  ChoiceBookDetailViewController.h
//  ShuHuiNews
//
//  Created by ding on 2019/4/11.
//  Copyright © 2019年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 书籍详情
 */

@interface ChoiceBookDetailViewController : UIViewController
//id
@property (copy,nonatomic)NSString *bookId;
//类型
@property (assign,nonatomic)NSInteger type;
@end


