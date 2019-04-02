//
//  StockRedactVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/6/26.
//  Copyright © 2018年 耿一. remain rights reserved.
//

#import "StockRedactVC.h"

@interface StockRedactVC ()
{
    NSMutableArray * _faIdArr;
    NSMutableArray * _faNameArr;
    
    NSMutableArray * _remainIdArr;
    NSMutableArray * _remainNameArr;
    
}

@end

@implementation StockRedactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(31, 36, 46);
    self.navigationItem.title = @"编辑自选";
    self.topHeight.constant = TopHeight;
    [self createBlackNavStyle];
    
    [self createDataArr];
    [self setupCollectionView];
    [self addLongPressGesture];
    // Do any additional setup after loading the view from its nib.
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UserDefaults setObject:_faIdArr forKey:@"favoriteKindIdArr"];
}
-(void)createDataArr
{
    _faIdArr = [[NSMutableArray alloc]initWithArray:_loveArr];
    
    _faNameArr = [[NSMutableArray alloc]init];
    _remainIdArr = [[NSMutableArray alloc]init];
    _remainNameArr = [[NSMutableArray alloc]init];
    
    
    

    
    NSArray * allArr = [StockDetailModel mj_objectArrayWithKeyValuesArray:_allDataArr];

    for (NSInteger i = 0;i < _faIdArr.count;i++) {
        for (StockDetailModel * detailModel in allArr) {
            
            if ([_faIdArr[i] isEqualToString:detailModel.keyRemark]) {
                [_faNameArr addObject:detailModel.name];
                break;
            }
        }
    }
    
    for (StockDetailModel * detailModel in allArr) {
        
        if (![_faIdArr containsObject:detailModel.keyRemark]) {
            [_remainIdArr addObject:detailModel.keyRemark];
            [_remainNameArr addObject:detailModel.name];
        }
    }
    
    [self refreshContentView];
}
-(void)refreshContentView
{
    
    NSInteger faLine = (_faIdArr.count+2)/3;
    
    NSInteger faHeight = faLine * 33 + (faLine+1)*10 + 10;
    
    self.mainCVHeight.constant = faHeight;
    
    
    NSInteger remainLine = (_remainIdArr.count+2)/3;
    
    
    NSInteger remainHeight = remainLine * 33 + (remainLine+1)*10+30;
    
    
    self.contentHeight.constant = faHeight + remainHeight + 50;
    
    [self.mainCollectionV reloadData];
    [self.marketCollectionV reloadData];
}
-(void)setupCollectionView {
    self.mainCollectionV.backgroundColor = RGBCOLOR(31, 36, 46);
    self.marketCollectionV.backgroundColor = RGBCOLOR(31, 36, 46);
    
    self.mainCollectionV.delegate = self;
    self.mainCollectionV.dataSource = self;
    self.marketCollectionV.delegate = self;
    self.marketCollectionV.dataSource = self;
    
//    //注册cell类型及复用标识
    [self.mainCollectionV registerNib:[UINib nibWithNibName:NSStringFromClass([StockCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"MainCellId"];

    [self.marketCollectionV registerNib:[UINib nibWithNibName:NSStringFromClass([StockCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"MainCellId"];

    self.mainCollectionV.collectionViewLayout = [self createLayout];
    self.marketCollectionV.collectionViewLayout = [self createLayout];
}
-(UICollectionViewFlowLayout *)createLayout
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    //layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //最小行间距
    layout.minimumLineSpacing = 10;
    //item尺寸
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 43)/3, 33);
    //组的四周边距
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    //设置头尾（附加）视图的尺寸,某一状态只有一个有效
    //垂直滚动，高度有效，水平滚动，宽度有效
//    layout.headerReferenceSize = CGSizeMake(50, 30);
    //layout.footerReferenceSize = CGSizeMake(50, 50);
    return layout;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
//设置collectionView的item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return CGSizeMake((SCREEN_WIDTH - 43)/3, 33);
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == 1) {
        return _faIdArr.count;
    }else{
        return _remainIdArr.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (1 == collectionView.tag) {
        StockCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MainCellId" forIndexPath:indexPath];
        cell.mainLab.text = _faNameArr[indexPath.row];
        
        return cell;
    }else{
        StockCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MainCellId" forIndexPath:indexPath];
        cell.mainLab.text = _remainNameArr[indexPath.row];
        
        return cell;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _mainCollectionV) {
        if (_faIdArr.count == 1) {
            [SVProgressHUD showWithString:@"最少保留一个哦~"];
            return;
        }
        [_remainIdArr addObject:_faIdArr[indexPath.row]];
        [_remainNameArr addObject:_faNameArr[indexPath.row]];
        
        [_faIdArr removeObjectAtIndex:indexPath.row];
        [_faNameArr removeObjectAtIndex:indexPath.row];
        
    }else{
        [_faIdArr addObject:_remainIdArr[indexPath.row]];
        [_faNameArr addObject:_remainNameArr[indexPath.row]];
        
        [_remainIdArr removeObjectAtIndex:indexPath.row];
        [_remainNameArr removeObjectAtIndex:indexPath.row];

    }
    [self refreshContentView];
}

#pragma mark ////添加长按手势
-(void)addLongPressGesture{
    UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longClick:)];
    longPressGesture.minimumPressDuration = 0.25;
    [self.mainCollectionV addGestureRecognizer:longPressGesture];
}

#pragma mark //触发手势
- (void)longClick:(UILongPressGestureRecognizer *)longPressGesture{
    

    if (longPressGesture.state == UIGestureRecognizerStateBegan) { //开始
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self setupGestureBegan:longPressGesture];
    }else if(longPressGesture.state == UIGestureRecognizerStateChanged){//移动
        [self setupGestureChanged:longPressGesture];
    }else if (longPressGesture.state == UIGestureRecognizerStateCancelled || longPressGesture.state == UIGestureRecognizerStateEnded){//取消或者结束
        [self setupGestureEndOrCancel:longPressGesture];
    }
}

