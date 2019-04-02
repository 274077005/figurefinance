//
//  OrderListVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/30.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderListModel.h"
#import "OrderListTVCell.h"
#import "ChoiceListVC.h"
@interface OrderListVC : BaseViewController


@property(nonatomic,strong)OrderListModel * listModel;

//是否从书籍列表页过来的
@property(nonatomic,assign)BOOL moreListToHere;

@end
