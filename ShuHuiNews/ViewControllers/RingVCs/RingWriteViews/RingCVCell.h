//
//  HomeCVCell.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/9.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RingRootV.h"

@interface RingCVCell : UICollectionViewCell


@property (nonatomic,strong)RingRootV * recommendV;
- (void)createContentView;

@property(nonatomic,copy)NSString * theId;

@property(nonatomic,assign)NSInteger cellIndex;
@end
