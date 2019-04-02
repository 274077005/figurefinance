//
//  RedactColumnVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/16.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "RedactColumnVC.h"
#define CellHeight 36
#define NoRedact 2  //不可编辑的数量 小于等于 如果不可编辑为3 则写2
@interface RedactColumnVC ()
{
    NSString * _firstStr;
    NSString * _secondStr;
    NSString * _thridStr;
    NSMutableArray * _firstArr;
    NSMutableArray * _secondArr;
    NSMutableArray * _thridArr;
    BOOL _isEdit;
    
    //选择的栏目名字
    NSMutableArray * _seTitleArr;
    //选择的栏目id
    NSMutableArray * _seIdArr;
    
}

@end

@implementation RedactColumnVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topHeight.constant = StatusBarHeight;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _titleBV.layer.cornerRadius = 1;
    _titleBV.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _titleBV.layer.shadowColor = [UIColor grayColor].CGColor;
    _titleBV.layer.shadowOffset = CGSizeMake(0, 4);
    _titleBV.layer.shadowOpacity = 0.1;
    
    _seTitleArr = [[NSMutableArray alloc]init];
    _seIdArr = [[NSMutableArray alloc]init];
    _firstArr = [[NSMutableArray alloc]init];
    _secondArr = [[NSMutableArray alloc]init];
    _thridArr = [[NSMutableArray alloc]init];
    
    _isEdit = YES;

    for (int i = 0;i<self.homeArr.count; i++) {
        
        
        HomeMenuModel * menuMdeol = _homeArr[i];
        [_seTitleArr addObject:menuMdeol.type_name];
        [_seIdArr addObject:menuMdeol.theId];
    }
    [self setupCollectionView];
    [self refreshCollectionV];
    [self setUpTableView];
    [self getAllColumnData];
    [self addLongPressGesture];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getAllColumnData
{
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    [GYPostData GetInfomationWithDic:bodyDic UrlPath:JAllColumn Handler:^(NSDictionary *jsonDic, NSError * error) {
        if (!error) {
            
            if ([jsonDic[@"code"] isEqualToString:@"1"]) {
                _jsonDic = jsonDic;
                [_firstArr addObjectsFromArray:jsonDic[@"data"]];
                _firstStr = _firstArr[0][@"name"];
                [_secondArr addObjectsFromArray:jsonDic[@"data"][0][@"child"]];
                _secondStr = _secondArr[0][@"name"];
                [_thridArr addObjectsFromArray:jsonDic[@"data"][0][@"child"][0][@"child"]];
                _thridStr = _thridArr[0][@"name"];
                [self.firstTabV reloadData];
                [self.secondTabV reloadData];
                [self.thridTabV reloadData];
            }
        }
    }];
}
- (IBAction)closeBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)editBtnClick:(UIButton *)sender {
//    _isEdit = !_isEdit;
//    if (_isEdit) {
//        self.allTabBV.hidden = NO;
//        self.moveLab.hidden = NO;
//        [self.editBtn setTitle:@"完成" forState:UIControlStateNormal];
//
//    }else{
//        self.allTabBV.hidden = YES;
//        self.moveLab.hidden = YES;
//        [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
//        [self saveUserColumn];
//
//    }
    [self saveUserColumn];
    [self refreshCollectionV];
    
}
//传给服务器
-(void)saveUserColumn
{
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];

    NSString * idStr = [_seIdArr componentsJoinedByString:@","];
    [bodyDic setObject:idStr forKey:@"channels"];
    [SVProgressHUD show];
    [GYPostData GetInfomationWithDic:bodyDic UrlPath:JSaveColumn Handler:^(NSDictionary *jsonDic, NSError * error) {
        if (!error) {
            if ([jsonDic[@"code"] isEqualToString:@"1"]) {
                [SVProgressHUD showWithString:@"保存成功~"];
                self.submitBlock();
                [self postDataSucceed];
            }
        }
    }];
}
- (void)setUpTableView
{
    self.firstTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.firstTabV.estimatedRowHeight = 0;
    self.firstTabV.estimatedSectionHeaderHeight = 0;
    self.firstTabV.estimatedSectionFooterHeight = 0;
    self.secondTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.secondTabV.estimatedRowHeight = 0;
    self.secondTabV.estimatedSectionHeaderHeight = 0;
    self.secondTabV.estimatedSectionFooterHeight = 0;
    self.thridTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.thridTabV.estimatedRowHeight = 0;
    self.thridTabV.estimatedSectionHeaderHeight = 0;
    self.thridTabV.estimatedSectionFooterHeight = 0;
    [self.firstTabV registerNib:[UINib nibWithNibName:@"RedactTVCell" bundle:nil] forCellReuseIdentifier:@"RedactTVCellId"];
    [self.secondTabV registerNib:[UINib nibWithNibName:@"RedactTVCell" bundle:nil] forCellReuseIdentifier:@"RedactTVCellId"];
    [self.thridTabV registerNib:[UINib nibWithNibName:@"RedactTVCell" bundle:nil] forCellReuseIdentifier:@"RedactTVCellId"];
    
}
#pragma mark - CollectionView data source
-(void)refreshCollectionV
{
    NSInteger lineCount = (_seTitleArr.count+2)/3;
    NSInteger offset = lineCount*CellHeight + (lineCount+1)*10;
    self.CVHeight.constant = offset;

    [self.collectionV reloadData];
}
-(UICollectionViewFlowLayout *)createLayout
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    //layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //最小行间距
    layout.minimumLineSpacing = 10;
    //item尺寸
    //    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 50)/4, 60);
    //组的四周边距上左下右咯
    layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    return layout;
}
-(void)setupCollectionView{
    
    //注册cell类型及复用标识
    [self.collectionV registerNib:[UINib nibWithNibName:@"RedactCVCell" bundle:nil] forCellWithReuseIdentifier:@"RedactCVCellId"];
    self.collectionV.delegate = self;
    self.collectionV.dataSource = self;
    self.collectionV.collectionViewLayout = [self createLayout];
    
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
//设置collectionView的item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREEN_WIDTH - 50)/3,CellHeight);
    
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _seTitleArr.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RedactCVCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RedactCVCellId" forIndexPath:indexPath];
    
    cell.delBtn.hidden = YES;
    cell.titleLab.text = _seTitleArr[indexPath.row];
    cell.titleLab.backgroundColor = RGBCOLOR(244, 246, 248);
    if (indexPath.row <= NoRedact) {
        cell.titleLab.backgroundColor = [UIColor whiteColor];
    }else if(_isEdit){
        cell.delBtn.hidden = NO;
        cell.delBtn.tag = indexPath.row;
        [cell.delBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
    
    
}
-(void)deleteBtnClick:(UIButton *)btn
{
    [_seTitleArr removeObjectAtIndex:btn.tag];
    [_seIdArr removeObjectAtIndex:btn.tag];
    [self reloadAllTableView];
    [self refreshCollectionV];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _firstTabV) {
        return _firstArr.count;
    }else if (tableView == _secondTabV){
        return _secondArr.count;
    }else{
        return _thridArr.count;
    }
}

//设定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    RedactTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RedactTVCellId" forIndexPath:indexPath];
    //不让cell有选中状态
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dic;
    if (tableView == _firstTabV) {
        dic = _firstArr[indexPath.row];
        cell.chooseBtn.hidden = YES;
    }else if (tableView == _secondTabV){
        dic = _secondArr[indexPath.row];
    }else{
        dic = _thridArr[indexPath.row];
    }
    
    NSString * titleStr = dic[@"name"];
    if ([titleStr isEqualToString:_firstStr]||[titleStr isEqualToString:_secondStr]||tableView == _thridTabV) {
        cell.backgroundColor = RGBCOLOR(250, 251, 252);
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    //规避第二个tablerView中有和第三个tableView中相同的名字
    if ([_seTitleArr containsObject:titleStr] || tableView == _thridTabV) {
        cell.titleLab.textColor = WD_BLUE;
        [cell.chooseBtn setImage:IMG_Name(@"columnC") forState:UIControlStateNormal];
    }else{
        cell.titleLab.textColor = RGBCOLOR(118, 118, 118);
        [cell.chooseBtn setImage:IMG_Name(@"columnNotC") forState:UIControlStateNormal];
    }
    cell.chooseBtn.paramDic = dic;
    cell.titleLab.text = titleStr;
    if (tableView == _secondTabV) {
        [cell.chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.chooseBtn.tag = indexPath.row;
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    if (tableView == _firstTabV) {
        _firstStr = _firstArr[index][@"name"];
        [_secondArr removeAllObjects];
        [_secondArr addObjectsFromArray:_jsonDic[@"data"][index][@"child"]];
        _secondStr = _secondArr[0][@"name"];
        
        [_thridArr removeAllObjects];
        [_thridArr addObjectsFromArray:_secondArr[0][@"child"]];
        _thridStr = _thridArr[0][@"name"];
        [self reloadAllTableView];
    }else if (tableView == _secondTabV){
         _secondStr = _secondArr[index][@"name"];
        [_thridArr removeAllObjects];
        [_thridArr addObjectsFromArray:_secondArr[index][@"child"]];
        _thridStr = _thridArr[0][@"name"];
        [self reloadAllTableView];
    }
}
- (void)chooseBtnClick:(UIButton *)btn
{
    if (![_seTitleArr containsObject:btn.paramDic[@"name"]]) {
        [_seTitleArr addObject:btn.paramDic[@"name"]];
        [_seIdArr addObject:[NSString stringWithFormat:@"%@",btn.paramDic[@"id"]]];
        [self reloadAllTableView];
        [self refreshCollectionV];
    }else{
        [_seTitleArr removeObject:btn.paramDic[@"name"]];
        [_seIdArr removeObject:[NSString stringWithFormat:@"%@",btn.paramDic[@"id"]]];
        [self reloadAllTableView];
        [self refreshCollectionV];
    }
    
}
- (void)reloadAllTableView
{
    [self.firstTabV reloadData];
    [self.secondTabV reloadData];
    [self.thridTabV reloadData];
}

#pragma mark ////添加长按手势
-(void)addLongPressGesture{
    UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longClick:)];
    longPressGesture.minimumPressDuration = 0.25;
    [self.collectionV addGestureRecognizer:longPressGesture];
}

#pragma mark //触发手势
- (void)longClick:(UILongPressGestureRecognizer *)longPressGesture{
    
    if (!_isEdit) {
        return;
    }
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
    self.originalIndexPath = [self.collectionV indexPathForItemAtPoint:self.lastPoint];

    //前俩不可编辑
    if (self.originalIndexPath.row <=NoRedact) {
        return;
    }
    
    UICollectionViewCell * cell = [self.collectionV cellForItemAtIndexPath:self.originalIndexPath];
    UIView * snapMoveCell = [cell snapshotViewAfterScreenUpdates:NO]; //截图
    [self.collectionV addSubview:snapMoveCell];
    
    //隐藏旧的的Cell
    cell.hidden = YES;
    snapMoveCell.frame = cell.frame;
    self.snapMoveCell = snapMoveCell;
    
}
#pragma mark 手势改变
-(void)setupGestureChanged:(UILongPressGestureRecognizer*)longPressGesture{
    
    CGFloat transX = [longPressGesture locationOfTouch:0 inView:longPressGesture.view].x - self.lastPoint.x;
    CGFloat transY = [longPressGesture locationOfTouch:0 inView:longPressGesture.view].y - self.lastPoint.y;
    //前俩不可编辑
    if (self.originalIndexPath.row <=NoRedact) {
        return;
    }
    self.snapMoveCell.center = CGPointApplyAffineTransform(self.snapMoveCell.center, CGAffineTransformMakeTranslation(transX, transY));//移动截图
    self.lastPoint = [longPressGesture locationOfTouch:0 inView:longPressGesture.view];//记录移动的位置
    [self setupMoveCell];//交换cell
}
#pragma mark 手势取消或者结束
-(void)setupGestureEndOrCancel:(UILongPressGestureRecognizer*)longPressGesture{
    UICollectionViewCell * cell = [self.collectionV cellForItemAtIndexPath:self.originalIndexPath];
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
    for (UICollectionViewCell  * cell in [self.collectionV visibleCells]) {
        if ([self.collectionV indexPathForCell:cell]  == self.originalIndexPath) {//非当前的选中的cell
            continue;
        }
        if ([self.collectionV indexPathForCell:cell].row <=NoRedact) {//前几个不能编辑
            continue;
        }
        //计算当前截图cell 与可见cell 的中心距离
        CGFloat spacingX = fabs(self.snapMoveCell.center.x - cell.center.x);
        CGFloat spacingY = fabs(self.snapMoveCell.center.y - cell.center.y);
        //如果相交
        if (spacingX <= self.snapMoveCell.bounds.size.width / 2.0 && spacingY <= self.snapMoveCell.bounds.size.height / 2.0) {
            self.moveIndexPath = [self.collectionV indexPathForCell:cell];
            [self updateDataSource];
            [self.collectionV moveItemAtIndexPath:self.originalIndexPath toIndexPath:self.moveIndexPath];
            self.originalIndexPath = self.moveIndexPath;
            break;
        }
    }
    
}
-(void)updateDataSource{
    
    if (_seTitleArr.count) {
        if (self.moveIndexPath.item > self.originalIndexPath.item) {
            
            for (NSInteger index = self.originalIndexPath.item; index < self.moveIndexPath.item; index++) {
                [_seTitleArr exchangeObjectAtIndex:index withObjectAtIndex:index+1];
                [_seIdArr exchangeObjectAtIndex:index withObjectAtIndex:index+1];
            }
        }else{
            for (NSInteger index = self.originalIndexPath.item; index > self.moveIndexPath.item; index--) {
                [_seTitleArr exchangeObjectAtIndex:index withObjectAtIndex:index-1];
                [_seIdArr exchangeObjectAtIndex:index withObjectAtIndex:index-1];
            }
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
