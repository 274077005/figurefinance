//
//  Regular.m
//  ivmi
//
//  Created by Pro on 4/3/14.
//  Copyright (c) 2014 PartisanTroops. All rights reserved.
//

#import "Regular.h"

@implementation Regular

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

+ (BOOL)validateURL:(NSString *)urlString
{
    
    //组装一个字符串，需要把里面的网址解析出来
    
    
    //NSRegularExpression类里面调用表达的方法需要传递一个NSError的参数。下面定义一个
    
    NSError *error;
    
    //http+:[^\\s]* 这个表达式是检测一个网址的。
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"http+:[^\\s]*" options:0 error:&error];
    
    if (regex != nil) {
        
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
        
        if (firstMatch) {
            
//            NSRange resultRange = [firstMatch rangeAtIndex:0]; //等同于 firstMatch.range --- 相匹配的范围
            
            //从urlString当中截取数据
            
//            NSString *result=[urlString substringWithRange:resultRange];
            
            //输出结果
            
            return YES;
        }
        else{
            return NO;
        }
        
        
        
    }
    else{
        return NO;
    }
    
}
+ (BOOL) validateMobile:(NSString *)number
{
    
    NSString *phoneRegex = @"^((13[0-9])|(17[0-9])|(15[^4,\\D])|(18[0,0-9])|147)\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:number];
}

+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL) isValidNumber:(NSString*)value{
    const char *cvalue = [value UTF8String];
    NSInteger len = strlen(cvalue);
    for (NSInteger i = 0; i < len; i++) {
        if(!isNumber(cvalue[i])){
            return FALSE;
        }
    }
    return TRUE;
}

+ (BOOL) isValidFloatNumber:(NSString*)value{
    const char *cvalue = [value UTF8String];
    NSInteger len = strlen(cvalue);
    for (NSInteger i = 0; i < len; i++) {
        if(!isFloatNumber(cvalue[i])){
            return FALSE;
        }
    }
    return TRUE;
}



BOOL isNumber (char ch)
{
    if (!(ch >= '0' && ch <= '9')) {
        return FALSE;
    }
    return TRUE;
}

BOOL isFloatNumber (char ch)
{
    if (!((ch >= '0' && ch <= '9')||ch =='.')) {
        return FALSE;
    }
    return TRUE;
}

//昵称
+ (BOOL) validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[A-Za-z0-9\u4e00-\u9fa5]{1,16}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}

//只包含数字，字母，中文，不包含特殊符号
+ (BOOL) validateSepcailCapital:(NSString *)string
{
    NSString *sepcailCapitalRegex = @"^[A-Za-z0-9\u4e00-\u9fa5]+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",sepcailCapitalRegex];
    return ![passWordPredicate evaluateWithObject:string];
}

//只包含字母，中文，不包含特殊符号和数字，不能混合输入
+ (BOOL) validateTrueName:(NSString *)string
{
    int result=0;
    //中文
    NSString *sepcailCapitalRegex1 = @"^[\u4e00-\u9fa5]+$";
    NSPredicate *passWordPredicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",sepcailCapitalRegex1];
    if ([passWordPredicate1 evaluateWithObject:string]) {
        result++;
    }
    //英文
    NSString *sepcailCapitalRegex2 = @"^[A-Za-z]+$";
    NSPredicate *passWordPredicate2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",sepcailCapitalRegex2];
    if ([passWordPredicate2 evaluateWithObject:string]) {
        result++;
    }
    if (result>0) {
        return YES;
    }else
    {
        return NO;
    }
}

//只包含字母和数字和特殊符号，可以混合输入，适用于密码的设置
+ (BOOL) validatePassword:(NSString *)string
{
    NSString *sepcailCapitalRegex = @"^[A-Za-z0-9.*[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]+.*]+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",sepcailCapitalRegex];
    if ([passWordPredicate evaluateWithObject:string]) {
        return YES;
    }else
    {
        return NO;
    }
}

/**
 *  只有空格的字符串
 *
 *  @param string 目标字符串
 *
 *  @return yes：只有空格 no：含有其他字符
 */
+ (BOOL) validateOnlySpace:(NSString *)string{
    //^[\s]*$
    NSString *sepcailCapitalRegex = @"^[\\s]*$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",sepcailCapitalRegex];
    return [passWordPredicate evaluateWithObject:string];
}




