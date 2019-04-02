//
//  CenterAttestationVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/27.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "CenterAttestationVC.h"

@interface CenterAttestationVC ()
{
    PhotoPicker * _photoPicker;
    NSString * _imgStr;
}

@end

@implementation CenterAttestationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑认证信息";
    self.coverImgV.userInteractionEnabled = YES;
    UITapGestureRecognizer * coverTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverImgVClick)];
    [self.coverImgV addGestureRecognizer: coverTGR];
    
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(submitBtnClick)];
    [self.navigationItem.rightBarButtonItem setTintColor:WD_BLUE];
    
    if (self.coverUrl.length > 2) {
        [self.coverImgV sd_setImageWithURL:IMG_URL(self.coverUrl)];
        
    }
    // Do any additional setup after loading the view from its nib.
}
-(void)coverImgVClick
{
    _photoPicker = [[PhotoPicker alloc]init];
    WeakSelf;
    _photoPicker.parentVC =self;
    //        weak_type(_photoPicker);
    _photoPicker.pickBlock = ^(UIImage* image){
        weakSelf.coverImgV.image = image;
        NSData *data = [GYToolKit compressImageQuality:image toKb:500];
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSString * imageStr = [NSString stringWithFormat:@"data:image/png;base64,%@",encodedImageStr];
        NSLog(@"%@",imageStr);
        _imgStr = imageStr;
//        [weakSelf postEditMessageWithKey:@"image" value:imageStr];
    };
    [_photoPicker pickWithSize:CGSizeZero ImageName:@"avatar_img.jpg"];
}
-(void)submitBtnClick
{
    
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    
    [bodyDic setObject:_imgStr forKey:@"attestation_card"];
    
    [SVProgressHUD show];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JSaveAttestation Handler:^(NSDictionary * jsonMessage, NSError *error){
        
        if (!error) {
            if ([jsonMessage[@"code"] integerValue] == 1) {
                [SVProgressHUD showWithString:@"提交成功~"];
                [self postDataSucceed];
            }else{
                [SVProgressHUD showWithString:jsonMessage[@"msg"]];
            }
        }
        
    }];
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
