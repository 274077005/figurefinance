//
//  SBookTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/25.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "SBookTVCell.h"

@implementation SBookTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)addBtnClick:(UIButton *)sender {
    self.numModel.bookNum++;
    
    NSLog(@"%ld",self.numModel.bookNum);
    self.numTF.text = [NSString stringWithFormat:@"%ld",self.numModel.bookNum];
    if (self.changeBlock) {
        self.changeBlock();
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([GYToolKit isPureInt:textField.text]) {
        self.numModel.bookNum = [textField.text integerValue];
        self.numTF.text = [NSString stringWithFormat:@"%ld",self.numModel.bookNum];
        if (self.changeBlock) {
            self.changeBlock();
        }
    }else{
        self.numTF.text = [NSString stringWithFormat:@"%ld",self.numModel.bookNum];
    }
    
    
}
- (IBAction)reduceBtnClick:(UIButton *)sender {
    if (self.numModel.bookNum == 1) {
        [SVProgressHUD showWithString:@"不能再减少啦~"];
        return;
    }
    self.numModel.bookNum--;
    self.numTF.text = [NSString stringWithFormat:@"%ld",self.numModel.bookNum];
    if (self.changeBlock) {
        self.changeBlock();
    }
}
- (void)updateWithModel
{
    self.nameLab.text = _bookModel.name;
    [self.coverImgV sd_setImageWithURL:_bookModel.img_info];
    self.publishLab.text = _bookModel.publish;
    self.autherLab.text = [NSString stringWithFormat:@"作者:%@",_bookModel.author];
    self.priceLab.text = [NSString stringWithFormat:@"￥%@",_bookModel.price];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
