//
//  sceneModel.m
//  Treasure
//
//  Created by zzw on 2017/1/18.
//  Copyright © 2017年 GY. All rights reserved.
//

#import "sceneModel.h"

@implementation sceneModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
+(JSONKeyMapper *)keyMapper{
    
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"nameId"}];
}
@end
