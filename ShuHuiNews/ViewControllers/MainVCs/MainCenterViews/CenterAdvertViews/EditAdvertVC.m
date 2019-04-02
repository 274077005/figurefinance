//
//  EditRegulationVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/23.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "EditAdvertVC.h"

@interface EditAdvertVC ()
{
    PhotoPicker * _photoPicker;
    NSArray * _keyArr;
    NSArray * _tfArr;
    NSString * _imgStr;
}
@end

@implementation EditAdvertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加广告";
    self.topHeight.constant = TopHeight;
    _imgStr = @"";
    _keyArr = @[@"account",@"varieties",@"speed",@"type",@"min_num",@"min_money"];
    if (_isEdit) {
        self.navigationItem.title = @"编辑广告";
        [self.view bringSubviewToFront:_deleteBV];
        [self setUpContentView];
        self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(submitBtnClick)];
        [self.navigationItem.rightBarButtonItem setTintColor:WD_BLUE];
    }
    self.advertImgV.userInteractionEnabled = YES;
    UITapGestureRecognizer * imgVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgVClick)];
    [self.advertImgV addGestureRecognizer: imgVTGR];

}

-(void)setUpContentView
{
    if (self.adModel.ad_url.length > 0) {
        [_advertImgV sd_setImageWithURL:IMG_URL(self.adModel.ad_url)];
    }
    self.nameTF.text = _adModel.ad_name;
    self.linkTF.text = _adModel.ad_link;
}
- (void)imgVClick
{
    _photoPicker = [[PhotoPicker alloc]init];
    WeakSelf;
    _photoPicker.parentVC =self;
    //        weak_type(_photoPicker);
    _photoPicker.pickBlock = ^(UIImage* image){
        weakSelf.advertImgV.image = image;
        NSData *data = [GYToolKit compressImageQuality:image toKb:500];
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSString * imageStr = [NSString stringWithFormat:@"data:image/png;base64,%@",encodedImageStr];
        _imgStr = imageStr;
        //        [weakSelf postEditMessageWithKey:@"image" value:imageStr];
    };
    [_photoPicker pickWithSize:CGSizeZero ImageName:@"avatar_img.jpg"];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 80.0f;
    [self.view registerAsDodgeViewForMLInputDodger];
}
-(void)submitBtnClick
{
    [self SaveAdvertData];
}
- (IBAction)submitBtnClick:(UIButton *)sender {
    [self SaveAdvertData];
}
//保存
-(void)SaveAdvertData
{

    if ((_nameTF.text.length < 1 || _linkTF.text.length < 1)||(_adModel.ad_url.length < 1 &&_imgStr.length <1)) {
        [SVProgressHUD showWithString:@"请填写完整哦~"];
        return;
    }
    
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setObject:_nameTF.text forKey:@"ad_name"];
    [bodyDic setObject:_linkTF.text forKey:@"ad_link"];
    
    [bodyDic setObject:_imgStr forKey:@"ad_url"];
    if (_isEdit) {
        [bodyDic setObject:self.adModel.theId forKey:@"id"];
    }
    [SVProgressHUD show];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JSaveAdvert Handler:^(NSDictionary * jsonMessage, NSError *error){
        
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
- (IBAction)cancelBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)deleteBtnClick:(UIButton *)sender {
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];

    if (_isEdit) {
        [bodyDic setObject:self.adModel.theId forKey:@"id"];
    }
    [SVProgressHUD show];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JDeleteAdvert Handler:^(NSDictionary * jsonMessage, NSError *error){
        
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
