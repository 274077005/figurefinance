//
//  HomeViewController.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/9.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "HomeMenuModel.h"

@interface ChainMarketVC : BaseViewController<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,GYTimerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;

@property (weak, nonatomic) IBOutlet UIScrollView *menuScrollV;

@property (nonatomic,strong)UICollectionView * collectionV;


@end
