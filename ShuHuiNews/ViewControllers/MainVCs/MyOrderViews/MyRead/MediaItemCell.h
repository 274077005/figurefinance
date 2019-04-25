//
//  MediaItemCell.h
//  ShuHuiNews
//
//  Created by ding on 2019/4/3.
//  Copyright © 2019年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaItemModel.h"
#import "MediaItemMyBuyModel.h"
//相似作品
//#import "BookDetailAlikeModel.h"
NS_ASSUME_NONNULL_BEGIN
/*我的订购-我的购买/我的订阅*/
@interface MediaItemCell : UITableViewCell
@property (nonatomic,strong) MediaItemModel *model;
@property (nonatomic,strong) MediaItemMyBuyModel *buyModel;
//@property (nonatomic,strong) BookDetailAlikeModel *alikeModel;
@property (nonatomic, copy) void(^cancelButtonClickedBlock)(void);
@end

NS_ASSUME_NONNULL_END
