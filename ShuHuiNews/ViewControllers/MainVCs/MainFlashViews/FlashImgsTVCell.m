//
//  FlashNormalTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/9/11.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "FlashImgsTVCell.h"

@implementation FlashImgsTVCell{
    CALayer * _BVLayer;
    CALayer * _headerLayer;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    _BVLayer = [[CALayer alloc] init];
    _headerLayer = [[CALayer alloc] init];
    UITapGestureRecognizer * praiseBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(praiseBVClick)];
    [self.praiseBV addGestureRecognizer: praiseBVTGR];
    
    UITapGestureRecognizer * shareBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareBVClick)];
    [self.shareBV addGestureRecognizer: shareBVTGR];
    [self setupCollectionView];
    // Initialization code
}
- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];

    _BVLayer.position = _shadowBV.layer.position;
    _BVLayer.frame = _shadowBV.frame;
    _BVLayer.cornerRadius = _shadowBV.layer.cornerRadius;
    _BVLayer.backgroundColor = [UIColor whiteColor].CGColor;
    _BVLayer.shadowColor = [UIColor grayColor].CGColor;
    _BVLayer.shadowOffset = CGSizeMake(2, 2);
    _BVLayer.shadowOpacity = 0.3;
    [self.contentView.layer addSublayer:_BVLayer];
    [self.contentView bringSubviewToFront:_shadowBV];
    
    _headerLayer.position = _headerBtn.layer.position;
    _headerLayer.frame = _headerBtn.frame;
    _headerLayer.cornerRadius = _headerBtn.layer.cornerRadius;
    _headerLayer.backgroundColor = [UIColor whiteColor].CGColor;
    _headerLayer.shadowColor = [UIColor grayColor].CGColor;
    _headerLayer.shadowOffset = CGSizeMake(2, 2);
    _headerLayer.shadowOpacity = 0.3;
    [self.contentView.layer addSublayer:_headerLayer];
    [self.contentView bringSubviewToFront:_headerBtn];
}
- (IBAction)linkBtnClick:(UIButton *)sender {
    BaseWebVC * webVC = [[BaseWebVC alloc]init];
    webVC.urlStr = _flashModel.origin_link;
    [self.viewContoller.navigationController pushViewController:webVC animated:YES];
}
- (IBAction)headerBtnClick:(UIButton *)sender {
    RingDetailVC * detailVC = [[RingDetailVC alloc]init];
    detailVC.writeId = _flashModel.auth_id;
    [self.viewContoller.navigationController pushViewController:detailVC animated:YES];
    
}
-(void)updateWithModel
{
    [self.headerBtn sd_setImageWithURL:_flashModel.image forState:UIControlStateNormal];
    self.timeLab.text = _flashModel.minutes;
    self.titleLab.text = _flashModel.title;
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_flashModel.content];
    NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
    
    
    [paragraphStyle setLineSpacing:5.0];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, [attributedString length])];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
    self.contentLab.attributedText = attributedString;
    
    if (_flashModel.origin_link.length > 1) {
        self.linkBtn.hidden = NO;
    }else{
        self.linkBtn.hidden = YES;
    }
    
    if ([_flashModel.hits integerValue] > 999) {
        self.praiseNumLab.text = @"+999";
    }else{
        self.praiseNumLab.text = _flashModel.hits;
    }
    if ([_flashModel.is_praise isEqualToString:@"1"]) {
        self.praiseImgV.image = IMG_Name(@"isPraise");
        self.praiseNumLab.textColor = RGBCOLOR(35, 122, 229);
    }else{
        self.praiseImgV.image = IMG_Name(@"notPraise");
        self.praiseNumLab.textColor = RGBCOLOR(166, 166, 166);
    }
    
    
    [self.collectionV reloadData];
    
}
- (void)praiseBVClick
{
    if (![UserInfo share].isLogin) {
        [GYToolKit pushLoginVC];
        return;
    }
    if ([_flashModel.is_praise isEqualToString:@"1"]) {
        _flashModel.is_praise = @"2";
        NSInteger priseCount = [_flashModel.hits integerValue];
        priseCount--;
        _flashModel.hits = [NSString stringWithFormat:@"%ld",priseCount];
    }else{
        _flashModel.is_praise = @"1";
        NSInteger priseCount = [_flashModel.hits integerValue];
        priseCount++;
        _flashModel.hits = [NSString stringWithFormat:@"%ld",priseCount];
    }
    [self updateWithModel];
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setObject:[UserInfo share].uId forKey:@"uid"];
    [bodyDic setObject:_flashModel.theId forKey:@"flash_id"];
    [bodyDic setObject:_flashModel.is_praise forKey:@"is_praise"];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JFlashPraise Handler:^(NSDictionary * jsonMessage, NSError *error){
        if (!error) {
            if ([jsonMessage[@"code"]integerValue] == 1) {
                
                
            }else{
                [SVProgressHUD showWithString:jsonMessage[@"msg"]];
            }
        }
    }];
}
-(void)shareBVClick
{
    FlashSharePreviewVC * previewVC = [[FlashSharePreviewVC alloc]init];
    previewVC.model = _flashModel;
    [self.viewController presentViewController:previewVC animated:YES completion:nil];
}
-(UICollectionViewFlowLayout *)createLayout
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    //layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //最小行间距
    layout.minimumLineSpacing = 10;
    //item尺寸
    //    layout.itemSize = CGSizeMake((VIEW_WIDTH - 50)/4, 60);
    //组的四周边距上左下右咯
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    return layout;
}
-(void)setupCollectionView{
    
    //注册cell类型及复用标识
    [self.collectionV registerNib:[UINib nibWithNibName:@"FlashImgCVCell" bundle:nil] forCellWithReuseIdentifier:@"ImgCellId"];

    self.collectionV.collectionViewLayout = [self createLayout];
    
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
//设置collectionView的item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREEN_WIDTH - 90 - 30)/3,(SCREEN_WIDTH - 90 - 30)/3);
    
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _flashModel.imageArr.count;
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FlashImgCVCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImgCellId" forIndexPath:indexPath];
    FlashImgsModel * imgModel = _flashModel.imageArr[indexPath.row];
    [cell.imgV sd_setImageWithURL:imgModel.imgurl];
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = indexPath.item;
    photoBrowser.imageCount = _flashModel.imageArr.count;
    photoBrowser.sourceImagesContainerView = self.collectionV;
    [photoBrowser show];
    
    
    
}

#pragma mark  SDPhotoBrowserDelegate

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    // 不建议用此种方式获取小图，这里只是为了简单实现展示而已
    FlashImgCVCell *cell = (FlashImgCVCell *)[self collectionView:self.collectionV cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    
    return cell.imgV.image;
    
}

@end
