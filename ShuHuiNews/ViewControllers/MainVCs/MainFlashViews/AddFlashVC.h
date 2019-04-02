//
//  AddFlashVC.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/9/10.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BaseViewController.h"
#import "AddDiaryCVCell.h"
@interface AddFlashVC : BaseViewController<UITextViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,SDPhotoBrowserDelegate,TZImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UIButton *forexBtn;
@property (weak, nonatomic) IBOutlet UIButton *chainBtn;
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (weak, nonatomic) IBOutlet UITextField *urlTF;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionV;
@property (weak, nonatomic) IBOutlet UILabel *holdLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property(nonatomic,copy)void(^submitBlock)(void);
@end
