//
//  FlashNormalTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/9/11.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "FlashNormalTVCell.h"

@implementation FlashNormalTVCell{
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
-(void)updateWithModel
{
    [self.headerBtn sd_setImageWithURL:_flashModel.image forState:UIControlStateNormal];
    self.timeLab.text = _flashModel.minutes;
    self.titleLab.text = _flashModel.title;
    if (_flashModel.type == 1) {
        self.titleLab.hidden = YES;
        self.titleLHeight.constant = 0;
        self.contentTop.constant = 0;
    }else{
        self.titleLab.hidden = NO;
        self.titleLHeight.constant = 20;
        self.contentTop.constant = 5;
    }
    
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
//    FlashShareV * shareV =  [[[NSBundle mainBundle] loadNibNamed:@"FlashShareV" owner:nil options:nil] lastObject];
//    shareV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    [shareV updateWithContentStr:_flashModel];
//    
//    UIImage * shareImg = [GYToolKit snapshotSingleView:shareV.contentV];
//    
//    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//    NSArray* imageArray = @[shareImg];
//    [shareParams SSDKSetupShareParamsByText:@"数汇资讯"
//                                     images:imageArray
//                                        url:nil
//                                      title:@"快讯"
//                                       type:SSDKContentTypeImage];
//    
//    [GYToolKit shareSDKToShare:shareParams];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
