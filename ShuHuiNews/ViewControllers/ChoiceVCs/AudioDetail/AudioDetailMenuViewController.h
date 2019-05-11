//
//  AudioDetailMenuViewController.h
//  ShuHuiNews
//
//  Created by zhaowei on 2019/4/25.
//  Copyright © 2019 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWOrderDetailViewController.h"
#import "GYUrlSession.h"

NS_ASSUME_NONNULL_BEGIN

@interface AudioDetailMenuViewController : UITableViewController
@property (nonatomic, assign) BOOL vcCanScroll;
@property (nonatomic,strong) UIViewController *VC;
@property (nonatomic,strong) NSArray *dataAry;
@property (nonatomic,strong) NSDictionary *dataDict;
@end

NS_ASSUME_NONNULL_END
