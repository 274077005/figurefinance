//
//  DrawingBoardViewController.m
//  Treasure
//
//  Created by 蓝蓝色信子 on 2016/12/29.
//  Copyright © 2016年 GY. All rights reserved.
//

#import "DrawingBoardViewController.h"
#import "GYURLConnection.h"
@interface DrawingBoardViewController ()
{
    NSArray * _colorImagesArray;
    NSInteger _colorTypeNum;
    NSInteger _colorFBTypeNum;
    NSInteger _colorSBTypeNum;
    
    //lineType用到的
    NSArray * _lineTypeImagesArray;
    NSInteger _lineTypeNum;
    NSInteger _lineFBTypeNum;
    NSInteger _lineSBTypeNum;
    
}
@end

@implementation DrawingBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.drawImgV.image = self.drawImage;
    [self createLineType];

    
//    self.drawingView.drawToolType = DrawingToolTypeLine;
    // Do any additional setup after loading the view from its nib.
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//关闭按钮点击
- (IBAction)drawCloseBtnClick:(id)sender {
    
    if (self.drawingView.pathArray.count > 0) {
        UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"放弃此次编辑么？" preferredStyle:UIAlertControllerStyleAlert];
        //添加操作
        
        [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }]];
        [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        //模态弹出
        [self presentViewController:ac animated:YES completion:nil];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    

    
}
//绘图颜色选择
- (IBAction)drawColorBtnClick:(id)sender {
    [self hiddenLineTypeBtns];
    self.colorFirstBtn.hidden = !self.colorFirstBtn.hidden;
    self.colorSecondBtn.hidden = !self.colorSecondBtn.hidden;
    
}
- (IBAction)drawColorFirstBtnClick:(id)sender {
    NSInteger choseColorTypeNum;
    choseColorTypeNum = _colorFBTypeNum;
    _colorFBTypeNum = _colorTypeNum;
    _colorTypeNum = choseColorTypeNum;
    
    [self.colorFirstBtn setImage:[UIImage imageNamed:_colorImagesArray[_colorFBTypeNum]] forState:UIControlStateNormal];
    [self.drawColorBtn setImage:[UIImage imageNamed:_colorImagesArray[_colorTypeNum]] forState:UIControlStateNormal];
    [self hiddenColorTypeBtns];
    [self changeDrawColorType];
    
}

- (IBAction)drawColorSecondBtnClick:(id)sender {
    NSInteger choseColorTypeNum;
    choseColorTypeNum = _colorSBTypeNum;
    _colorSBTypeNum = _colorTypeNum;
    _colorTypeNum = choseColorTypeNum;
    
    [self.colorSecondBtn setImage:[UIImage imageNamed:_colorImagesArray[_colorSBTypeNum]] forState:UIControlStateNormal];
    [self.drawColorBtn setImage:[UIImage imageNamed:_colorImagesArray[_colorTypeNum]] forState:UIControlStateNormal];
    [self hiddenColorTypeBtns];
    [self changeDrawColorType];
    
}

