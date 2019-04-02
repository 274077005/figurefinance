//
//  FHVideoView.h
//  video
//
//  Created by zzw on 2017/1/12.
//  Copyright © 2017年 zzw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "teacherNameAndSceneModles.h"
#import "UIScrollView+EmptyDataSet.h"
typedef void (^playVideo) (NSString*,NSURL*,NSString*);
@interface FHVideoView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UIButton *newestBtn;
@property (weak, nonatomic) IBOutlet UIButton *fieryBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectedViewHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *videoCollectionVIew;
@property (weak, nonatomic) IBOutlet UICollectionView *persionNameCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *otherCollectionView;

@property (weak, nonatomic) IBOutlet UIView *selectedBgView;
@property (copy, nonatomic) playVideo block;

@property (copy, nonatomic) NSMutableArray * dataSourceArr;
- (void)setting;
@end
