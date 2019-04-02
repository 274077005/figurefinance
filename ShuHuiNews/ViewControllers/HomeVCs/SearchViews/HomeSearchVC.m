//
//  HomeSearchVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/17.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "HomeSearchVC.h"
#import "HomeRecommendV.h"
@interface HomeSearchVC ()
{
    NSMutableArray * _hotArr;
    NSMutableArray * _historyArr;
    
}

@end

@implementation HomeSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topHeight.constant = StatusBarHeight;
    self.view.backgroundColor = [UIColor whiteColor];
    self.textF.returnKeyType = UIReturnKeySearch;
    [self.textF addTarget:self action:@selector(textFieldBeginChange) forControlEvents:UIControlEventEditingDidBegin];
    _hotArr = [[NSMutableArray alloc]init];
    NSArray * faNameArray = [[NSUserDefaults standardUserDefaults] arrayForKey:@"searchHistory"];
    _historyArr =[[NSMutableArray alloc] initWithArray:faNameArray];
    
    _searchBV.layer.cornerRadius = 1;
    _searchBV.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _searchBV.layer.shadowColor = [UIColor grayColor].CGColor;
    _searchBV.layer.shadowOffset = CGSizeMake(0, 4);
    _searchBV.layer.shadowOpacity = 0.1;
    [self.textF becomeFirstResponder];
    [self setupCollectionView];
    [self getHotSearchData];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self updateSearchHistoryArrayToDefaults];
}
- (void)getHotSearchData
{
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    [GYPostData GetInfomationWithDic:bodyDic UrlPath:JGetHotSearch Handler:^(NSDictionary *jsonDic, NSError * error) {
        if (!error) {
            if ([jsonDic[@"code"] isEqualToString:@"1"]) {
                [_hotArr addObjectsFromArray:jsonDic[@"data"]];
                [self.collectionV reloadData];
            }
        }
    }];
}
- (void)textFieldBeginChange
{
    [self.view bringSubviewToFront:self.collectionV];
}
- (IBAction)searchBtnClick:(UIButton *)sender {
    if (_textF.text.length < 1) {
        [SVProgressHUD showWithString:@"搜索内容不能为空"];
        return;
    }
    if (_historyArr.count == 20) {
        [_historyArr removeLastObject];
    }
    if (![_historyArr containsObject:_textF.text]) {
        [_historyArr addObject:_textF.text];
    }
    [self.collectionV reloadData];
    self.recommendV.searchStr = _textF.text;
    [self.recommendV loadRefreshData];
    [self.view endEditing:YES];
    [self.view bringSubviewToFront:self.recommendV];
}
- (UIView *)recommendV
{
    if (!_recommendV) {
        _recommendV = [[HomeRecommendV alloc] initWithFrame:self.collectionV.frame withType:0 valueStr:_textF.text];
        _recommendV.searchToHere = YES;
        [self.view addSubview:_recommendV];
    }
    return _recommendV;
}

-(void)setupCollectionView{
    
    //注册cell类型及复用标识
    [self.collectionV registerNib:[UINib nibWithNibName:@"HomeSearchCVCell" bundle:nil] forCellWithReuseIdentifier:@"SearchCellId"];
    [self.collectionV registerNib:[UINib nibWithNibName:@"SearchCVHeaderV" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionV registerNib:[UINib nibWithNibName:@"SearchCVHeaderV" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    self.collectionV.delegate = self;
    self.collectionV.dataSource = self;
    self.collectionV.collectionViewLayout = [self createLayout];
}
- (GYCollectionLayout *)createLayout
{
    // 例子 - 可根据自己的需求来变
    GYCollectionLayout *tagLayout = [[GYCollectionLayout alloc] init];
    
    //section inset
    tagLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    // 行间距
    tagLayout.lineSpacing = 10;
    
    // item间距
    tagLayout.itemSpacing = 10;
    
    // item高度
    tagLayout.itemHeigh = 32;
    
    // 对齐形式
    tagLayout.layoutAligned = FJTagLayoutAlignedLeft;
    
    tagLayout.delegate = self;
    
    
    
    
    
    return tagLayout;
}

#pragma mark  ------- UIcollectionV
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return _hotArr.count;
    }else{
        return _historyArr.count;
    }
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeSearchCVCell *cell = [_collectionV dequeueReusableCellWithReuseIdentifier:@"SearchCellId" forIndexPath:indexPath];
    NSString * titleStr;
    if (indexPath.section == 0) {
        titleStr = _hotArr[indexPath.row][@"keywords"];
    }else{
        titleStr = _historyArr[indexPath.row];
    }
    cell.titleLab.text = titleStr;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        SearchCVHeaderV *headerView = [_collectionV dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        if (indexPath.section == 0) {
            headerView.titleLab.text = @"热门搜索";
            headerView.delBtn.hidden = YES;
        }else{
            headerView.titleLab.text = @"历史搜索";
            headerView.delBtn.hidden = NO;
            [headerView.delBtn addTarget:self action:@selector(deleteHistoryBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }
        return headerView;
    }else{
        SearchCVHeaderV *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        
        return footerView;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellTitle;
    if (indexPath.section == 0) {
        cellTitle = _hotArr[indexPath.row][@"keywords"];
    }else{
        cellTitle = _historyArr[indexPath.row];
    }
    self.textF.text = cellTitle;
    [self searchBtnClick:nil];
}
#pragma mark  ------- GYCollectionLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(GYCollectionLayout*)collectionViewLayout widthAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
    size.height = 32;
    //计算字的width 这里主要font 是字体的大小
    NSString * titleStr;
    if (indexPath.section == 0) {
        titleStr = _hotArr[indexPath.row][@"keywords"];
    }else{
        titleStr = _historyArr[indexPath.row];
    }
    CGFloat width = [GYToolKit LabelWidthWithSize:14 height:32 str:titleStr];
    size.width = width + 40; //20为左右空10
    
    return size.width;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(GYCollectionLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    return CGSizeMake(SCREEN_WIDTH, 40);
}


#pragma mark - uuuuu
- (CGSize)sizeWithString:(NSString *)str fontSize:(float)fontSize
{
    CGSize constraint = CGSizeMake(self.view.frame.size.width - 40, fontSize + 1);
    
    CGSize tempSize;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize retSize = [str boundingRectWithSize:constraint
                                       options:
                      NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attribute
                                       context:nil].size;
    tempSize = retSize;
    
    return tempSize ;
}
- (void)deleteHistoryBtnClick
{
    [_historyArr removeAllObjects];
    [self.collectionV reloadData];
    
    
}
#pragma mark --private Method--存储更新后的用户搜索信息
-(void)updateSearchHistoryArrayToDefaults{
    NSString * str = @"searchHistory";
    [[NSUserDefaults standardUserDefaults] setObject:_historyArr forKey:str];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self searchBtnClick:nil];
    return YES;
}
- (IBAction)navBackBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
