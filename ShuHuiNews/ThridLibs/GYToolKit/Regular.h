//
//  Regular.h
//  ivmi
//
//  Created by Pro on 4/3/14.
//  Copyright (c) 2014 PartisanTroops. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Regular : NSObject
+ (BOOL)validateURL:(NSString *)urlString;
+ (BOOL) validateMobile:(NSString *)number;
+ (BOOL) validateEmail:(NSString *)email;
+ (BOOL) isValidNumber:(NSString*)value;
+ (BOOL) isValidFloatNumber:(NSString*)value;
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
+ (BOOL) validateNickname:(NSString *)nickname;
+ (BOOL) validateSepcailCapital:(NSString *)string;
+ (BOOL) validateTrueName:(NSString *)string;
+ (BOOL) validatePassword:(NSString *)string;
/**
 *  只有空格的字符串
 *
 *  @param string 目标字符串
 *
 *  @return yes：只有空格 no：含有其他字符
 */
+ (BOOL) validateOnlySpace:(NSString *)string;

/**
 *  检查严格的身份证
 *
 *  @param sPaperId 需要验证的身份证
 *
 *  @return 是否是身份证
 */
+(BOOL)validateIDNo:(NSString *)sPaperId;


/// 缩短数量描述，例如 51234 -> 5万
+ (NSString *)shortedNumberDesc:(NSUInteger)number;

/// At正则 例如 @王思聪
+ (NSRegularExpression *)regexAt;

/// 话题正则 例如 #暖暖环游世界#
+ (NSRegularExpression *)regexTopic;

/// 表情正则 例如 [偷笑]
+ (NSRegularExpression *)regexEmoticon;

/// 通过表情名获得表情的图片
+ (UIImage *)getEmotionForKey:(NSString *)key;

/**
 *  计算字符长度,汉字只算一个
 *
 *  @param string 需要计算的长度
 *
 *  @return 长度
 */
+(NSInteger)getStringCharacterLength:(NSString*)string;

@end
