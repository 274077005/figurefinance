//
//  SubmitOrderVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/25.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "SubmitOrderModel.h"
#import "SubmitAddressTVCell.h"
#import "SNoAdTVCell.h"
#import "SBookTVCell.h"
#import "AddAddressVC.h"
#import "AddressListVC.h"
#import "DlgPayWayV.h"
#import "OrderListVC.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
@interface SubmitOrderVC : BaseViewController<AddressDelegate>



@property (weak, nonatomic) IBOutlet UIView *holdBV;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property(nonatomic,copy)NSString * bookId;
@property(nonatomic,strong)SubmitNumModel * numModel;

@property(nonatomic,strong)SubmitOrderModel * orderModel;

@property(nonatomic,strong)DlgPayWayV * payV;

//是否从书籍列表页过来的
@property(nonatomic,assign)BOOL moreListToHere;



@end
