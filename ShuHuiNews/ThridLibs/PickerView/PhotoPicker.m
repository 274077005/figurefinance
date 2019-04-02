//
//  PhotoPicker.m
//  WEMEX
//
//  Created by Zach on 2018/1/17.
//  Copyright © 2018年 Zach. All rights reserved.
//

#import "PhotoPicker.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImageView+WebCache.h"

#define SCREEN_S            [UIScreen mainScreen].scale
@interface PhotoPicker ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    CGSize m_size;
    BOOL m_allowsEditing;
}
@end

@implementation PhotoPicker

- (id)init
{
    if (self = [super init]) {
        _imagePath = nil;
    }
    return self;
}

- (void)pickWithSize:(CGSize)size ImageName:(NSString*)name
{
    m_size = size;
    m_allowsEditing = !CGSizeEqualToSize(m_size, CGSizeZero);
    _imagePath = [[self getPathForPickImage] copy];
    
    if (size.width==SCREEN_WIDTH && size.height==SCREEN_WIDTH) {
        [self showCameraPicker:NO];
    } else {
        [self showPickDialog];
    }
}

- (void)showPickDialog
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择照片" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showCameraPicker:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.allowsEditing = m_allowsEditing;
        picker.delegate = self;
        picker.navigationBar.tintColor = RGB(0x333F41);
        
        [self.parentVC presentViewController:picker animated:YES completion:nil];;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
    [self.parentVC presentViewController:alert animated:true completion:nil];
}

- (void)showCameraPicker:(BOOL)animated
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = m_allowsEditing;
        [self.parentVC presentViewController:picker animated:animated completion:nil];
    } else {
        [SVProgressHUD showWithString:@"模拟器不支持相机"];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.parentVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = info[m_allowsEditing ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage];
    [self catchImage:image];
    //[UIImagePNGRepresentation(image) writeToFile:getPathForPickImage(PICK_TEMP_NAME) atomically:YES];
    [self.parentVC dismissViewControllerAnimated:YES completion:nil];
}


- (void)catchImage:(UIImage*)image
{
    //NSLog(@"BGN:%f", CFAbsoluteTimeGetCurrent());
    //缩小图片尺寸;
    UIImage* scaledImage = [self resizeImage:image];
    NSData* imgData = UIImageJPEGRepresentation(scaledImage, 0.9);
    
    //    if (![imgData writeToFile:_imagePath atomically:YES]) {
    //        return;
    //    }
    NSError* err;
    if (![imgData writeToFile:_imagePath options:NSDataWritingAtomic error:&err]) {
        NSLog(@"%@", err);
        //showAlert(@"图片缓存失败");
        return;
    }
    //NSLog(@"END:%f", CFAbsoluteTimeGetCurrent());
    
    UIImage* tmpimg = [UIImage imageWithContentsOfFile:_imagePath];
    if (self.pickBlock) {
        self.pickBlock(tmpimg);
    }
}

- (UIImage*)resizeImage:(UIImage*)image
{
    CGSize scaleSize = image.size;
    BOOL isPortrait = (image.size.height > image.size.width);
    if ( !m_allowsEditing ) {
        //整个图片，不用截取(上传照片用);
        if (isPortrait) {
            //纵向图片: 以宽为准，宽度缩小到手机分辨率宽(SCREEN_W * SCREEN_S)
            CGFloat target_w = SCREEN_WIDTH * SCREEN_S;
            if (scaleSize.width > target_w) {
                scaleSize.height = (target_w / scaleSize.width) * scaleSize.height;
                scaleSize.width = target_w;
            }
        } else {
            //横向图片: 以高为准，高度缩小到手机分辨率宽(SCREEN_W * SCREEN_S, 注：因为是横置手机，所以还用这个表达式);
            CGFloat target_h = SCREEN_WIDTH * SCREEN_S;
            if (scaleSize.height > target_h) {
                scaleSize.width = (target_h / scaleSize.height) * scaleSize.width;
                scaleSize.height = target_h;
            }
        }
    } else {
        
        //截取部分图片(头像用)
        scaleSize.width = m_size.width * SCREEN_S;
        scaleSize.height = m_size.height * SCREEN_S;
    }
    
    UIGraphicsBeginImageContext(scaleSize);
    [image drawInRect:CGRectMake(0, 0, scaleSize.width, scaleSize.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (scaledImage == nil) {
        //        showAlert(formatSTR(@"图片压缩失败(%d,%d)->(%d,%d)",
        //                         (int)image.size.width, (int)image.size.height,
        //                         (int)scaleSize.width, (int)scaleSize.height ));
    }
    return scaledImage;
}

- (NSString*) getPathForPickImage
{
    NSString* imgName = formatSTR(@"%@", [self getDataStrWithData:[NSDate date] :@"yyyyMMddHHmmss"]);
    NSString* imgPath = formatSTR(@"%@.jpg", [[SDImageCache sharedImageCache] defaultCachePathForKey:imgName]);
    NSString* catchDir = [imgPath stringByDeletingLastPathComponent];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:catchDir]) {
        [[SDImageCache sharedImageCache] storeImage:[UIImage imageNamed:@"logo"] forKey:@"logo.png" toDisk:YES completion:nil];
    }
    return imgPath;
}
- (NSString *)getDataStrWithData:(NSDate *)date :(NSString *)dateFormat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:dateFormat];
    NSString* strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

- (void)dealloc
{
    NSLog(@"picker dealloc调用");
}
@end
