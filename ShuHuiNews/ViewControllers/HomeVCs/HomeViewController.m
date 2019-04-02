//
//  HomeViewController.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/9.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCVCell.h"
@interface HomeViewController ()
{
    //滚动视图的item数组
    NSMutableArray *_itemArray;
    //用于记录每个按钮的偏移量
    NSMutableArray *_itemInfoArray;
    //按钮数组
    NSMutableArray *_buttonArray;
    //滚动视图上的线视图
    UIView *_lineView;
    //记录下每个item按钮的长度
    NSMutableArray * _itemWithArray;

    //记录滚动视图的长度
    float _totalWidth;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.topHeight.constant = StatusBarHeight;
    [self judgeAdvertClick];
    _itemArray = [[NSMutableArray alloc]init];
    [self createCollectionView];
//    NSLog(@"%f",[UIApplication sharedApplication].windows[0].safeAreaInsets.bottom);
//    if ([UIApplication sharedApplication].windows[0].safeAreaInsets.bottom != 0) {
//        NSLog(@"有刘海");
//
//    }else{
//        NSLog(@"没刘海");
//    }

    
    
    
    [self initializeData];
    [self getMenuData];
    
    [self createBubbleView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMenuData) name:@"loginOrQuitSuccess" object:nil];
    
//    SystemNVC *nvc = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers[3];
//    nvc.title = @"未登录";

    // Do any additional setup after loading the view from its nib.
}
-(void)createBubbleView
{
   
    // Do any additional setup after loading the view.
    WeakSelf;
    BubbleAction *action = [BubbleAction actionWithTitle:@"栏目定制" image:IMG_Name(@"bubbleReduct") handler:^(BubbleAction *action) {
        if (![UserInfo share].isLogin) {
            [GYToolKit pushLoginVC];
            return;
        }
        RedactColumnVC * redactVC = [[RedactColumnVC alloc]init];
        
        redactVC.submitBlock = ^{
            [weakSelf getMenuData];
        };
        redactVC.homeArr = _itemArray;
        [self.navigationController pushViewController:redactVC animated:YES];
    }];
    BubbleAction *action1 = [BubbleAction actionWithTitle:@"快讯编辑" image:IMG_Name(@"bubbleFlash") handler:^(BubbleAction *action) {
        if (![UserInfo share].isLogin) {
            [GYToolKit pushLoginVC];
            return;
        }
        AddFlashVC * addVC = [[AddFlashVC alloc]init];

        [self.navigationController pushViewController:addVC animated:YES];
    }];
    BubbleAction *action2 = [BubbleAction actionWithTitle:@"活动报名" image:IMG_Name(@"bubbleActivity") handler:^(BubbleAction *action) {
        if (![UserInfo share].isLogin) {
            [GYToolKit pushLoginVC];
            return;
        }
        ActivityApplyVC * applyVC = [[ActivityApplyVC alloc]init];
        [self.navigationController pushViewController:applyVC animated:YES];
 
    }];
    BubbleAction *action3 = [BubbleAction actionWithTitle:@"扫一扫" image:IMG_Name(@"bubbleScan") handler:^(BubbleAction *action) {
        if (![UserInfo share].isLogin) {
            [GYToolKit pushLoginVC];
            return;
        }
        ScanQRCodeVC * QRVC = [[ScanQRCodeVC alloc]init];
        [self.navigationController pushViewController:QRVC animated:YES];
  
    }];
    BubbleAction *action4 = [BubbleAction actionWithTitle:@"二维码" image:IMG_Name(@"bubbleQR") handler:^(BubbleAction *action) {
        if (![UserInfo share].isLogin) {
            [GYToolKit pushLoginVC];
            return;
        }
        MainQRCardVC * QRVC = [[MainQRCardVC alloc]init];

        [self.navigationController pushViewController:QRVC animated:YES];
    }];
    BubbleAction *action5 = [BubbleAction actionWithTitle:@"帮助与反馈" image:IMG_Name(@"bubbleHelp") handler:^(BubbleAction *action) {
        BaseWebVC * webVC = [[BaseWebVC alloc]init];
        
        webVC.urlStr = [NSString stringWithFormat:@"%@zixun/opinion_feeckback",Main_Url];
        [self.navigationController pushViewController:webVC animated:YES];
    }];
    self.bubbleArr = @[action,action1,action2,action3,action4,action5];
}
-(void)judgeAdvertClick
{
    if ([UserInfo share].advertClick) {
        BaseWebVC * webVC = [[BaseWebVC alloc]init];
        webVC.urlStr = [UserInfo share].advertUrl;
        [self.navigationController pushViewController:webVC animated:NO];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = NO;
}
-(void)initializeData
{
    NSDictionary * jsonDic = [UserDefaults dictionaryForKey:@"HomeMenuDic"];
    NSArray *array = [HomeMenuModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
    [_itemArray removeAllObjects];
    [_itemArray addObjectsFromArray:array];
    if (_itemArray.count > 0) {
        [self createMenuScrollView];
    }
}
-(void)getMenuData
{
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    [GYPostData GetInfomationWithDic:bodyDic UrlPath:JHomeMenu Handler:^(NSDictionary *jsonDic, NSError * error) {
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                [UserDefaults setObject:jsonDic forKey:@"HomeMenuDic"];
                NSArray *array = [HomeMenuModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
                [_itemArray removeAllObjects];
                [_itemArray addObjectsFromArray:array];
                [self createMenuScrollView];
            }
        }
    }];
}

//建立collectionView
- (void)createCollectionView
{
    self.collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, _menuScrollV.height + StatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - TabBarHeight - _menuScrollV.height - StatusBarHeight) collectionViewLayout:[self createLayout]];
    
    self.collectionV.backgroundColor = WD_BACKCOLOR;
