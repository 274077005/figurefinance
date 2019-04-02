//
//  PickerChoiceView.m
//  TFPickerView
//
//  Created by TF_man on 16/5/11.
//  Copyright © 2016年 tituanwang. All rights reserved.
//
//屏幕宽和高
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)


// 缩放比
#define kScale ([UIScreen mainScreen].bounds.size.width) / 375

#define hScale ([UIScreen mainScreen].bounds.size.height) / 667

//字体大小
#define kfont 15

#import "ProvidePickerV.h"
#import "Masonry.h"

@interface ProvidePickerV ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong)UIView *bgV;

@property (nonatomic,strong)UIButton *cancelBtn;

@property (nonatomic,strong)UIButton *conpleteBtn;


@property (nonatomic,strong)UIPickerView *pickerV;

@property (nonatomic,strong)NSMutableArray *array;
@end

@implementation ProvidePickerV

- (instancetype)init{
    
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)]) {
        
        self.array = [NSMutableArray array];
        
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = RGBACOLOR(51, 51, 51, 0.3);
        self.bgV = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 220*hScale)];
        self.bgV.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgV];
        
        [self showAnimation];
        
        //取消
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgV addSubview:self.cancelBtn];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(50);
            
        }];
        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:kfont];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //完成
        self.conpleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgV addSubview:self.conpleteBtn];
        [self.conpleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(50);
            
        }];
        self.conpleteBtn.titleLabel.font = [UIFont systemFontOfSize:kfont];
        [self.conpleteBtn setTitle:@"完成" forState:UIControlStateNormal];
        [self.conpleteBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.conpleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //选择titi
        self.selectLb = [UILabel new];
        [self.bgV addSubview:self.selectLb];
        [self.selectLb mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(self.bgV.mas_centerX).offset(0);
            make.centerY.mas_equalTo(self.conpleteBtn.mas_centerY).offset(0);
            
        }];
        self.selectLb.font = [UIFont systemFontOfSize:kfont];
        self.selectLb.textAlignment = NSTextAlignmentCenter;
        
        //线
        UIView *line = [UIView new];
        [self.bgV addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.cancelBtn.mas_bottom).offset(0);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(0.5);
            
        }];
        line.backgroundColor = RGBACOLOR(224, 224, 224, 1);
        
        //选择器
        self.pickerV = [UIPickerView new];
        [self.bgV addSubview:self.pickerV];
        self.pickerV.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self.pickerV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(line.mas_bottom).offset(0);
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            
        }];
        self.pickerV.delegate = self;
        self.pickerV.dataSource = self;
        
        
        
    }
    return self;
}

- (void)setCustomArr:(NSArray *)customArr{
    
    _customArr = customArr;
    [self.array addObject:customArr];
    
}

- (void)setArrayType:(ARRAYTYPE)arrayType
{
    _arrayType = arrayType;
    switch (arrayType) {
        case urlType:
        {
            self.selectLb.text = @"选择网址类型";
            [self.array addObject:@[@"中文网址",@"英文网址"]];
        }
            break;
        case countryType:
        {
            self.selectLb.text = @"选择国家";
            [self.array addObject:@[@"中国大陆(+86)",@"香港(+852)",@"澳门(+853)",@"台湾(+886)",@"泰国(+66)",@"马来西亚(+60)",@"印尼(+62)",@"柬埔寨(+855)",@"老挝(+856)",@"越南(+84)",@"菲律宾(+63)",@"缅甸(+0095)",@"澳大利亚(+61)",@"英国(+44)"]];
        }
            break;
        case periodType:
        {
            self.selectLb.text = @"选择工作时长";
            [self.array addObject:@[@"一年以内",@"一到三年",@"三到五年",@"五年以上",@"未知"]];
        }
            break;
        case educationType:
        {
            self.selectLb.text = @"选择学历";
            [self.array addObject:@[@"博士",@"硕士",@"本科",@"大专",@"中专",@"高中",@"初中以下"]];
        }
            break;
        case marriageType:
        {
            self.selectLb.text = @"选择婚姻状态";
            [self.array addObject:@[@"未婚",@"已婚未育",@"已婚已育",@"离异",@"其他"]];
        }
            break;
        case timeType:{
            self.selectLb.text = @"选择出生年月";
            [self creatDate];
        }
            break;
        default:
            break;
    }
}
- (void)creatDate{
    
    
    NSMutableArray *yearArray = [[NSMutableArray alloc] init];
    for (int i = 1970; i <= 2020 ; i++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d年",i]];
    }
    [self.array addObject:yearArray];
    
    NSMutableArray *monthArray = [[NSMutableArray alloc]init];
    for (int i = 1; i < 13; i ++) {
        
        [monthArray addObject:[NSString stringWithFormat:@"%d月",i]];
    }
    [self.array addObject:monthArray];
    
    NSMutableArray *daysArray = [[NSMutableArray alloc]init];
    for (int i = 1; i < 32; i ++) {
        
        [daysArray addObject:[NSString stringWithFormat:@"%d日",i]];
    }
    [self.array addObject:daysArray];
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy"];
    NSString *currentYear = [NSString stringWithFormat:@"%@年",[formatter stringFromDate:date]];
    [self.pickerV selectRow:[yearArray indexOfObject:currentYear]+81*50 inComponent:0 animated:YES];
    
    [formatter setDateFormat:@"MM"];
    NSString *currentMonth = [NSString stringWithFormat:@"%ld月",(long)[[formatter stringFromDate:date]integerValue]];
    [self.pickerV selectRow:[monthArray indexOfObject:currentMonth]+12*50 inComponent:1 animated:YES];
    
    [formatter setDateFormat:@"dd"];
    NSString *currentDay = [NSString stringWithFormat:@"%@日",[formatter stringFromDate:date]];
    [self.pickerV selectRow:[daysArray indexOfObject:currentDay]+31*50 inComponent:2 animated:YES];
}

#pragma mark-----UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return self.array.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    NSArray * arr = (NSArray *)[self.array objectAtIndex:component];

    return arr.count;
        

    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    //设置分割线的颜色
    
    for(UIView *singleLine in pickerView.subviews)
        
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = RGBACOLOR(224, 224, 224, 1);
        }
        
    }
    UILabel *label=[[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    label.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    
    return label;
    
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSArray *arr = (NSArray *)[self.array objectAtIndex:component];
    return [arr objectAtIndex:row % arr.count];
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
    return 200;
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component

{
    
    return 50.0;
    
}
#pragma mark-----点击方法

- (void)cancelBtnClick{
    
    [self hideAnimation];
    
}

- (void)completeBtnClick{
    
    
    NSString *fullStr = [NSString string];
    for (int i = 0; i < self.array.count; i++) {
        
    
        NSArray *arr = [self.array objectAtIndex:i];
        
        
        NSString *str = [arr objectAtIndex:[self.pickerV selectedRowInComponent:i]];
        fullStr = [fullStr stringByAppendingString:str];
        
    }
    
    [self.delegate PickerSelectorIndixString:fullStr];
    
    [self hideAnimation];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self hideAnimation];
    
}

//隐藏动画
- (void)hideAnimation{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.bgV.frame;
        frame.origin.y = kScreenHeight;
        self.bgV.frame = frame;
        
    } completion:^(BOOL finished) {
        
        [self.bgV removeFromSuperview];
        [self removeFromSuperview];
        
    }];
    
}

//显示动画
- (void)showAnimation{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.bgV.frame;
        frame.origin.y = kScreenHeight-220*hScale;
        self.bgV.frame = frame;
    }];
    
}


@end
