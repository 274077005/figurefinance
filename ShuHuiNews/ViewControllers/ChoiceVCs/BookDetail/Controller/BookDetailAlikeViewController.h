//
//  BookDetailAlikeViewController.h
//  ShuHuiNews
//
//  Created by ding on 2019/4/12.
//  Copyright © 2019年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN
//相似作品
@interface BookDetailAlikeViewController : UITableViewController
@property (nonatomic, assign) BOOL vcCanScroll;
@property (nonatomic,strong) UIViewController *VC;
@end

NS_ASSUME_NONNULL_END
