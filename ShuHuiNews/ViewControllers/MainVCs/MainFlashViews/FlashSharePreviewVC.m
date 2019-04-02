//
//  FlashSharePreviewVC.m
//  HuiyouNet
//
//  Created by 耿一 on 2018/11/13.
//  Copyright © 2018 耿一. All rights reserved.
//

#import "FlashSharePreviewVC.h"

@interface FlashSharePreviewVC ()
{
    NSArray * _imgVArr;
    NSArray * _heightArr;
}

@end

@implementation FlashSharePreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateWithModel];
    // Do any additional setup after loading the view from its nib.
}
- (void)updateWithModel
{
    _imgVArr = @[_firstImgV,_secondImgV,_thridImgV];
    _heightArr = @[_firstHeight,_secondHeight,_thridHeight];
    
    CGFloat contentH = 0.0;
    self.titleLab.text = _model.title;
    NSString * contentStr = _model.content;
    
    [_headerImgV sd_setImageWithURL:_model.image];
    _timeLab.text = _model.addtime;
    
    CGFloat labelH = [GYToolKit AttribLHWithSpace:5 size:13 width:SCREEN_WIDTH - 30 str:contentStr];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentStr];
    NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
    
    
    [paragraphStyle setLineSpacing:5.0];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, [attributedString length])];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
    _contentLab.attributedText = attributedString;
    
    for (NSInteger i = 0; i < _model.imageArr.count; i++) {
        FlashImgsModel * img_model = _model.imageArr[i];
        contentH += 25;
        CGFloat height = (SCREEN_WIDTH - 30) * ([img_model.height floatValue]/[img_model.width floatValue]);
        NSLog(@"%f",height);
        NSLayoutConstraint * imgVH = _heightArr[i];
        imgVH.constant = height;
        UIImageView * imgV = _imgVArr[i];
        imgV.hidden = NO;
        [imgV sd_setImageWithURL:img_model.imgurl];
        contentH += height;
        NSLog(@"%f",contentH);
    }
    
    
    contentH = contentH + labelH + 280 + SCREEN_WIDTH *175/375;
    if (contentH < 330) {
        contentH = 330;
    }
    
    self.contentHeight.constant = contentH;
    [self.contentV layoutIfNeeded];
}
- (IBAction)shareBtnClick:(UIButton *)sender {
//    1 22 23
    NSArray * arr = @[@(1),@(22),@(23)];
        UIImage * shareImg = [GYToolKit snapshotSingleView:self.contentV];
    
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        NSArray* imageArray = @[shareImg];
        [shareParams SSDKSetupShareParamsByText:@"汇友网"
                                         images:imageArray
                                            url:nil
                                          title:@"快讯"
                                           type:SSDKContentTypeImage];
        NSInteger shareType = [arr[sender.tag] integerValue];

        [ShareSDK share:shareType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            switch (state) {
                case SSDKResponseStateSuccess:
                {

                    [SVProgressHUD showWithString:@"分享成功"];
                    
                    break;
                }
                    
                case SSDKResponseStateFail:
                {
                    NSLog(@"%@",error);
                    
                    [SVProgressHUD showWithString:@"分享失败"];
                    break;
                }
                default:
                    break;
            }

        }];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)cancelBtnClick:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
