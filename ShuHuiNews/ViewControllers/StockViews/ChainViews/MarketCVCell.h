//
//  HomeCVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/9.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketListV.h"

@interface MarketCVCell : UICollectionViewCell


@property (nonatomic,strong)MarketListV * listV;

- (void)createContentView;

@property(nonatomic,copy)NSString * theId;
-(void)getData;
@end
