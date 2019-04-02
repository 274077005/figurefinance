//
//  CityPicker.h
//  wemex
//
//  Created by Zach on 2017/12/15.
//  Copyright © 2017年 WEMEX. All rights reserved.
//

#import "WePicker.h"

@interface CityPicker : WePicker

SINGLETON_DECLARE(CityPicker)

- (void)cleanNoLimit;

@end
