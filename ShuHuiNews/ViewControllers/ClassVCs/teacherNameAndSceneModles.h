//
//  teacherNameAndSceneModles.h
//  Treasure
//
//  Created by zzw on 2017/1/18.
//  Copyright © 2017年 GY. All rights reserved.
//

#import "JSONModel.h"
#import "teacherNameModle.h"
#import "sceneModel.h"
@interface teacherNameAndSceneModles : JSONModel
@property (nonatomic,strong) NSArray  <teacherNameModle,Optional> * teacher_list;
@property (nonatomic,strong) NSArray  <sceneModel,Optional> * scene_list;
@end
