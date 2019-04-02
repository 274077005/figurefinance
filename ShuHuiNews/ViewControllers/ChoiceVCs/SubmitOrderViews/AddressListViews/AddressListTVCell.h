//
//  AddressListTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/26.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubmitOrderModel.h"
#import "EditAddressVC.h"
@interface AddressListTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@property(nonatomic,strong)SAddressModel * addModel;
-(void)updateWithModel;

@end
