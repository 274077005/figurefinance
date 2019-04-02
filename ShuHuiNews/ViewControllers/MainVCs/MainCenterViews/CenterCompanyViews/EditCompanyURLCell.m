//
//  EditCompanyURLCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/27.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "EditCompanyURLCell.h"

@implementation EditCompanyURLCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer * typeBVTGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(typeBVClick)];
    [self.typeBV addGestureRecognizer: typeBVTGR];
    
    [self.urlTF addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    // Initialization code
}

-(void)updateWithModel
{
    if ([_coModel.type isEqualToString:@"0"]) {
        self.typeLab.text =@"中文网址";
    }else{
        self.typeLab.text =@"英文网址";
    }
    self.urlTF.text = _coModel.company_url;
}
-(void)textFieldDidChange{
    _coModel.company_url = self.urlTF.text;
}
-(void)typeBVClick
{
    ProvidePickerV *pickerV = [[ProvidePickerV alloc]init];
    
    pickerV.delegate = self;
    pickerV.arrayType = urlType;
    [KeyWindow addSubview:pickerV];
}
#pragma mark -------- TFPickerDelegate

- (void)PickerSelectorIndixString:(NSString *)str{
    self.typeLab.text = str;
    if ([str isEqualToString:@"中文网址"]) {
        _coModel.type = @"0";
    }else{
        _coModel.type = @"1";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)delBtnClick:(UIButton *)sender {
    
}

@end
