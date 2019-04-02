//
//  AddFlashVC.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/9/10.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "AddFlashVC.h"

@interface AddFlashVC ()
{
    NSArray * _btnArr;
    
    NSMutableArray * _imgsArr;
    NSInteger _typeValue;  //记录选择的什么类型
    
    
}

@end

@implementation AddFlashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"新建快讯";
    _typeValue = 1;
    _btnArr = @[_forexBtn,_chainBtn];
    self.topHeight.constant = TopHeight;
    _imgsArr = [[NSMutableArray alloc]init];
    
    [self setupCollectionView];

    // Do any additional setup after loading the view from its nib.
}
- (IBAction)typeBtnClick:(UIButton *)sender {
    for (UIButton * btn in _btnArr) {
        btn.backgroundColor = RGBCOLOR(246, 246, 246);
        [btn setTitleColor:RGBCOLOR(31, 31, 31) forState:UIControlStateNormal];
    }
    sender.backgroundColor = RGBCOLOR(35, 122, 229);
    
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _typeValue = sender.tag;
    
    
}

- (IBAction)submitBtnClick:(UIButton *)sender {
    if (_titleTF.text.length < 1 || _contentTV.text.length <1) {
        [SVProgressHUD showWithString:@"*为必填项哦"];
        return;
    }
    NSMutableDictionary * bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setObject:_titleTF.text forKey:@"title"];
    [bodyDic setObject:@(_typeValue) forKey:@"flash_type"];
    [bodyDic setObject:_contentTV.text forKey:@"content"];
    [bodyDic setObject:_urlTF.text forKey:@"origin_link"];
    
    NSMutableArray * imgStrArr = [[NSMutableArray alloc]init];
    for (UIImage * image in _imgsArr) {
        NSData *data = [GYToolKit compressImageQuality:image toKb:500];
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSString * imageStr = [NSString stringWithFormat:@"data:image/png;base64,%@",encodedImageStr];
        [imgStrArr addObject:imageStr];
    }
    NSString * imgStr = [imgStrArr componentsJoinedByString:@"||"];
    [bodyDic setObject:imgStr forKey:@"flash_images"];
    [SVProgressHUD show];
    [GYPostData PostInfomationWithDic:bodyDic UrlPath:JAddFlash Handler:^(NSDictionary *jsonDic, NSError * error) {
        
        if (!error) {
            if ([jsonDic[@"code"] integerValue] == 1) {
                [SVProgressHUD showWithString:@"提交成功，等待审核~"];
                if (self.submitBlock) {
                    self.submitBlock();
                }
                
                [self postDataSucceed];
            }else{
                [SVProgressHUD showWithString:jsonDic[@"msg"]];
            }
        }
        
        
    }];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 80.0f;
    [self.view registerAsDodgeViewForMLInputDodger];
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.holdLab.hidden = YES;
}
-(UICollectionViewFlowLayout *)createLayout
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    //layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //最小行间距
    layout.minimumLineSpacing = 10;
    //item尺寸
    //    layout.itemSize = CGSizeMake((VIEW_WIDTH - 50)/4, 60);
    //组的四周边距上左下右咯
    layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    
    return layout;
}
-(void)setupCollectionView{
    
    //注册cell类型及复用标识
    [self.collectionV registerNib:[UINib nibWithNibName:@"AddDiaryCVCell" bundle:nil] forCellWithReuseIdentifier:@"AddCellId"];
    self.collectionV.delegate = self;
    self.collectionV.dataSource = self;
    self.collectionV.collectionViewLayout = [self createLayout];
    
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
//设置collectionView的item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREEN_WIDTH - 50)/3,(SCREEN_WIDTH - 50)/3);
    
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_imgsArr.count == 3) {
        return 3;
    }
    
    return _imgsArr.count +1;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AddDiaryCVCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddCellId" forIndexPath:indexPath];
    if (indexPath.row == _imgsArr.count && _imgsArr.count !=3) {
        cell.imgV.image = [UIImage imageNamed:@"addFlashImg"];
        cell.deleteBtn.hidden = YES;
    }else{
        cell.imgV.image = _imgsArr[indexPath.row];
        cell.deleteBtn.hidden = NO;
        cell.deleteBtn.tag = indexPath.row;
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
    if (indexPath.row == _imgsArr.count) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3-_imgsArr.count delegate:self];
        
        
        
        [self presentViewController:imagePickerVc animated:YES completion:nil];
        
    }else{
        SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
        photoBrowser.delegate = self;
        photoBrowser.currentImageIndex = indexPath.item;
        photoBrowser.imageCount = _imgsArr.count;
        photoBrowser.sourceImagesContainerView = self.collectionV;
        [photoBrowser show];
    }
    
    
}
- (void)deleteBtnClick:(UIButton *)btn
{
    [_imgsArr removeObjectAtIndex:btn.tag];
    [self.collectionV reloadData];
}



//照片选择协议
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    [_imgsArr addObjectsFromArray:photos];
    NSLog(@"%@",_imgsArr);
    [self.collectionV reloadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  SDPhotoBrowserDelegate

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    // 不建议用此种方式获取小图，这里只是为了简单实现展示而已
    AddDiaryCVCell *cell = (AddDiaryCVCell *)[self collectionView:self.collectionV cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    
    return cell.imgV.image;
    
}



@end
