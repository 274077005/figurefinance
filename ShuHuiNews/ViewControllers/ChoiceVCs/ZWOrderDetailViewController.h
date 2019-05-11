//
//  ZWOrderDetailViewController.h
//  ShuHuiNews
//
//  Created by zhaowei on 2019/4/20.
//  Copyright © 2019 耿一. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^PaySuccessBlock)(void);

@interface ZWOrderDetailViewController : UITableViewController

@property (strong,nonatomic)NSDictionary *dataDict;
@property (strong,nonatomic)NSDictionary *bookDict;
@property (strong,nonatomic)NSString *price;
@property (retain,nonatomic)UIButton *payButton;
@property (copy,nonatomic)PaySuccessBlock paySuccessBlock;
@end

NS_ASSUME_NONNULL_END
