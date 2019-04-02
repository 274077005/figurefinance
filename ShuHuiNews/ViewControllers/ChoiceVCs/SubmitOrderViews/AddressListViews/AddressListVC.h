//
//  AddressListVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/26.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "AddressListTVCell.h"
#import "SubmitOrderModel.h"
#import "AddAddressVC.h"

@protocol AddressDelegate <NSObject>

@optional
- (void)selectAddressWithModel:(SAddressModel *)adModel;
@end
@interface AddressListVC : BaseViewController

@property (weak, nonatomic) IBOutlet UIView *addBV;

@property(nonatomic,copy)NSString * selectId;




@property (nonatomic,assign)id<AddressDelegate> delegate;
@end
