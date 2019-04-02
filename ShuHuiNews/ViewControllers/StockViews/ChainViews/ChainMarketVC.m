//
//  HomeViewController.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/9.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "ChainMarketVC.h"
#import "MarketCVCell.h"
@interface ChainMarketVC ()
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
    
    //获取股票信息的定时器
    GYTimer * _stockTimer;
}

@end

@implementation ChainMarketVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"区块链行情";
    self.topHeight.constant = TopHeight;
    _itemArray = [[NSMutableArray alloc]init];
    [self createCollectionView];
    [self getMenuData];

    self.view.backgroundColor = [UIColor whiteColor];
    

    // Do any additional setup after loading the view from its nib.
}
-(void)createStockTimer
{

    _stockTimer = [[GYTimer alloc] init];
  
    [_stockTimer startTimer:5 delegate:self repeats:YES];
    
}
- (void)onTimerClick:(GYTimer *)timer{
    
    NSLog(@"我还在啊啊啊啊啊");
    [self marketGetStockData];
    
}
- (void)marketGetStockData
{
    if ([self.collectionV visibleCells].count > 0) {
        [[self.collectionV visibleCells][0] getData];
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [_stockTimer goPast];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_stockTimer goFuture];
    
}
-(void)getMenuData
{

    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    [GYPostData GetInfomationWithDic:bodyDic UrlPath:JChainMenu Handler:^(NSDictionary *jsonDic, NSError * error) {
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {


                [_itemArray removeAllObjects];
                [_itemArray addObjectsFromArray:jsonDic[@"data"]];
                NSLog(@"11111:%ld",_itemArray.count);
                [self createMenuScrollView];
                
            }
        }
    }];
}

//建立collectionView
- (void)createCollectionView
{
    self.collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, _menuScrollV.height + TopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - _menuScrollV.height - TopHeight) collectionViewLayout:[self createLayout]];
    
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
        NSInteger itemWidth = 30;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSString *str = _itemArray[i];
        NSInteger len = [str length];
        if (len >= 3) {
            itemWidth = 50;
            if(len > 4){
                itemWidth = 50;
            }
        }
        button.frame = CGRectMake(menuWidth, 0, itemWidth, 44);
        [button setTitle:str forState:UIControlStateNormal];
        [button setTitleColor:RGBCOLOR(31, 31, 31) forState:UIControlStateNormal];
        [button setTitleColor:RGBCOLOR(35,122,229) forState:UIControlStateSelected];
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


    _lineView = [[UIView alloc] init];
    _lineView.frame = CGRectMake(10, _menuScrollV.height -5,35, 2);
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
        [self changeButtonStateAtIndex:0];
        
    }
    
    [self.collectionV setContentOffset:CGPointMake(0 , 0)];
    [self createStockTimer];
}

#pragma mark - collectionview代理方法 -

//设置collectionView的item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT  - _menuScrollV.height - TopHeight);
    
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"LLLLLL:%ld",_itemArray.count);
    return _itemArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString * menuIdStr = _itemArray[indexPath.row];
    NSString* str = [NSString stringWithFormat:@"MarketCell%ld",indexPath.row];
    [_collectionV registerClass:[MarketCVCell class] forCellWithReuseIdentifier:str];
    MarketCVCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:str forIndexPath:indexPath];
    cell.backgroundColor = randomColor;
    cell.theId = menuIdStr;
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

        
    }];
    UIButton *button = [_buttonArray objectAtIndex:index];
    [self changeButtonsToNormalState];
    button.selected = YES;
    if (index !=0) {
        [self moveMenuVAtIndex:index];
    }
    
}

//取消所有button点击状态
-(void)changeButtonsToNormalState {
    for (UIButton *btn in _buttonArray) {
        btn.selected = NO;
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
        CGFloat maxScale = 1.0;
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
