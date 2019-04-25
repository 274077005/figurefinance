//
//  DXLModel.m
//  ShuHuiNews
//
//  Created by ding on 2019/4/3.
//  Copyright © 2019年 耿一. All rights reserved.
//

#import "DXLModel.h"
#import <objc/runtime.h>
@implementation DXLModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    return;
    //    如果想要程序在运行过程中不引发任何异常信息且正常工作，可以让数据模型类重写setValue:forUndefinedKey:方法以覆盖默认实现，而且可以通过这个方法的两个参数获得无法配对键值。
}
- (NSString *)debugDescription
{
    //声明一个字典
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    //得到当前Class的所有属性
    uint count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    //循环并用KVC得到每个属性的值
    for (int i=0; i<count; i++) {
        objc_property_t property = properties[i];
        NSString *name = @(property_getName(property));
        id value = [self valueForKey:name]?:@"nil";
        //默认值为nil字符串
        [dictionary setObject:value forKey:name];
        //装载到字典里
    }
    //释放
    free(properties);
    //return
    return [NSString stringWithFormat:@"<%@: %p> -- %@",[self class],self,dictionary];
}
@end
