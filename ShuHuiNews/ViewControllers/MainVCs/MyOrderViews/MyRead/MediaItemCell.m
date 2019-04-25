//
//  MediaItemCell.m
//  ShuHuiNews
//
//  Created by ding on 2019/4/3.
//  Copyright © 2019年 耿一. All rights reserved.
//

#import "MediaItemCell.h"

@implementation MediaItemCell
{
    UIImageView *_image;
    UILabel *_titleLb;
    UILabel *_beanLb;
    UILabel *_playLb;
    UILabel *_timeLb;
    UIButton *_cancelBtn;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        for (UIView *sub  in self.contentView.subviews) {
            [sub removeFromSuperview];
        }
        [self createUI];
    }
    return self;
}
- (void)createUI{
    UIView *contentView = self.contentView;
    
    _image = [UIImageView new];
    CGFloat ten = 15;
    _image.frame = CGRectMake(ten, ten, 70, 90);
    [contentView addSubview:_image];
    
    _titleLb = [UILabel new];
    _titleLb.frame = CGRectMake(_image.right+5, ten, SCREEN_WIDTH, 20);
    [contentView addSubview:_titleLb];
    _titleLb.textColor = [UIColor blackColor];
    _titleLb.font = [UIFont systemFontOfSize:16];
    _titleLb.numberOfLines = 0;
    
   
    
    UIImageView *playImg = [[UIImageView alloc] initWithFrame:CGRectMake(_image.right+5, _image.bottom-14, 14, 14)];
    playImg.image = [UIImage imageNamed:@"myorder_play.png"];
    [contentView addSubview:playImg];
    
    _beanLb = [UILabel new];
    _beanLb.frame = CGRectMake(_titleLb.left, playImg.top-30, 100, 20);
    [contentView addSubview:_beanLb];
    _beanLb.textColor = RGB(0xa6a6a6);
    _beanLb.font = kFont_Lable_12;
    
    _playLb = [UILabel new];
    _playLb.frame = CGRectMake(playImg.right, playImg.top, 40, 14);
    [contentView addSubview:_playLb];
    _playLb.textColor = RGB(0xa6a6a6);
    _playLb.font  = kFont_Lable_10;
    
    UIImageView *timeImg = [[UIImageView alloc] initWithFrame:CGRectMake(_playLb.right+10, playImg.top, 14, 14)];
    timeImg.image = [UIImage imageNamed:@"myorder_time"];
    [contentView addSubview:timeImg];
    
    _timeLb = [[UILabel alloc] initWithFrame:CGRectMake(timeImg.right, playImg.top, 40, 14)];
    [contentView addSubview:_timeLb];
    _timeLb.textColor = RGB(0xa6a6a6);
    _timeLb.font = kFont_Lable_10;
    
    
    
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-85, _image.bottom-30, 70, 26)];
    [_cancelBtn setTitle:@"取消订阅" forState:UIControlStateNormal];
    [_cancelBtn.titleLabel setFont:kFont_Lable_14];
    [_cancelBtn setTitleColor:RGB(0xa6a6a6) forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_cancelBtn];
    _cancelBtn.layer.borderWidth = 1;
    _cancelBtn.layer.borderColor = RGB(0xa6a6a6).CGColor;
    _cancelBtn.layer.masksToBounds = YES;
    _cancelBtn.layer.cornerRadius = 13;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(ten, _image.bottom+ten, SCREEN_WIDTH-ten*2, 1)];
    lineView.backgroundColor = RGB(0xededed);
    [contentView addSubview:lineView];
}
- (void)setModel:(MediaItemModel *)model
{
    _model = model;
//    _image.image = [UIImage imageNamed:model.image];
//    _titleLb.text = model.title;
//    _beanLb.text = model.count;
//    _playLb.text = model.playCount;
//    _timeLb.text = model.timeCount;
    _image.image = [UIImage imageNamed:@"rDHeader@3x.png"];
    _titleLb.text = @"施展解读的第一批作品---黑石";
    _beanLb.text = @"699金豆";
    _playLb.text = @"63.3万";
    _timeLb.text = @"53.3万";
    
    
}
- (void)setBuyModel:(MediaItemMyBuyModel *)buyModel
{
    _buyModel  = buyModel;
    [_cancelBtn setTitle:@"继续阅读" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:RGBCOLOR(35, 122,229) forState:UIControlStateNormal];
     _cancelBtn.layer.borderColor = RGBCOLOR(35,122,229).CGColor;
    
    _image.image = [UIImage imageNamed:@"rDHeader@3x.png"];
    _titleLb.text = @"施展解读的第一批作品---黑石";
    _beanLb.text = @"699金豆";
    _playLb.text = @"63.3万";
    _timeLb.text = @"53.3万";
}
//- (void)setAlikeModel:(BookDetailAlikeModel *)alikeModel
//{
//    _alikeModel  = alikeModel;
//    [_cancelBtn setTitle:@"已订阅" forState:UIControlStateNormal];
//    [_cancelBtn setTitleColor:RGBCOLOR(35, 122,229) forState:UIControlStateNormal];
//    _cancelBtn.layer.borderColor = RGBCOLOR(35,122,229).CGColor;
//    
//    _image.image = [UIImage imageNamed:@"rDHeader@3x.png"];
//    _titleLb.text = @"施展解读的第一批作品---黑石";
//    _beanLb.text = @"699金豆";
//    _playLb.text = @"63.3万";
//    _timeLb.text = @"53.3万";
//}
- (void)cancelBtnClicked:(UIButton *)btn{
    if (self.cancelButtonClickedBlock) {
        self.cancelButtonClickedBlock();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
