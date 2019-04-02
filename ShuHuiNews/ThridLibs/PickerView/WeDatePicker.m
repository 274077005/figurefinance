//
//  WeDatePicker.m
//  WEMEX
//
//  Created by Zach on 2018/1/22.
//  Copyright © 2018年 Zach. All rights reserved.
//

#import "WeDatePicker.h"
#define DATE_FORMAT            @"yyyy-MM-dd"
@interface WeDatePicker()
{
    UIDatePicker* datePicker;
}
@end

@implementation WeDatePicker

- (id)init
{
    if (self = [super init]) {
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
        datePicker.backgroundColor = [UIColor clearColor];
        
        datePicker.date = [self dateAddYear:[NSDate date] yearNum:0]; //默认差几年
        datePicker.maximumDate = [self dateAddYear:[NSDate date] yearNum:50]; //最大可选
        datePicker.minimumDate = [self dateAddYear:[NSDate date] yearNum:-50]; //最小可选
        
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.layer.borderWidth = 0.5;
        datePicker.layer.borderColor = RGB(0xB3B3B3).CGColor;
        
        [self addContentView:datePicker];
    }
    return self;
}

- (void)onBtnOKtouched:(UIButton*)button
{
    if (self.respBlocker) {
        self.respBlocker([self dateToStr:datePicker.date dateFormat:DATE_FORMAT]);
    }
    [self close];
}
-(NSDate*)dateAddYear:(NSDate*) date yearNum:(int)year_num
{
    int src_year = [[self dateToStr:date dateFormat:@"yyyy"] intValue];
    NSString* dst_date1 = [self dateToStr:date dateFormat:@"MM-dd"];
    if ([dst_date1 isEqualToString:@"02-29"]) {
        dst_date1 = @"02-28";
    }
    NSString* dst_date = formatSTR(@"%d-%@", (src_year+year_num), dst_date1);
    return [self strToDate:dst_date dateFormat:DATE_FORMAT];
}
-(NSDate *)strToDate:(NSString *)strDate dateFormat:(NSString *)dateFormat
{
    if (isNullStr(strDate)) return nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:dateFormat];
    NSDate *resdate = [dateFormatter dateFromString:strDate];
    return resdate;
}
-(NSString *)dateToStr:(NSDate *)date dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:dateFormat];
    NSString* strDate = [dateFormatter stringFromDate:date];
    return strDate;
}
@end
