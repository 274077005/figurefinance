//
//  sceneModel.h
//  Treasure
//
//  Created by zzw on 2017/1/18.
//  Copyright © 2017年 GY. All rights reserved.
//

#import "JSONModel.h"
@protocol sceneModel <NSObject>

@end
@interface sceneModel : JSONModel
@property (copy,nonatomic)NSString * nameId;
@property (copy,nonatomic)NSString * scene_name;
@property (nonatomic)BOOL is;
@end
