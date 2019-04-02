//
//  GYToolKit.h
//  HomeForPets
//
//  Created by xz on 2017/6/9.
//  Copyright © 2017年 耿一. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYToolKit : NSObject

+ (NSString *)GetIphoneType;
//字符串转字典
+ (NSDictionary*)jsonStrToDictionary:(NSString *)jsonStr;

//字典转json
+ (NSString*)dictionaryToJsonStr:(NSDictionary *)dic;
//请求时的字典转字符串
+ (NSString *)dictionaryToPostStr:(NSDictionary *)params;


+ (NSString *)URLEncode:(NSString *)url;
// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
//把NSDictionary解析成post格式的NSString字符串
+ (NSString *)parseParams:(NSDictionary *)params;

+ (NSString *)GetUUID;
+ (void)gotoSettings;

+ (AFSecurityPolicy*)customSecurityPolicy;
//获取当前显示页面的控制器
+ (UIViewController *)topViewController;
//计算富文本的高度
+(CGFloat)AttribLHWithSpace:(CGFloat)lineSpace size:(NSInteger)font width:(CGFloat)width str:(NSString*)str;

//计算HTML文本高度
+(CGFloat)HTMLLHWithSpace:(CGFloat)lineSpace size:(NSInteger)font width:(CGFloat)width str:(NSString*)str;
 //计算普通文本字体高度

+(CGFloat)NormalLHWithSize:(NSInteger)font width:(CGFloat)width str:(NSString*)str;
//获取字体宽度
+(CGFloat)LabelWidthWithSize:(NSInteger)font height:(CGFloat)height str:(NSString*)str;
//1970年到现在的秒数
+ (NSInteger)getSecondTimeSince1970;

+ (NSString *)getTimeIntervalSince1970;

//秒数转时间
+ (NSString *)SecondChangeToTime:(NSInteger)timeValue;

//判断数字是不是整形
+ (BOOL)isPureInt:(NSString *)string;
//判断是不是为数字类型
+ (BOOL)isNum:(NSString *)checkNumStr;
//获取签名字符串
+(NSString *)GetSignWithBody:(NSMutableDictionary *)body;
//如果没有登录
+ (void)pushLoginVC;
//压缩图片质量
+ (NSData *)compressImageQuality:(UIImage *)image toKb:(NSInteger)Kb;
//截图
+ (UIImage *)snapshotSingleView:(UIView *)view;
//字符串是否包含汉字
+ (BOOL)includeChinese:(NSString *)string;




//给颜色创建图片
+ (UIImage *)createImageWithColor:(UIColor *)color;
//alert
+ (void)createAlertWith:(NSString *)titleStr message:(NSString *)message action:(void(^)(UIAlertAction * _Nonnull action))action target:(id)target;
//精确字符串
//几位小数，folat字符
+ (NSString *)changeWithFormat:(NSInteger)format FloatNumber:(float)floatNumber;
//调用share进行分享
+(void)shareSDKToShare:(NSMutableDictionary *)shareParams;


@end
