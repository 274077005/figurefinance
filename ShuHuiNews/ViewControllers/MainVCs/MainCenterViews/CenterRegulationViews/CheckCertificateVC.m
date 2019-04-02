//
//  CheckCertificateVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/29.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "CheckCertificateVC.h"

@interface CheckCertificateVC ()

@end

@implementation CheckCertificateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"证明文件";
    UITapGestureRecognizer * clickTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClick)];
    [self.view addGestureRecognizer: clickTGR];
    if (_imgUrl.length > 0) {
        [SVProgressHUD show];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager loadImageWithURL:IMG_URL(self.imgUrl) options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (!error) {
                [SVProgressHUD dismiss];
                
                CGFloat scale = image.size.width/image.size.height;
                NSLog(@"%f",scale);
                UIImageView * imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH /scale)];
                imgV.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
                imgV.image = image;
                [self.view addSubview:imgV];
                
                
            }else{
                
                [SVProgressHUD showWithString:@"加载失败~"];
            }
        }];
    }else{
        CGFloat scale = _cerImg.size.width/_cerImg.size.height;
        NSLog(@"%f",scale);
        UIImageView * imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH /scale)];
        imgV.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        imgV.image = self.cerImg;
        [self.view addSubview:imgV];
    }
    
    // Do any additional setup after loading the view.
}
-(void)viewClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
