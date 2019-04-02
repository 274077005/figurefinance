//
//  RedactColumnVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/16.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "RedactTVCell.h"
#import "HomeMenuModel.h"
#import "RedactCVCell.h"
#import <AudioToolbox/AudioToolbox.h>
@interface RedactColumnVC : BaseViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet UILabel *moveLab;
@property (weak, nonatomic) IBOutlet UIView *titleBV;

@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CVHeight;
@property (weak, nonatomic) IBOutlet UIView *allTabBV;

@property(nonatomic,strong)NSArray * homeArr;
@property (weak, nonatomic) IBOutlet UITableView *firstTabV;
@property (weak, nonatomic) IBOutlet UITableView *secondTabV;
@property (weak, nonatomic) IBOutlet UITableView *thridTabV;
@property (nonatomic,copy)NSDictionary * jsonDic;

@property(nonatomic,copy)void(^submitBlock)(void);

@property(nonatomic,strong)UIView * snapMoveCell; //截图cell 用于移动
@property(nonatomic,strong)NSIndexPath * originalIndexPath; //手指所在的cell indexPath
@property(nonatomic,strong)NSIndexPath * moveIndexPath ; //可替换的cell indexPath
@property(nonatomic,assign)CGPoint lastPoint ; //手指所在cell 的Point

@end