//绘图方式点击
- (IBAction)drawLineTypeBtnClick:(id)sender {
    [self hiddenColorTypeBtns];
    self.drawTextBtn.selected = NO;
    self.lineTypeFirstBtn.hidden =  !self.lineTypeFirstBtn.hidden;
    self.lineTypeSecondBtn.hidden = !self.lineTypeSecondBtn.hidden;
    [self changeDrawToolType];
    
}
- (IBAction)lineTypeFirstBtnClick:(id)sender {
    NSInteger choseLineTypeNum;
    choseLineTypeNum = _lineFBTypeNum;
    _lineFBTypeNum = _lineTypeNum;
    _lineTypeNum = choseLineTypeNum;
    
    [self.lineTypeFirstBtn setImage:[UIImage imageNamed:_lineTypeImagesArray[_lineFBTypeNum]] forState:UIControlStateNormal];
    [self.lineTypeBtn setImage:[UIImage imageNamed:_lineTypeImagesArray[_lineTypeNum]] forState:UIControlStateNormal];
    [self hiddenLineTypeBtns];
    [self changeDrawToolType];
    
}
- (IBAction)lineTypeSecondBtnClick:(id)sender {
    
    NSInteger choseLineTypeNum;
    choseLineTypeNum = _lineSBTypeNum;
    _lineSBTypeNum = _lineTypeNum;
    _lineTypeNum = choseLineTypeNum;
    
    [self.lineTypeSecondBtn setImage:[UIImage imageNamed:_lineTypeImagesArray[_lineSBTypeNum]] forState:UIControlStateNormal];
    [self.lineTypeBtn setImage:[UIImage imageNamed:_lineTypeImagesArray[_lineTypeNum]] forState:UIControlStateNormal];
    [self hiddenLineTypeBtns];
    [self changeDrawToolType];
}
- (IBAction)drawBackBtnClick:(id)sender {
    
    [self.drawingView undoLastObject];
}

- (IBAction)drawTextBtnClick:(id)sender {
    self.drawTextBtn.selected = YES;
    self.drawingView.drawToolType = DrawingToolTypeText;
    
}
- (IBAction)shareImageBtnClick:(id)sender {
    
    UIImage * shareImg = [self getStockShareScreenImage];
    
    
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[shareImg];
    [shareParams SSDKSetupShareParamsByText:@"数汇资讯"
                                     images:imageArray
                                        url:nil
                                      title:@"行情"
                                       type:SSDKContentTypeImage];
    
    [GYToolKit shareSDKToShare:shareParams];

}


- (void)createLineType
{
    
    _colorFBTypeNum = 0;
    _colorSBTypeNum = 1;
    _colorTypeNum = 2;
    _colorImagesArray = @[@"drawRed",@"drawGreen",@"drawYellow"];
    
    _lineFBTypeNum = 0;
    _lineSBTypeNum = 1;
    _lineTypeNum = 2;
    _lineTypeImagesArray = @[@"drawRectangle",@"drawCircle",@"drawLine"];
}
- (void)hiddenColorTypeBtns
{
    self.colorFirstBtn.hidden = YES;
    self.colorSecondBtn.hidden = YES;
}
- (void)hiddenLineTypeBtns{
    self.lineTypeFirstBtn.hidden = YES;
    self.lineTypeSecondBtn.hidden = YES;
}

- (void)changeDrawColorType
{
    switch (_colorTypeNum) {
        case 0:
            self.drawingView.lineColor = [UIColor redColor];
            break;
        case 1:
            self.drawingView.lineColor = [UIColor greenColor];
            break;
        case 2:
            self.drawingView.lineColor = [UIColor orangeColor];
            break;
            
        default:
            break;
    }

}
- (void)changeDrawToolType{
    NSLog(@"type:%ld",_lineTypeNum);
    switch (_lineTypeNum) {
        case 0:
            self.drawingView.drawToolType = DrawingToolTypeRectangle;
            break;
        case 1:
            self.drawingView.drawToolType = DrawingToolTypeOval;
            break;
        case 2:
            self.drawingView.drawToolType = DrawingToolTypeArrow;
            break;
            
            default:
            break;
    }

}

- (UIImage *)getStockShareScreenImage{
    if(&UIGraphicsBeginImageContextWithOptions!=NULL)
    {

        UIGraphicsBeginImageContextWithOptions(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 50),NO,0);
    }
    CGContextRef context =UIGraphicsGetCurrentContext();
    for(UIWindow * window  in[[UIApplication sharedApplication]windows])
    {
  
        if(![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
    
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width* [[window layer]anchorPoint].x,
                                  -[window bounds].size.height* [[window layer]anchorPoint].y);
            
            [[window layer]renderInContext:context];
            
            CGContextRestoreGState(context);
            
        }
        
    }
    
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
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