//    [self.collectionV registerClass:[HomeCVCell class] forCellWithReuseIdentifier:@"HomeCellId"];
    self.collectionV.showsHorizontalScrollIndicator = NO;
    self.collectionV.showsVerticalScrollIndicator = NO;
    self.collectionV.bounces = NO;
    self.collectionV.pagingEnabled = YES;
    self.collectionV.delegate = self;
    self.collectionV.dataSource = self;
    [self.view addSubview:self.collectionV];
    
}

- (UICollectionViewFlowLayout *)createLayout {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
//    layout.itemSize = itemSize;
    
    return layout;
}
- (IBAction)searchBtnClick:(UIButton *)sender {
    HomeSearchVC * searchVC = [[HomeSearchVC alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (IBAction)redactBtnClick:(UIButton *)sender {

    BubbleView *view = [BubbleView menuWithActions:self.bubbleArr width:160 relyonView:sender];
    [view show];
}

//创建菜单上的按钮
-(void)createMenuScrollView
{
    [self.menuScrollV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    _itemArray = [[NSMutableArray alloc]initWithArray:@[@"推荐",@"关注",@"外汇",@"区块链",@"互联网",@"哈哈"]];
    _itemWithArray = [[NSMutableArray alloc] init];


    _itemInfoArray = [[NSMutableArray alloc] init];
    _buttonArray = [[NSMutableArray alloc] init];
    
    //创建其他的市场按钮
    float menuWidth = 0.0;
    for (int i = 0;i<_itemArray.count; i++) {
        NSInteger itemWidth = 60;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        HomeMenuModel * menuMdeol = _itemArray[i];
        NSString *str = menuMdeol.type_name;
        NSInteger len = [menuMdeol.type_name length];
        if (len >= 3) {
            itemWidth = 80;
            if(len > 4){
                itemWidth = 100;
            }
        }
        button.frame = CGRectMake(menuWidth, 0, itemWidth, 44);
        [button setTitle:str forState:UIControlStateNormal];
        [button setTitleColor:RGBCOLOR(105, 105, 105) forState:UIControlStateNormal];
        [button setTitleColor:RGBCOLOR(31, 31, 31) forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        //button.backgroundColor = [UIColor blackColor];
        //高亮状态发光效果
        //button.showsTouchWhenHighlighted = YES;
        [button addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        
        [self.menuScrollV addSubview:button];
        
        [_itemInfoArray addObject:@(menuWidth)];
        menuWidth += itemWidth;
        
        [_buttonArray addObject:button];
        [_itemWithArray addObject:@(itemWidth)];
        
    }

    
    [self.collectionV setContentOffset:CGPointMake(0, 0)];
    _lineView = [[UIView alloc] init];
    _lineView.frame = CGRectMake(72, _menuScrollV.height -5,35, 2);
    _lineView.backgroundColor = RGBCOLOR(14, 124, 244);
    
    [self.menuScrollV addSubview:_lineView];
    self.menuScrollV.contentOffset = CGPointMake(0, 0);
    [self.collectionV reloadData];
    //避免用户第一次进来不开网 导致崩溃
    if(_buttonArray.count >0)
    {
        UIButton *button = _buttonArray [0];
        button.selected = YES;
        _totalWidth = menuWidth;
        [self.menuScrollV setContentSize:CGSizeMake(menuWidth, 30)];
        button.transform = CGAffineTransformMakeScale(1.2, 1.2);
        [self changeButtonStateAtIndex:1];
    }
    
    
    [self.collectionV setContentOffset:CGPointMake(SCREEN_WIDTH* 1 , 0)];
    
}

#pragma mark - collectionview代理方法 -

//设置collectionView的item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - TabBarHeight - _menuScrollV.height - StatusBarHeight);
    
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _itemArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeMenuModel * menuModel = _itemArray[indexPath.row];
    NSString* str = [NSString stringWithFormat:@"HomeCell%@",menuModel.theId];
    [_collectionV registerClass:[HomeCVCell class] forCellWithReuseIdentifier:str];
    HomeCVCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:str forIndexPath:indexPath];
    
    cell.theId = menuModel.theId;
    [cell createContentView];
    return cell;
}

#pragma mark - ScrollView点击事件
- (void)menuButtonClicked:(UIButton *)btn {
    [self changeButtonStateAtIndex:btn.tag];
    [self.collectionV setContentOffset:CGPointMake(SCREEN_WIDTH* btn.tag , 0)];
    //点击btn有动画效果滚动
    //    [self.collectionV setContentOffset:CGPointMake(SCREEN_WIDTH*btn.tag, 0) animated:YES];
    //NSLog(@"%f",SCREEN_WIDTH*btn.tag);
}


//改变第几个button为选中状态，不发送delegate
- (void)changeButtonStateAtIndex:(NSInteger)index {
    
    NSInteger location = [[_itemInfoArray objectAtIndex:index] integerValue];
    NSInteger with = [[_itemWithArray objectAtIndex:index] integerValue];
    
    [UIView animateWithDuration:0.25 animations:^{
        //设置顺序不对会有错误
        _lineView.transform = CGAffineTransformMakeTranslation(location, 0);
        [_lineView setFrame:CGRectMake(location + 12, _menuScrollV.height-5, with - 24, 2)];
//        if (0 == index) {
//            [_lineView setFrame:CGRectMake(12, _menuScrollV.height-5,35, 2)];
//        }else{
//            [_lineView setFrame:CGRectMake(location + 12, _menuScrollV.height-5, with - 24, 2)];
//        }
        
    }];
    UIButton *button = [_buttonArray objectAtIndex:index];
    [self changeButtonsToNormalState];
    button.transform = CGAffineTransformMakeScale(1.2, 1.2);
    button.selected = YES;
    if (index !=0) {
        [self moveMenuVAtIndex:index];
    }
    
}

//取消所有button点击状态
-(void)changeButtonsToNormalState {
    for (UIButton *btn in _buttonArray) {
        btn.selected = NO;
        btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }
}

//移动button到可视的区域
- (void)moveMenuVAtIndex:(NSInteger)index {
    if (_itemInfoArray.count < index) {
        return;
    };
    //宽度小于320肯定不需要移动
    CGFloat Width = _menuScrollV.frame.size.width;
    if (_totalWidth <= Width) {
        return;
    }
    float buttonOrigin = [_itemInfoArray[index] floatValue];
    if (buttonOrigin >= Width - 180) {
        if ((buttonOrigin - 180) >= _menuScrollV.contentSize.width - Width) {
            [_menuScrollV setContentOffset:CGPointMake(_menuScrollV.contentSize.width - Width, _menuScrollV.contentOffset.y) animated:YES];
            
            return;
        }
        
        float moveToContentOffset = buttonOrigin - 180;
        if (moveToContentOffset > 0) {
            [_menuScrollV setContentOffset:CGPointMake(moveToContentOffset, _menuScrollV.contentOffset.y) animated:YES];
            
        }
    }else{
        [_menuScrollV setContentOffset:CGPointMake(0, _menuScrollV.contentOffset.y) animated:YES];
        
        return;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index = self.collectionV.contentOffset.x / SCREEN_WIDTH;
    
    [self changeButtonStateAtIndex:index];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionV) {
        CGFloat value = ABS(_collectionV.contentOffset.x/SCREEN_WIDTH);
        NSUInteger leftIndex = (int)value;
        CGFloat scale = value - leftIndex;
        UIButton * leftBtn = _buttonArray[leftIndex];
        CGFloat maxScale = 1.2;
        CGFloat leftTrueScale = 1 +  (maxScale - 1) * (1-scale);
        CGFloat rightTrueScale = 1 +  (maxScale - 1) * scale;
        leftBtn.transform = CGAffineTransformMakeScale(leftTrueScale, leftTrueScale);
        if (leftIndex+1 < _buttonArray.count) {
            UIButton * rightBtn = _buttonArray[leftIndex+1];
            rightBtn.transform = CGAffineTransformMakeScale(rightTrueScale, rightTrueScale);
        }
    }

}

@end
