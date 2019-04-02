//
//  FHVideoView.m
//  video
//
//  Created by zzw on 2017/1/12.
//  Copyright © 2017年 zzw. All rights reserved.
//

#import "GYPostData+video.h"
#import "FHVideoView.h"
#import "VideoCollectionViewCell.h"
#import "NewAndFixCollectionViewCell.h"
#import "GYURLConnection.h"
#import "VideoModel.h"
#import "MJRefresh.h"

@interface FHVideoView()
@property (nonatomic,copy)NSMutableArray * teacherNameList;//老师名数组
@property (nonatomic,copy)NSMutableArray * sceneList;//标签
@property (nonatomic,copy)NSMutableArray * videoList;//视频
@property (nonatomic,strong)teacherNameModle * mt;//保存选中的老师
@property (nonatomic,strong)sceneModel * ms;//保存选中的标签
@property (nonatomic,copy) NSString * flag;//保存选中的最新/最热
@property (nonatomic,copy) NSString * page;//页数
@property (nonatomic,assign) BOOL isLoad;//是否正在加载
@property (nonatomic,assign) BOOL isUpdate;//是否是下拉刷新

@end
@implementation FHVideoView
#pragma mark -- layzing

-(NSMutableArray *)teacherNameList{
    if (!_teacherNameList) {
        _teacherNameList = [[NSMutableArray alloc] init];
        _mt = [[teacherNameModle alloc] init];
        _mt.teacher_name = @"全部";
        _mt.is =YES;
        _mt.nameId =@"";
        [_teacherNameList addObject:_mt];
    }
    return _teacherNameList;
}
-(NSMutableArray *)sceneList{

    if (!_sceneList) {
        _sceneList = [[NSMutableArray alloc] init];
        _ms = [[sceneModel alloc] init];
        _ms.scene_name = @"全部";
        _ms.is = YES;
        _ms.nameId=@"";
        [_sceneList addObject:_ms];
    }
    return _sceneList;
}
-(NSMutableArray *)videoList{
    if (!_videoList) {
        _videoList = [[NSMutableArray alloc] init];
    }
    return _videoList;
}
- (void)setting{

    [self teacherNameList];
    [self sceneList];
    self.flag =@"1";
    self.page =@"1";
    //获取老师和标签信息
    [self getTecherNameAndScene];
    //获取视频
    [self getVideoData];
    
    ViewRadius(self.newestBtn, 4);
    ViewRadius(self.fieryBtn, 4);
   
    self.selectedBgView.autoresizesSubviews = YES;
    self.selectedBgView.clipsToBounds = YES;
   

    self.selectedViewHeight.constant = 0;
    
    self.newestBtn.selected = YES;
  
    self.persionNameCollectionView.frame = CGRectMake(0, 15, self.frame.size.width, 28);
    self.persionNameCollectionView.collectionViewLayout = [self createOtherLayout];
    
 
    self.otherCollectionView.frame = CGRectMake(0, 58, self.frame.size.width, 28);
    self.otherCollectionView.collectionViewLayout = [self createOtherLayout];
   
    self.videoCollectionVIew.collectionViewLayout = [self createLayout];
    
    
    [self.videoCollectionVIew registerNib:[UINib nibWithNibName:@"VideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"VideoCollectionViewCell"];
    [self.persionNameCollectionView registerNib:[UINib nibWithNibName:@"NewAndFixCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    [self.otherCollectionView registerNib:[UINib nibWithNibName:@"NewAndFixCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"other"];
    
    self.videoCollectionVIew.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = @"1";
        self.isUpdate = YES;
        [self getVideoData];
    }];
    
    MJRefreshAutoNormalFooter *f =[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.page = [NSString stringWithFormat:@"%d",self.page.intValue+1];
        self.isUpdate = NO;
        [self getVideoData];
    }];
    f.automaticallyChangeAlpha = YES;
    self.videoCollectionVIew.mj_footer = f;
    
    
}

- (UICollectionViewFlowLayout * )createLayout{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing =10;
    layout.minimumInteritemSpacing = 3;
    layout.sectionInset = UIEdgeInsetsMake(15, 10, 0, 10);
    layout.itemSize = CGSizeMake((self.frame.size.width-23)/2, 150);
    
    return layout;
    
}

- (UICollectionViewFlowLayout * )createOtherLayout{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing =5;
    layout.minimumInteritemSpacing = 1;
    layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    layout.itemSize = CGSizeMake(76, 28);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return layout;
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
   
}

