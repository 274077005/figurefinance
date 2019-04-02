//
//  SexPcker.m
//  WEMEX
//
//  Created by Zach on 2018/1/22.
//  Copyright © 2018年 Zach. All rights reserved.
//

#import "SexPcker.h"

@interface SexPcker()<UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIPickerView* m_pickerView;
    NSArray* m_data;
}
@end

@implementation SexPcker

- (id)init
{
    if (self = [super init]) {
        m_data = [@[@{@"name":@"女", @"code":@"2"}, @{@"name":@"男", @"code":@"1"}, ] mutableCopy];
        m_pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
        m_pickerView.delegate = self;
        m_pickerView.dataSource = self;
        m_pickerView.showsSelectionIndicator = YES;
        [self addContentView:m_pickerView];
    }
    return self;
}

- (void)onBtnOKtouched:(UIButton*)button
{
    id level_0 = [self getTitleByComponent:0];
    if (self.respBlocker) {
        id resp = @{@"title": formatSTR(@"%@", level_0[@"name"]),
                    @"code":level_0[@"code"]};
        self.respBlocker(resp);
    }
    [self close];
}

- (id)getTitleByComponent:(int)component {
    if (component == 0) {
        id province_obj = m_data[[m_pickerView selectedRowInComponent:0]];
        return province_obj;
    }
    return nil;
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return m_data.count;
    }
    return 0;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        id province_obj = m_data[row];
        return province_obj[@"name"];
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

@end