//#pragma mark 手势开始
-(void)setupGestureBegan:(UILongPressGestureRecognizer*)longPressGesture{
    
    //获取手指所在的cell
    self.lastPoint = [longPressGesture locationOfTouch:0 inView:longPressGesture.view];
    self.originalIndexPath = [self.mainCollectionV indexPathForItemAtPoint:self.lastPoint];
    

    UICollectionViewCell * cell = [self.mainCollectionV cellForItemAtIndexPath:self.originalIndexPath];
    UIView * snapMoveCell = [cell snapshotViewAfterScreenUpdates:NO]; //截图
    [self.mainCollectionV addSubview:snapMoveCell];
    
    //隐藏旧的的Cell
    cell.hidden = YES;
    snapMoveCell.frame = cell.frame;
    self.snapMoveCell = snapMoveCell;
    
}
#pragma mark 手势改变
-(void)setupGestureChanged:(UILongPressGestureRecognizer*)longPressGesture{
    
    CGFloat transX = [longPressGesture locationOfTouch:0 inView:longPressGesture.view].x - self.lastPoint.x;
    CGFloat transY = [longPressGesture locationOfTouch:0 inView:longPressGesture.view].y - self.lastPoint.y;

    self.snapMoveCell.center = CGPointApplyAffineTransform(self.snapMoveCell.center, CGAffineTransformMakeTranslation(transX, transY));//移动截图
    self.lastPoint = [longPressGesture locationOfTouch:0 inView:longPressGesture.view];//记录移动的位置
    [self setupMoveCell];//交换cell
}
#pragma mark 手势取消或者结束
-(void)setupGestureEndOrCancel:(UILongPressGestureRecognizer*)longPressGesture{
    UICollectionViewCell * cell = [self.mainCollectionV cellForItemAtIndexPath:self.originalIndexPath];
    [UIView animateWithDuration:0.25 animations:^{
        self.snapMoveCell.center = cell.center;//通过动画过度到移动的Cell位置
    } completion:^(BOOL finished) {
        [self.snapMoveCell removeFromSuperview];//移除截图Cell
        cell.hidden = NO;//显示隐藏的Cell
    }];
}
#pragma mark 交换cell
-(void)setupMoveCell{
    
    //遍历所有可见的Cell
    for (UICollectionViewCell  * cell in [self.mainCollectionV visibleCells]) {
        if ([self.mainCollectionV indexPathForCell:cell]  == self.originalIndexPath) {//非当前的选中的cell
            continue;
        }

        //计算当前截图cell 与可见cell 的中心距离
        CGFloat spacingX = fabs(self.snapMoveCell.center.x - cell.center.x);
        CGFloat spacingY = fabs(self.snapMoveCell.center.y - cell.center.y);
        //如果相交
        if (spacingX <= self.snapMoveCell.bounds.size.width / 2.0 && spacingY <= self.snapMoveCell.bounds.size.height / 2.0) {
            self.moveIndexPath = [self.mainCollectionV indexPathForCell:cell];
            [self updateDataSource];
            [self.mainCollectionV moveItemAtIndexPath:self.originalIndexPath toIndexPath:self.moveIndexPath];
            self.originalIndexPath = self.moveIndexPath;
            break;
        }
    }
    
}
-(void)updateDataSource{
    

    if (self.moveIndexPath.item > self.originalIndexPath.item) {
        
        for (NSInteger index = self.originalIndexPath.item; index < self.moveIndexPath.item; index++) {
            [_faIdArr exchangeObjectAtIndex:index withObjectAtIndex:index+1];
            [_faNameArr exchangeObjectAtIndex:index withObjectAtIndex:index+1];
        }
    }else{
        for (NSInteger index = self.originalIndexPath.item; index > self.moveIndexPath.item; index--) {
            [_faIdArr exchangeObjectAtIndex:index withObjectAtIndex:index-1];
            [_faNameArr exchangeObjectAtIndex:index withObjectAtIndex:index-1];
        }
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
