//
//  CenterHeaderTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/20.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "CenterHeaderTVCell.h"
#import "EditCompanyInfoVC.h"
#import "EditPersonalInfoVC.h"
#import "MainQRCardVC.h"
@implementation CenterHeaderTVCell
{
    CALayer * _BVLayer;
    CALayer * _headerLayer;
    PhotoPicker * _photoPicker;
    UIImage * _headerImg;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UIView * ballView = [[UIView alloc]initWithFrame:CGRectMake(0, -500, SCREEN_WIDTH, 500)];
    ballView.backgroundColor = RGBCOLOR(35, 122, 229);
    [self addSubview:ballView];

}
- (IBAction)editBtnClick:(UIButton *)sender{
    if ([[UserInfo share].type isEqualToString:@"1"]) {
        EditCompanyInfoVC * editVC = [[EditCompanyInfoVC alloc]init];
        editVC.basicModel = _centerModel.basic;
        [self.viewContoller.navigationController pushViewController:editVC animated:YES];
    }else{
        EditPersonalInfoVC * editVC = [[EditPersonalInfoVC alloc]init];
        editVC.basicModel = _centerModel.basic;
        [self.viewContoller.navigationController pushViewController:editVC animated:YES];
    }

}
- (IBAction)headerBtnClick:(UIButton *)sender {
    _photoPicker = [[PhotoPicker alloc]init];
    WeakSelf;
    _photoPicker.parentVC =self.viewContoller;
    //        weak_type(_photoPicker);
    _photoPicker.pickBlock = ^(UIImage* image){
        _headerImg = image;
        [weakSelf.headerBtn setImage:image forState:UIControlStateNormal];
        NSData *data = [GYToolKit compressImageQuality:image toKb:50];
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSString * imageStr = [NSString stringWithFormat:@"data:image/png;base64,%@",encodedImageStr];
        [weakSelf postEditMessageWithKey:@"image" value:imageStr];
    };
    [_photoPicker pickWithSize:CGSizeMake(100, 100) ImageName:@"avatar_img.jpg"];
}
- (IBAction)QRBtnClick:(UIButton *)sender {
    CenterBasicModel * basicModel = _centerModel.basic;
    MainQRCardVC * QRVC = [[MainQRCardVC alloc]init];
    QRVC.CodeStr = basicModel.qr_code;
    QRVC.headerStr = basicModel.image;

    QRVC.nameStr = basicModel.nickname;
    [self.viewContoller.navigationController pushViewController:QRVC animated:YES];
}


-(void)updateWithModel
{
    
    CenterBasicModel * basicModel = _centerModel.basic;
    self.nameLab.text = basicModel.nickname;
    //在这里点击上传过头像之后，为了防止viewWillApper的影响，特此处理
    if (_headerImg) {
        [self.headerBtn setImage:_headerImg forState:UIControlStateNormal];
    }else{
        [self.headerBtn sd_setImageWithURL:IMG_URL(basicModel.image) forState:UIControlStateNormal];
    }
    
    
    if ([basicModel.attestation_type isEqualToString:@"1"]) {
        self.typeLab.text = @"类型: 企业";
        self.tagLab.text = basicModel.industry_name;
    }else{
        if(basicModel.sex == 1){
            self.tagLab.text = @"男";
            self.tagImgV.image = IMG_Name(@"sexMan");
        }else{
            self.tagLab.text = @"女";
            self.tagImgV.image = IMG_Name(@"sexWoman");
        }
        self.typeLab.text = @"类型: 个人";
    }
    self.descLab.text = basicModel.desc;
}
- (void)postEditMessageWithKey:(NSString *)key value:(NSString *)value
{
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    NSString * changeStr = [NSString stringWithFormat:@"%@&%@",key,value];
    [bodyDic setObject:changeStr forKey:@"change"];
    [SVProgressHUD show];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JSaveMainInfo Handler:^(NSDictionary * jsonMessage, NSError *error){
        [SVProgressHUD dismiss];
        if (!error) {
            if ([jsonMessage[@"code"] integerValue] == 1) {
                
            }else{
                [SVProgressHUD showWithString:jsonMessage[@"msg"]];
            }
        }
        
    }];
}
- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    _BVLayer = [[CALayer alloc] init];
    _BVLayer.position = _shadowBV.layer.position;
    _BVLayer.frame = _shadowBV.frame;
    _BVLayer.cornerRadius = _shadowBV.layer.cornerRadius;
    _BVLayer.backgroundColor = [UIColor whiteColor].CGColor;
    _BVLayer.shadowColor = [UIColor grayColor].CGColor;
    _BVLayer.shadowOffset = CGSizeMake(2, 2);
    _BVLayer.shadowOpacity = 0.3;
    [self.contentView.layer addSublayer:_BVLayer];
    [self.contentView bringSubviewToFront:_shadowBV];
    
    _headerLayer = [[CALayer alloc] init];
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
@end
