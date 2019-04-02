//
//  ChooseIndustryVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/12.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "ChooseIndustryVC.h"
#import "IndustryCVCell.h"
@interface ChooseIndustryVC ()
{
    NSMutableArray * _dataArr;
    NSMutableArray * _selectIdArr;
    NSMutableArray * _selectTitleArr;
    
}

@end

@implementation ChooseIndustryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [[NSMutableArray alloc]init];
    _selectIdArr = [[NSMutableArray alloc]init];
    _selectTitleArr = [[NSMutableArray alloc]init];
    self.topHeight.constant = StatusBarHeight +10;
    [self setupCollectionView];
    [self getIndustryData];
    if ([_industryType isEqualToString:@"4"]) {
        [_affirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    }else{
        [_affirmBtn setTitle:@"确定(0/3)" forState:UIControlStateNormal];
    }
    // Do any additional setup after loading the view from its nib.
}
//隐藏显示navigationBar
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
     
}
- (IBAction)affirmBtnClick:(UIButton *)sender {
    
    if (_selectTitleArr.count < 1) {
        [SVProgressHUD showWithString:@"最少选择一个哦~"];
        return;
    }
    NSString * titleStr = [_selectTitleArr componentsJoinedByString:@"|"];
    NSString * idStr = [_selectIdArr componentsJoinedByString:@","];
    self.submitBlock(titleStr, idStr);
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)closeBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getIndustryData
{
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setObject:_industryType forKey:@"kind_id"];
    
    [SVProgressHUD show];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JIndustry Handler:^(NSDictionary * jsonMessage, NSError *error){
        if ([jsonMessage[@"code"] integerValue] == 1) {
            [_dataArr addObjectsFromArray:jsonMessage[@"data"]];
            [_collectionV reloadData];
        }else{
            [SVProgressHUD showWithString:jsonMessage[@"msg"]];
        }
    }];
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
    layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    
    return layout;
}
-(void)setupCollectionView{
    
    //注册cell类型及复用标识
    [self.collectionV registerNib:[UINib nibWithNibName:@"IndustryCVCell" bundle:nil] forCellWithReuseIdentifier:@"IndustryCellId"];
    self.collectionV.delegate = self;
    self.collectionV.dataSource = self;
    self.collectionV.collectionViewLayout = [self createLayout];
    
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
//设置collectionView的item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREEN_WIDTH - 60)/4,(SCREEN_WIDTH - 60)/4 *44/79);
    
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    
    return _dataArr.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IndustryCVCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IndustryCellId" forIndexPath:indexPath];
    cell.backgroundColor = RGBCOLOR(244, 246, 248);
    NSDictionary * dic = _dataArr[indexPath.row];
    NSString * titleStr = dic[@"name"];
    cell.titleLab.text = titleStr;
    if ([_selectTitleArr containsObject:titleStr]) {
        cell.backgroundColor = WD_BLUE;
        cell.titleLab.textColor =  [UIColor whiteColor];
    }else{
        cell.backgroundColor = RGBCOLOR(244, 246, 248);
        cell.titleLab.textColor =  [UIColor blackColor];
    }
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = _dataArr[indexPath.row];
    NSString * titleStr = dic[@"name"];
    NSString * idStr = dic[@"id"];
    if ([_selectTitleArr containsObject:titleStr]) {
        [_selectTitleArr removeObject:titleStr];
        [_selectIdArr removeObject:idStr];
        
    }else{
        if ([_industryType isEqualToString:@"4"]) {
            if (_selectTitleArr.count == 1) {
                return;
            }
            
        }else{
            if (_selectTitleArr.count == 3) {
                return;
            }
        }
        
        [_selectTitleArr addObject:titleStr];
        [_selectIdArr addObject:idStr];
    }
    if (![_industryType isEqualToString:@"4"]) {
        [_affirmBtn setTitle:[NSString stringWithFormat:@"确定(%ld/3)",_selectTitleArr.count] forState:UIControlStateNormal];
    }
    
    [self.collectionV reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
