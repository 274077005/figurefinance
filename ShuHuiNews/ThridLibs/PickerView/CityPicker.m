//
//  CityPicker.m
//  wemex
//
//  Created by Zach on 2017/12/15.
//  Copyright © 2017年 WEMEX. All rights reserved.
//

#import "CityPicker.h"
#define isSubStr(text, sub)  ((text != nil) && ([text rangeOfString:sub].location != NSNotFound))
@interface CityPicker()<UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIPickerView* m_pickerView;
    NSMutableArray* m_data;
    NSArray * _selectedArray;
    NSArray * _provinceArray;
    NSArray *_cityArray;
    NSArray *_townArray;
}
@end

@implementation CityPicker

SINGLETON_IMPLEMENTATION(CityPicker)

- (id)init
{
    if (self = [super init]) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"city.json" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        if (!data) return nil;
        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        m_data = [[NSMutableArray alloc] initWithArray:result];
        _provinceArray = m_data;

        m_pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
        m_pickerView.delegate = self;
        m_pickerView.dataSource = self;
        m_pickerView.showsSelectionIndicator = YES;
        [self addContentView:m_pickerView];
    }
    return self;
}

- (void)cleanNoLimitForList:(NSMutableArray*)list {
    if (!list) return;
    
    NSMutableArray* tmp = [NSMutableArray array];
    for (id item in list) {
        if (isSubStr(item[@"name"], @"不限")) {
            [tmp addObject:item];
            break;
        }
    }
    for (id tmpitem in tmp) {
        [list removeObject:tmpitem];
    }
}

- (void)cleanNoLimit {
    [m_data removeObjectAtIndex:0];
    for (id level1 in m_data) {
        if (level1[@"data"]) {
            for (id level2 in level1[@"data"]) {
                [self cleanNoLimitForList:level2[@"data"]];
            }
            
            [self cleanNoLimitForList:level1[@"data"]];
        }
    }
}

- (void)onBtnOKtouched:(UIButton*)button
{
    id level_0 = [self getTitleByComponent:0];
    id level_1 = [self getTitleByComponent:1];
    id level_2 = [self getTitleByComponent:2];
    if (self.respBlocker) {
        id resp = @{@"title":@"", @"code":@""};
        
        if ([level_0[@"code"] intValue] == 9999999) {
            resp = @{@"title":@"不限",
                     @"code":@""};
        } else if (level_2) {
            resp = @{@"title": formatSTR(@"%@,%@,%@", level_0[@"name"],level_1[@"name"],level_2[@"name"]),
                        @"code":level_2[@"code"]};
        } else if (level_1) {
            resp = @{@"title": formatSTR(@"%@,%@", level_0[@"name"],level_1[@"name"]),
                        @"code":level_1[@"code"]};
        } else {
            resp = @{@"title": formatSTR(@"%@",level_0[@"name"]),
                        @"code":level_0[@"code"]};
        }
        
        self.respBlocker(resp);
    }
    [self close];
}

- (id)getTitleByComponent:(int)component {
    if (component == 0) {
        id province_obj = m_data[[m_pickerView selectedRowInComponent:0]];
        return province_obj;
    } else if (component == 1) {
        NSInteger province_selected_index = [m_pickerView selectedRowInComponent:0];
        NSArray* city_list = m_data[province_selected_index][@"data"];
        
        id city_obj = city_list[[m_pickerView selectedRowInComponent:1]];
        return city_obj;
    } else if (component == 2) {
        NSInteger province_selected_index = [m_pickerView selectedRowInComponent:0];
        NSArray* city_list = m_data[province_selected_index][@"data"];
        
        NSInteger city_selected_index = [m_pickerView selectedRowInComponent:1];
        NSArray* area_list = city_list[city_selected_index][@"data"];
        id area_obj = area_list[[m_pickerView selectedRowInComponent:2]];
        return area_obj;
    }
    return nil;
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return m_data.count;
    } else if (component == 1) {

        return _cityArray.count;
    } else if (component == 2) {

        return _townArray.count;
    }
    return 0;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        id province_obj = m_data[row];
        return province_obj[@"name"];
    } else if (component == 1) {
        
        id city_obj = _cityArray[row];
        return city_obj[@"name"];
    } else if (component == 2) {
        id area_obj = _townArray[row];
        return area_obj[@"name"];
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        _selectedArray = [_provinceArray objectAtIndex:row];
        if (_selectedArray.count > 0) {
            _cityArray = m_data[[pickerView selectedRowInComponent:0]][@"data"];
        } else {
            _cityArray = nil;
        }
        if (_cityArray.count > 0) {
            _townArray = [_cityArray objectAtIndex:0][@"data"];
        } else {
            _townArray = nil;
        }
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    [pickerView selectedRowInComponent:2];
    
    if (component == 1) {
        if (_selectedArray.count > 0 && _cityArray.count > 0) {
            _townArray = _cityArray[[pickerView selectedRowInComponent:1]][@"data"];
        } else {
            _townArray = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    
    [pickerView reloadComponent:2];
}

@end
