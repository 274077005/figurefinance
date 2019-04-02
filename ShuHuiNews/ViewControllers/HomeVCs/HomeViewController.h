//
//  HomeViewController.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/9.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "HomeMenuModel.h"
#import "RedactColumnVC.h"
#import "BubbleView.h"
#import "AddFlashVC.h"
#import "ActivityApplyVC.h"
#import "ScanQRCodeVC.h"
#import "MainQRCardVC.h"
#import "HomeSearchVC.h"
@interface HomeViewController : BaseViewController<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;

@property (weak, nonatomic) IBOutlet UIScrollView *menuScrollV;

@property (nonatomic,strong)UICollectionView * collectionV;

@property(nonatomic,strong)NSArray * bubbleArr;
@end
