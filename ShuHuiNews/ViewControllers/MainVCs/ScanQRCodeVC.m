//
//  ScanQRCodeVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/20.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "ScanQRCodeVC.h"
#import <AVFoundation/AVFoundation.h>
@interface ScanQRCodeVC ()<AVCaptureMetadataOutputObjectsDelegate>
{
    UIImageView* m_bgView;
    
    UIImageView* m_line;
}
//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;

//设置输出类型为Metadata，因为这种输出类型中可以设置扫描的类型，譬如二维码
//当启动摄像头开始捕获输入时，如果输入中包含二维码，就会产生输出
@property(nonatomic)AVCaptureMetadataOutput *output;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation ScanQRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫码";
    self.allBV.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
#if !TARGET_IPHONE_SIMULATOR
    [self judgeCamera];
#endif
    
    [self buildScanWin];
//
    [self animateLine];
    
    [self.view bringSubviewToFront:_allBV];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.session startRunning];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}
- (void)onScanSuccess:(NSString*)info {
    if (isNullStr(info)) return;
    
    if ([info containsString:@"figurefinance.com/login"]||[info containsString:@"fifin.com/login"]) {
        NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
        NSArray * tidArr = [info componentsSeparatedByString:@"tid="];
        
        [bodyDic setObject:tidArr[1] forKey:@"tid"];
        
        [bodyDic setObject:[UserInfo share].uId forKey:@"id"];
        [bodyDic setObject:[UserInfo share].token forKey:@"app_token"];
        
        NSString * UrlStr = [GYToolKit dictionaryToPostStr:bodyDic];
        
        NSString * endStr = [GYToolKit URLEncode:UrlStr];
        
        NSArray * urlArr = [info componentsSeparatedByString:@"?"];
        
        
        [GYPostData GetQRCodeInfomationWithHeaderUrl:urlArr.firstObject UrlPath:endStr Handler:^(NSDictionary * jsonMessage, NSError * error) {
            if (!error) {
                if ([jsonMessage[@"code"] integerValue] == 1) {
                    //加好友;
                    [SVProgressHUD showWithString:@"登陆成功~"];
                    [self postDataSucceed];
                }else{
                    [SVProgressHUD showWithString:jsonMessage[@"msg"]];
                    
                }
            }else{
                [self postDataSucceed];
            }
            
        }];
        //如果是扫描的其他用户的二维码
    }else if ([info containsString:@"user_message"]){
        
        RingDetailVC * detailVC = [[RingDetailVC alloc]init];
        NSArray * uidArr = [info componentsSeparatedByString:@"uid=shu"];
        NSInteger uId = [uidArr.lastObject integerValue]/542354;
        detailVC.writeId = [NSString stringWithFormat:@"%ld",uId];
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else if ([info containsString:@"http"]){
        BaseWebVC * webVC = [[BaseWebVC alloc]init];
        webVC.urlStr = info;
        [self.navigationController pushViewController:webVC animated:YES];
        
    }
    
    
    
}

- (void)buildScanWin {
    
    m_line = [[UIImageView alloc]initWithImage:IMG_Name(@"qr_scan_line")];
    [_scanV addSubview:m_line];
    m_line.fy = -m_line.fh;
    m_line.cx = _scanV.fw/2;
}

- (void)animateLine {
    m_line.fy = -m_line.fh;
    WeakSelf;
    [UIView animateWithDuration:3 animations:^{
        m_line.fy = _scanV.fh+m_line.fh;
    } completion:^(BOOL finished) {
        [weakSelf animateLine];

    }];
}
- (void)judgeCamera
{
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"未获得授权使用摄像头" message:@"请在\"设置\"-\"数汇资讯\"-\"相机\"打开授权" preferredStyle:UIAlertControllerStyleAlert];
        //添加操作
        
        [ac addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self.navigationController presentViewController:ac animated:YES completion:nil];
    }else{
        [self buildCaptureDevice];
    }
}

- (void)buildCaptureDevice {
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc]init];
    
    //设置代理，一旦扫描到指定类型的数据，就会通过代理输出
    //在扫描的过程中，会分析扫描的内容，分析成功后就会调用代理方法在队列中输出
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc] init];
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    //指定当扫描到二维码的时候，产生输出
    //AVMetadataObjectTypeQRCode 指定二维码
    //指定识别类型一定要放到添加到session之后
    
    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    //设置扫描信息的识别区域，左上角为(0,0),右下角为(1,1),不设的话全屏都可以识别。设置过之后可以缩小信息扫描面积加快识别速度。
    
    [self.output setRectOfInterest:CGRectMake(_scanV.top /SCREEN_HEIGHT ,_scanV.left/SCREEN_WIDTH, _scanV.bottom/SCREEN_HEIGHT, _scanV.right/SCREEN_WIDTH)];
    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_HEIGHT);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    
    //开始启动
    [self.session startRunning];
    
    
}

#pragma mark 输出的代理
//metadataObjects ：把识别到的内容放到该数组中
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //停止扫描
    [self.session stopRunning];
    if ([metadataObjects count] >= 1) {
        //数组中包含的都是AVMetadataMachineReadableCodeObject 类型的对象，该对象中包含解码后的数据
        AVMetadataMachineReadableCodeObject *qrObject = [metadataObjects lastObject];
        //拿到扫描内容在这里进行个性化处理
        NSLog(@"识别成功:%@",qrObject.stringValue);
        [self onScanSuccess:qrObject.stringValue];
        //        mainThread(onScanSuccess:, qrObject.stringValue);
    }
}

@end


