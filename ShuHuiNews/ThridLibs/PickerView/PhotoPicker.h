//
//  PhotoPicker.h
//  WEMEX
//
//  Created by Zach on 2018/1/17.
//  Copyright © 2018年 Zach. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PhotoPickerDelegate
@optional
- (void)pickedImage:(UIImage*)image WithCatchPath:(NSString*)path;
@end

@interface PhotoPicker : NSObject
@property(nonatomic,assign)id<PhotoPickerDelegate> delegate;

- (void)pickWithSize:(CGSize)size ImageName:(NSString*)name;
+ (NSString*) catchImageWithSDImageCache:(UIImage*)image;

@property (nonatomic,copy)void(^pickBlock)(UIImage* image);
@property (nonatomic,copy,readonly)NSString* imagePath;
@property (nonatomic, weak)UIViewController* parentVC;

@end

