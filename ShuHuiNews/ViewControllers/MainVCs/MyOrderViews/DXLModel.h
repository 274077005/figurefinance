//
//  DXLModel.h
//  ShuHuiNews
//
//  Created by ding on 2019/4/3.
//  Copyright © 2019年 耿一. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DXLModel : NSObject
- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key;
- (NSString *)debugDescription;
@end

NS_ASSUME_NONNULL_END
