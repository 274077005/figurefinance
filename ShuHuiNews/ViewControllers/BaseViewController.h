//
//  BaseViewController.h
//  Qianyuandai
//
//  Created by 耿一 on 2017/10/18.
//  Copyright © 2017年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;

- (void)createTableView;
- (void)postDataSucceed;
-(void)navGoBack;

//创建黑色风格的导航栏
- (void)createBlackNavStyle;
@end
