//
//  CenterTagInfoTVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/22.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCenterModel.h"
@interface CenterTagInfoTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;
@property (weak, nonatomic) IBOutlet UIView *shadowBV;
@property(nonatomic,strong)MainCenterModel * centerModel;
-(void)updateWithModel;
@end