#pragma mark --UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.videoCollectionVIew) {
        return self.videoList.count;
    }else if (collectionView == self.persionNameCollectionView){
        return self.teacherNameList.count;
    }else{
        return self.sceneList.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    if (collectionView == self.videoCollectionVIew) {
       
    VideoCollectionViewCell*    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCollectionViewCell" forIndexPath:indexPath];
    
        //播放
        VideoModel * m = self.videoList[indexPath.row];
        
    
        [cell updateWith:m];
         return cell;
        
    }else if (collectionView == self.persionNameCollectionView){
        
     NewAndFixCollectionViewCell*   cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        teacherNameModle * m = self.teacherNameList[indexPath.row];
       
        cell.infoLab.text = m.teacher_name;
        if (m.is) {
            cell.infoLab.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:238/255.0 alpha:1];
            cell.infoLab.textColor = [UIColor colorWithRed:253/255.0 green:62/255.0 blue:57/255.0 alpha:1];
        }else{
            cell.infoLab.backgroundColor = [UIColor whiteColor];
            cell.infoLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        }
        
        return cell;
    }else{
        
     NewAndFixCollectionViewCell*    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"other" forIndexPath:indexPath];
        
        
        sceneModel * m = self.sceneList[indexPath.row];
        
        cell.infoLab.text = m.scene_name;
        if (m.is) {
           
            cell.infoLab.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:238/255.0 alpha:1];
            cell.infoLab.textColor = [UIColor colorWithRed:253/255.0 green:62/255.0 blue:57/255.0 alpha:1];
        }else{
            cell.infoLab.backgroundColor = [UIColor whiteColor];
            cell.infoLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
          
        }
       

        return cell;
    }
  
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    
    if (!self.videoCollectionVIew.emptyDataSetDelegate) {
        self.videoCollectionVIew.emptyDataSetSource = self;
        self.videoCollectionVIew.emptyDataSetDelegate = self;
    }
    if (self.videoCollectionVIew == collectionView) {
        
        VideoModel * m =self.videoList[indexPath.row];
            
            self.block(m.nameId,m.video_url,m.title);
            //统计播放次数
            [GYPostData postVideoPalyWith:@{@"id":m.nameId,@"time":[GYToolKit getTimeIntervalSince1970]}];
        return;
    }else if (collectionView == self.persionNameCollectionView){
        
       self.mt.is = NO;
       self.mt = self.teacherNameList[indexPath.row];
       self.mt.is =YES;
    
    }else if (collectionView == self.otherCollectionView){
        
        self.ms.is = NO;
        self.ms = self.sceneList[indexPath.row];
        self.ms.is = YES;

       
    }
    [collectionView reloadData];
    self.isUpdate = YES;
    self.page = @"1";
    [self getVideoData];
    
    
}

- (IBAction)selectedClick:(UIButton *)sender {
    
     sender.selected = !sender.selected;
    
   
        
        if (sender.selected) {
            
            self.selectedViewHeight.constant = 101;
            [self.persionNameCollectionView reloadData];
            [self.otherCollectionView reloadData];
        }else{
            
            self.selectedViewHeight.constant = 0;
        }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
  
}
- (IBAction)cilckBtn:(UIButton*)sender {
   
    if (sender.tag == 101) {
        sender.selected = YES;
        self.fieryBtn.selected = NO;
        self.flag =@"1";
    }else{
        sender.selected = YES;
        self.newestBtn.selected = NO;
        self.flag =@"2";
    }
    self.page = @"1";
    self.isUpdate = YES;
    [self getVideoData];
}
#pragma mark -- 获取数据
- (void)getVideoData{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString * date =[NSString stringWithFormat:@"%f",time];
    if (self.isLoad) {
        return;
    }
        self.isLoad = YES;
    NSDictionary * dict = @{@"page":self.page,
                            @"size":@"10",
                            @"order":self.flag,
                            @"teacher_id":self.mt.nameId,
                            @"scene_id":self.ms.nameId,
                            @"time":date
                            };
 
    [SVProgressHUD show];
    [GYPostData getVideoListWith:dict handler:^(NSArray * arr, NSError * error) {
        [SVProgressHUD dismiss];
         self.isLoad = NO;
        [self.videoCollectionVIew.mj_header endRefreshing];
        [self.videoCollectionVIew.mj_footer endRefreshing];
        if (!error) {

            if (self.isUpdate) {
                [self.videoList removeAllObjects];
            }
            if (arr.count < 10) {
                [self.videoCollectionVIew.mj_footer endRefreshingWithNoMoreData];
            }
            [self.videoList addObjectsFromArray:arr];
            [self.videoCollectionVIew reloadData];
        }
    }];

}
- (void)getTecherNameAndScene{
   

    [GYPostData getTeacherNameAndScene:^(teacherNameAndSceneModles * m , NSError * error) {
        if (!error) {
           
            
            [self.teacherNameList addObjectsFromArray:m.teacher_list];
            [self.sceneList addObjectsFromArray:m.scene_list];
            [self.persionNameCollectionView reloadData];
            [self.otherCollectionView reloadData];
        }
    }];
    


}

#pragma mark - DZNEmptyDataSetSource Methods
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
  
        
    return [UIImage imageNamed:@"no_viode_03"];
   
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
   
    
    return [[NSAttributedString alloc] initWithString:@"很抱歉，没有找到任何相关视频" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]}];

}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    text = @"建议您更换一些筛选条件试试";
    font = [UIFont boldSystemFontOfSize:14.0];
    textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:153/255.0];
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    if (paragraph) [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    return attributedString;
}
@end
