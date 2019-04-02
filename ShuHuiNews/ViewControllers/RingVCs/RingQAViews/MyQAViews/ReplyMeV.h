//
//  ReplyMeV.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/21.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReplyMeModel.h"
@interface ReplyMeV : UIView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;


@property(nonatomic,copy)NSString * replyType;

@end
