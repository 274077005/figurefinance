//
//  MainQRCardVC.m
//  WEMEX
//
//  Created by 耿一 on 2018/3/28.
//  Copyright © 2018年 Zach. All rights reserved.
//

#import "MainQRCardVC.h"
#import <CoreImage/CoreImage.h>
@interface MainQRCardVC ()

@end

@implementation MainQRCardVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的二维码";
    self.view.backgroundColor = RGB(0x2d3132);
    //如果其他页面有值传过来
    if (_nameStr) {

        [self setUpContentView];
    }else{
        [self getQRData];
    }
    


}
-(void)setUpContentView
{
    [_headImgV sd_setImageWithURL:IMG_URL(_headerStr)];
    _nameLab.text = _nameStr;
    _appImgV.image = [UIImage imageNamed:@"appIcon"];
    
    _QRImgV.image = [self buildQCode:_CodeStr Width:_QRImgV.width];
}
-(void)getQRData
{
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JMainCenter Handler:^(NSDictionary *jsonDic, NSError * error) {
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                self.centerModel = [MainCenterModel mj_objectWithKeyValues:jsonDic[@"data"]];
                CenterBasicModel * basicModel = _centerModel.basic;
            
                self.CodeStr = basicModel.qr_code;
                self.headerStr = basicModel.image;
                
                self.nameStr = basicModel.nickname;
                [self setUpContentView];
            }
        }
    }];
}
- (UIImage*)buildQCode:(NSString*)text Width:(CGFloat)width {
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    
    // 2. 给滤镜添加数据
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    // 使用KVC的方式给filter赋值
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 3. 生成二维码
    CIImage *image = [filter outputImage];
    
    UIImage* result = [self creatNonInterpolatedUIImageFormCIImage:image withSize:width];
    return result;
}

- (UIImage *)creatNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1. 创建bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
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
