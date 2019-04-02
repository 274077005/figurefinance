//
//  ChoiceVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/18.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "ChoiceVC.h"

@interface ChoiceVC ()
{
    NSMutableArray * _newsArr;
    GetDataType _getDataType;
    NSInteger _index;
}

@end

@implementation ChoiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _newsArr = [[NSMutableArray alloc]init];
    
    self.navigationItem.title = @"精选";
    [self initializeData];
    [self loadRefreshData];
    [self createCollectionView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRefreshData) name:@"loginOrQuitSuccess" object:nil];
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (UIView *)bannerV
{
    if (!_bannerV) {
        _bannerV =  [[[NSBundle mainBundle] loadNibNamed:@"ChoiceBannerV" owner:nil options:nil] lastObject];
        _bannerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 173*(SCREEN_WIDTH - 30)/345+104+StatusBarHeight);
        //        [self.contentView addSubview:_recommendV];

    }
    return _bannerV;

}

-(void)initializeData
{
    NSDictionary * jsonDic = [UserDefaults dictionaryForKey:@"ChoiceBookDic"];
    
    self.choiceModel = [ChoiceModel mj_objectWithKeyValues:jsonDic[@"data"]];
    self.bannerV.dataArr = self.choiceModel.banner;
    ChoiceBookModel * sectionModel = self.choiceModel.book_list[0];
    self.bannerV.sectionModel = sectionModel;
    [self.bannerV setUpBannerV];
    [self.collectionV reloadData];

}
//建立collectionView
- (void)createCollectionView
{
    self.collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - TabBarHeight) collectionViewLayout:[self createLayout]];
    
    self.collectionV.backgroundColor = [UIColor whiteColor];

    [self.collectionV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BannerHeader"];

    [self.collectionV registerNib:[UINib nibWithNibName:@"BookTagHeaderV" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TagHeader"];
    [self.collectionV registerNib:[UINib nibWithNibName:@"BookCVCell" bundle:nil] forCellWithReuseIdentifier:@"BookCellId"];
    self.collectionV.showsHorizontalScrollIndicator = NO;
    self.collectionV.showsVerticalScrollIndicator = NO;
    self.collectionV.bounces = YES;
    self.collectionV.pagingEnabled = NO;
    self.collectionV.delegate = self;
    self.collectionV.dataSource = self;
    [self.view addSubview:self.collectionV];
    [self.collectionV reloadData];
    
}

- (UICollectionViewFlowLayout *)createLayout {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    //item尺寸
    //    layout.itemSize = CGSizeMake((VIEW_WIDTH - 50)/4, 60);
    //组的四周边距上左下右咯
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 5, 0);
    
    return layout;
}

//下拉刷新
- (void)loadRefreshData
{
    
    _index = 0;
    _getDataType = GetTypeHeader;
    
    [self getListData];
    
}
- (void)getListData
{
    
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    
    [bodyDic setObject:@6 forKey:@"num"];
    
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JChoiceRoot Handler:^(NSDictionary *jsonDic, NSError * error) {
        
        
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                [UserDefaults setObject:jsonDic forKey:@"ChoiceBookDic"];
                self.choiceModel = [ChoiceModel mj_objectWithKeyValues:jsonDic[@"data"]];
                self.bannerV.dataArr = self.choiceModel.banner;
                ChoiceBookModel * sectionModel = self.choiceModel.book_list[0];
                self.bannerV.sectionModel = sectionModel;
                [self.bannerV setUpBannerV];
                [self.collectionV reloadData];
            }
        }else{
            
        }
        
        
    }];
}

#pragma mark - collectionview代理方法 -
//设置collectionView的item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(SCREEN_WIDTH-20, 145);
    
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    //在这里更改大数量
    return self.choiceModel.book_list.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //在这里控制数量
    ChoiceBookModel * bookModel = self.choiceModel.book_list[section];
    return bookModel.comList.count;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{

    NSString * reuseId = @"";
    if (indexPath.section == 0) {
        reuseId = @"BannerHeader";
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseId forIndexPath:indexPath];
//        if (view.subviews.count > 0) {
//            [view.subviews performSelector:@selector(removeFromSuperview)];
//        }
        [view addSubview:self.bannerV];
        return view;
    }else{
        reuseId = @"TagHeader";
        BookTagHeaderV *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseId forIndexPath:indexPath];
        ChoiceBookModel * sectionModel = self.choiceModel.book_list[indexPath.section];
        view.sectionModel = sectionModel;
        [view updateWithModel];
        
        return view;
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH,173*(SCREEN_WIDTH - 30)/345+134);
    }
    return CGSizeMake(SCREEN_WIDTH,50);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BookCVCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"BookCellId" forIndexPath:indexPath];
    ChoiceBookModel * sectionModel = self.choiceModel.book_list[indexPath.section];
    
    ComListModel * listModel = sectionModel.comList[indexPath.row];
    
    cell.listModel = listModel;
    [cell updateWithModel];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ChoiceBookModel * sectionModel = self.choiceModel.book_list[indexPath.section];
    
    ComListModel * listModel = sectionModel.comList[indexPath.row];
    
    BookDetailVC * bookVC = [[BookDetailVC alloc]init];
    bookVC.bookId = listModel.theId;
    [self.navigationController pushViewController:bookVC animated:YES];
}
@end