+(BOOL)validateIDNo:(NSString *)sPaperId
{
    sPaperId= [sPaperId uppercaseString];
    //判断位数
    if (sPaperId.length != 15 && sPaperId.length != 18) {
        return NO;
    }
    NSString *carid = sPaperId;
    long lSumQT = 0 ;
    //加权因子
    int R[] = {7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2};
    //校验码
    unsigned char sChecker[11] = {'1','0','X','9','8','7','6','5','4','3','2'};
    //将15位身份证号转换为18位
    NSMutableString *mString = [NSMutableString stringWithString:sPaperId];
    if (sPaperId.length == 15) {
        [mString insertString:@"19" atIndex:6];
        long p =0;
        //        const char *pid = [mString UTF8String];
        for (int i =0; i<17; i++)
        {
            NSString * s = [mString substringWithRange:NSMakeRange(i, 1)];
            p += [s intValue]*R[i];
            //            p += (long)(pid-48) * R;//
        }
        int o = p%11;
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        carid = mString;
    }
    //判断地区码
    NSString *sProvince = [carid substringToIndex:2];
    if (![self isAreaCode:sProvince]) {
        return NO ;
    }
    //判断年月日是否有效
    //年份
    int strYear = [[self getStringWithRange:carid Value1:6 Value2:4] intValue];
    //月份
    int strMonth = [[self getStringWithRange:carid Value1:10 Value2:2] intValue];
    //日
    int strDay = [[self getStringWithRange:carid Value1:12 Value2:2] intValue];
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:localZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    if (date == nil) {
        return NO;
    }
    [carid uppercaseString];
    const char *PaperId = [carid UTF8String];
    //检验长度
    if (18!=strlen(PaperId)) {
        return NO;
    }
    //校验前17位数字和最后一位是否是x
    NSString* preString = [carid substringToIndex:carid.length-2];
    if (![self isValidNumber:preString]) {
        return NO;
    }
    NSString * lst = [carid substringFromIndex:carid.length-1];
    if (![self isValidNumber:lst]) {
        
        if ([lst isEqualToString:@"X"]) {
        
        }else{
            return NO;
        }
    }
    
    //验证最末的校验码
    lSumQT = 0;
    for (int i = 0; i<17; i++){
        NSString * s = [carid substringWithRange:NSMakeRange(i, 1)];
        lSumQT += [s intValue]*R[i];
    }
    if (sChecker[lSumQT%11] != PaperId[17]){
        return NO;
    }
    return YES;
     
}


+(NSArray *)provinceArr{
    NSArray *pArr = @[
                      @"11",//北京市|110000，
                      @"12",//天津市|120000，
                      @"13",//河北省|130000，
                      @"14",//山西省|140000，
                      @"15",//内蒙古自治区|150000，
                      @"21",//辽宁省|210000，
                      @"22",//吉林省|220000，
                      @"23",//黑龙江省|230000，
                      @"31",//上海市|310000，
                      @"32",//江苏省|320000，
                      @"33",//浙江省|330000，
                      @"34",//安徽省|340000，
                      @"35",//福建省|350000，
                      @"36",//江西省|360000，
                      @"37",//山东省|370000，
                      @"41",//河南省|410000，
                      @"42",//湖北省|420000，
                      @"43",//湖南省|430000，
                      @"44",//广东省|440000，
                      @"45",//广西壮族自治区|450000，
                      @"46",//海南省|460000，
                      @"50",//重庆市|500000，
                      @"51",//四川省|510000，
                      @"52",//贵州省|520000，
                      @"53",//云南省|530000，
                      @"54",//西藏自治区|540000，
                      @"61",//陕西省|610000，
                      @"62",//甘肃省|620000，
                      @"63",//青海省|630000，
                      @"64",//宁夏回族自治区|640000，
                      @"65",//新疆维吾尔自治区|650000，
                      @"71",//台湾省（886)|710000,
                      @"81",//香港特别行政区（852)|810000，
                      @"82",//澳门特别行政区（853)|820000
                      ];
    return pArr;
}

+(BOOL)isAreaCode:(NSString *)province{
    //在provinceArr中找
    NSArray * arr = [self provinceArr];
    int a = 0;
    for (NSString * pr in arr) {
        if ([pr isEqualToString:province]) {
            a ++;
        }
    }
    if (a == 0) {
        return NO;
    }else{
        return YES;
    }
}

+(NSString *)getStringWithRange:(NSString *)str Value1:(int)v1 Value2:(int)v2{
    NSString * sub = [str substringWithRange:NSMakeRange(v1, v2)];
    return sub;
}


+ (NSString *)shortedNumberDesc:(NSUInteger)number {
    // should be localized
    if (number <= 9999) return [NSString stringWithFormat:@"%d", (int)number];
    if (number <= 9999999) return [NSString stringWithFormat:@"%d万", (int)(number / 10000)];
    return [NSString stringWithFormat:@"%d千万", (int)(number / 10000000)];
}

+ (NSRegularExpression *)regexAt {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 微博的 At 只允许 英文数字下划线连字符，和 unicode 4E00~9FA5 范围内的中文字符，这里保持和微博一致。。
        // 目前中文字符范围比这个大
        regex = [NSRegularExpression regularExpressionWithPattern:@"@[-_a-zA-Z0-9\u4E00-\u9FA5]+" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (NSRegularExpression *)regexTopic {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"#[^@#]+?#" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (NSRegularExpression *)regexEmoticon {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[[^ \\[\\]]+?\\]" options:kNilOptions error:NULL];
    });
    return regex;
}



/**
 *  计算字符长度,汉字只算一个
 *
 *  @param string 需要计算的长度
 *
 *  @return 长度
 */
+(NSInteger)getStringCharacterLength:(NSString*)string
{
    float number = 0.0;
    int index;
    for (index=0; index < [string length]; index++)
    {
        
        NSString *character = [string substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3) {
            number++;
        } else {
            number ++;
        }
    }
    return ceil(number);
}

@end
