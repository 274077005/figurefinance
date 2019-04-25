//
//  LableMessageCell.m
//  ShuHuiNews
//
//  Created by ding on 2019/4/19.
//  Copyright © 2019年 耿一. All rights reserved.
//

#import "LableMessageCell.h"
#import "WHC_StackView.h"

@implementation LableMessageCell
{
    WHC_StackView * stackView1, *stackView2;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
    }
    return self;
}
- (UILabel *)createLb:(NSString *)name
{
    UILabel *Lb = [[UILabel alloc] init];
    Lb.text = name;
    Lb.backgroundColor = RGBCOLOR(246, 246, 246);
    Lb.textColor = RGBCOLOR(51, 51, 51);
    Lb.font = [UIFont systemFontOfSize:13];
    Lb.textAlignment = NSTextAlignmentCenter;
    Lb.layer.cornerRadius = 15;
    Lb.layer.masksToBounds = YES;
    return Lb;
}
- (void)setLabelAry:(NSArray *)labelAry
{
    _labelAry = labelAry;
    // 创建容器视图12
    stackView1 = [WHC_StackView new];
    stackView2 = [WHC_StackView new];
    [self.contentView addSubview:stackView2];
    [self.contentView addSubview:stackView1];
//    stackView1.backgroundColor = [UIColor orangeColor];
//    stackView2.backgroundColor = [UIColor magentaColor];
    // 容器视图1布局 一行代码添加约束
    [stackView1 whc_AutoWidth:0 top:0 right:0 height:30];
    [stackView1 whc_HeightEqualView:stackView2];
    
    // 容器视图1配置
    stackView1.whc_Edge =UIEdgeInsetsMake(0, 15, 0, 15);
    stackView1.whc_Orientation = Horizontal;// 自动横向布局
    stackView1.whc_HSpace = 10;
//    stackView1.whc_VSpace = 10;
    
    // 容器视图2配置
    stackView2.whc_Edge = UIEdgeInsetsMake(0, 15, 0, 15);
    stackView2.whc_Orientation = Horizontal;// 自动横向布局
    stackView2.whc_HSpace = 10;
//    stackView2.whc_VSpace = 10;
    // 容器视图2布局 一行代码添加约束
    stackView2.whc_LeftSpace(0)
    .whc_TopSpaceToView(10,stackView1)
    .whc_RightSpace(0)
    .whc_BottomSpace(0);
    for (int i=0; i<labelAry.count; i++) {
        UILabel *lb = [self createLb:labelAry[i]];
        if (i>2) {
            [stackView2 addSubview:lb];
            // 开始对容器进行自动布局
        
            [stackView2 whc_StartLayout];
        }else{
            [stackView1 addSubview:lb];
            // 开始对容器进行自动布局
            [stackView1 whc_StartLayout];
        }
        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
