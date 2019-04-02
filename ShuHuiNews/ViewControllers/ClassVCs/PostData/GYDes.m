//
//  DESEncryption.m
//  AESDESencryption
//
//  Created by zzw on 16/6/27.
//  Copyright © 2016年 zzw. All rights reserved.
//

#import "GYDes.h"

@interface GYDes()


+ (NSString *) encodeBase64WithString:(NSString *)strData;
+ (NSString *) encodeBase64WithData:(NSData *)objData;
+ (NSData *) decodeBase64WithString:(NSString *)strBase64;

+ (NSString *)doCipher:(NSString *)sTextIn key:(NSString *)sKey
               context:(CCOperation)encryptOrDecrypt;

@end
@implementation GYDes

+ (NSString *) encode:(NSString *)str key:(NSString *)key
{
    // doCipher 不能编汉字，所以要进行 url encode
    NSMutableString* str1 = [GYDes urlEncode:str];
    NSMutableString* encode = [NSMutableString stringWithString:[GYDes doCipher:str1 key:key context:kCCEncrypt]];
    [GYDes formatSpecialCharacters:encode];
    return encode;
}

+ (NSString *) decode:(NSString *)str key:(NSString *)key 
{
    NSMutableString *str1 = [NSMutableString stringWithString:str];
    [GYDes reformatSpecialCharacters:str1];

    NSString *rt = [GYDes doCipher:str1 key:key context:kCCDecrypt] ;
    return rt;
}

+ (NSMutableString *)urlEncode:(NSString*)str
{
//    NSData *postData = [str dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//    NSMutableString * encodeStr = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",postData]];
    NSMutableString* encodeStr = [NSMutableString stringWithString:[str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [encodeStr replaceOccurrencesOfString:@"+" withString:@"%2B" options:NSWidthInsensitiveSearch range:NSMakeRange(0, [encodeStr length])];
    [encodeStr replaceOccurrencesOfString:@"/" withString:@"%2F" options:NSWidthInsensitiveSearch range:NSMakeRange(0, [encodeStr length])];
    return encodeStr;
}

+ (void)formatSpecialCharacters:(NSMutableString *)str
{
    [str replaceOccurrencesOfString:@"+" withString:@"$$" options:NSWidthInsensitiveSearch range:NSMakeRange(0, [str length])];
    [str replaceOccurrencesOfString:@"/" withString:@"@@" options:NSWidthInsensitiveSearch range:NSMakeRange(0, [str length])];
}


+ (void)reformatSpecialCharacters:(NSMutableString *)str
{
    [str replaceOccurrencesOfString:@"$$" withString:@"+" options:NSWidthInsensitiveSearch range:NSMakeRange(0, [str length])];
    [str replaceOccurrencesOfString:@"@@" withString:@"/" options:NSWidthInsensitiveSearch range:NSMakeRange(0, [str length])];
}

+ (NSString *)encodeBase64WithString:(NSString *)strData {
    return [GYDes encodeBase64WithData:[strData dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSString *)encodeBase64WithData:(NSData *)objData {
    NSString *encoding = nil;
    unsigned char *encodingBytes = NULL;
    @try {
        static char encodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        static NSUInteger paddingTable[] = {0,2,1};
        
        NSUInteger dataLength = [objData length];
        NSUInteger encodedBlocks = (dataLength * 8) / 24;
        NSUInteger padding = paddingTable[dataLength % 3];
        if( padding > 0 ) encodedBlocks++;
        NSUInteger encodedLength = encodedBlocks * 4;
        
        encodingBytes = malloc(encodedLength);
        if( encodingBytes != NULL ) {
            NSUInteger rawBytesToProcess = dataLength;
            NSUInteger rawBaseIndex = 0;
            NSUInteger encodingBaseIndex = 0;
            unsigned char *rawBytes = (unsigned char *)[objData bytes];
            unsigned char rawByte1, rawByte2, rawByte3;
            while( rawBytesToProcess >= 3 ) {
                rawByte1 = rawBytes[rawBaseIndex];
                rawByte2 = rawBytes[rawBaseIndex+1];
                rawByte3 = rawBytes[rawBaseIndex+2];
                encodingBytes[encodingBaseIndex] = encodingTable[((rawByte1 >> 2) & 0x3F)];
                encodingBytes[encodingBaseIndex+1] = encodingTable[((rawByte1 << 4) & 0x30) | ((rawByte2 >> 4) & 0x0F) ];
                encodingBytes[encodingBaseIndex+2] = encodingTable[((rawByte2 << 2) & 0x3C) | ((rawByte3 >> 6) & 0x03) ];
                encodingBytes[encodingBaseIndex+3] = encodingTable[(rawByte3 & 0x3F)];
                
                rawBaseIndex += 3;
                encodingBaseIndex += 4;
                rawBytesToProcess -= 3;
            }
            rawByte2 = 0;
            switch (dataLength-rawBaseIndex) {
                case 2:
                    rawByte2 = rawBytes[rawBaseIndex+1];
                case 1:
                    rawByte1 = rawBytes[rawBaseIndex];
                    encodingBytes[encodingBaseIndex] = encodingTable[((rawByte1 >> 2) & 0x3F)];
                    encodingBytes[encodingBaseIndex+1] = encodingTable[((rawByte1 << 4) & 0x30) | ((rawByte2 >> 4) & 0x0F) ];
                    encodingBytes[encodingBaseIndex+2] = encodingTable[((rawByte2 << 2) & 0x3C) ];
                    // we can skip rawByte3 since we have a partial block it would always be 0
                    break;
            }
            // compute location from where to begin inserting padding, it may overwrite some bytes from the partial block encoding
            // if their value was 0 (cases 1-2).
            encodingBaseIndex = encodedLength - padding;
            while( padding-- > 0 ) {
                encodingBytes[encodingBaseIndex++] = '=';
            }
            encoding = [[NSString alloc] initWithBytes:encodingBytes length:encodedLength encoding:NSASCIIStringEncoding];
        }
    }
    @catch (NSException *exception) {
        encoding = nil;
        NSLog(@"WARNING: error occured while tring to encode base 32 data: %@", exception);
    }
    @finally {
        if( encodingBytes != NULL ) {
            free( encodingBytes );
        }
    }
    return encoding;
    
}

+ (NSData *)decodeBase64WithString:(NSString *)strBase64 {
    NSData *data = nil;
    unsigned char *decodedBytes = NULL;
    @try {
#define __ 255
        static char decodingTable[256] = {
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0x00 - 0x0F
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0x10 - 0x1F
            __,__,__,__, __,__,__,__, __,__,__,62, __,__,__,63,  // 0x20 - 0x2F
            52,53,54,55, 56,57,58,59, 60,61,__,__, __, 0,__,__,  // 0x30 - 0x3F
            __, 0, 1, 2,  3, 4, 5, 6,  7, 8, 9,10, 11,12,13,14,  // 0x40 - 0x4F
            15,16,17,18, 19,20,21,22, 23,24,25,__, __,__,__,__,  // 0x50 - 0x5F
            __,26,27,28, 29,30,31,32, 33,34,35,36, 37,38,39,40,  // 0x60 - 0x6F
            41,42,43,44, 45,46,47,48, 49,50,51,__, __,__,__,__,  // 0x70 - 0x7F
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0x80 - 0x8F
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0x90 - 0x9F
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xA0 - 0xAF
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xB0 - 0xBF
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xC0 - 0xCF
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xD0 - 0xDF
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xE0 - 0xEF
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xF0 - 0xFF
        };
        strBase64 = [strBase64 stringByReplacingOccurrencesOfString:@"=" withString:@""];
        NSData *encodedData = [strBase64 dataUsingEncoding:NSASCIIStringEncoding];
        unsigned char *encodedBytes = (unsigned char *)[encodedData bytes];
        
        NSUInteger encodedLength = [encodedData length];
        NSUInteger encodedBlocks = (encodedLength+3) >> 2;
        NSUInteger expectedDataLength = encodedBlocks * 3;
        
        unsigned char decodingBlock[4];
        
        decodedBytes = malloc(expectedDataLength);
        if( decodedBytes != NULL ) {
            
            NSUInteger i = 0;
            NSUInteger j = 0;
            NSUInteger k = 0;
            unsigned char c;
            while( i < encodedLength ) {
                c = decodingTable[encodedBytes[i]];
                i++;
                if( c != __ ) {
                    decodingBlock[j] = c;
                    j++;
                    if( j == 4 ) {
                        decodedBytes[k] = (decodingBlock[0] << 2) | (decodingBlock[1] >> 4);
                        decodedBytes[k+1] = (decodingBlock[1] << 4) | (decodingBlock[2] >> 2);
                        decodedBytes[k+2] = (decodingBlock[2] << 6) | (decodingBlock[3]);
                        j = 0;
                        k += 3;
                    }
                }
            }
            
            // Process left over bytes, if any
            if( j == 3 ) {
                decodedBytes[k] = (decodingBlock[0] << 2) | (decodingBlock[1] >> 4);
                decodedBytes[k+1] = (decodingBlock[1] << 4) | (decodingBlock[2] >> 2);
                k += 2;
            } else if( j == 2 ) {
                decodedBytes[k] = (decodingBlock[0] << 2) | (decodingBlock[1] >> 4);
                k += 1;
            }
            data = [[NSData alloc] initWithBytes:decodedBytes length:k];
        }
    }
    @catch (NSException *exception) {
        data = nil;
        NSLog(@"WARNING: error occured while decoding base 32 string: %@", exception);
    }
    @finally {
        if( decodedBytes != NULL ) {
            free( decodedBytes );
        }
    }
    return data;
    
}


+ (NSString *)doCipher:(NSString *)sTextIn key:(NSString *)sKey
               context:(CCOperation)encryptOrDecrypt {
    NSStringEncoding EnC = NSUTF8StringEncoding;
    
    NSMutableData *dTextIn;
    if (encryptOrDecrypt == kCCDecrypt) {
        dTextIn = [[GYDes decodeBase64WithString:sTextIn] mutableCopy];

    }
    else{
        dTextIn = [[sTextIn dataUsingEncoding: EnC] mutableCopy];
    }
    NSMutableData * dKey = [[sKey dataUsingEncoding:EnC] mutableCopy];
    [dKey setLength:kCCBlockSizeDES];
    uint8_t *bufferPtr1 = NULL;
    size_t bufferPtrSize1 = 0;
    size_t movedBytes1 = 0;
    //uint8_t iv[kCCBlockSizeDES];
    //memset((void *) iv, 0x0, (size_t) sizeof(iv));
    //    Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    bufferPtrSize1 = ([sTextIn length] + kCCKeySizeDES) & ~(kCCKeySizeDES -1);
    bufferPtr1 = malloc(bufferPtrSize1 * sizeof(uint8_t));
    memset((void *)bufferPtr1, 0x00, bufferPtrSize1);
    
    CCCrypt(encryptOrDecrypt, // CCOperation op
            kCCAlgorithmDES, // CCAlgorithm alg
            kCCOptionPKCS7Padding, // CCOptions options
            [dKey bytes], // const void *key
            [dKey length], // size_t keyLength //
            [dKey bytes], // const void *iv
            [dTextIn bytes], // const void *dataIn
            [dTextIn length],  // size_t dataInLength
            (void *)bufferPtr1, // void *dataOut
            bufferPtrSize1,     // size_t dataOutAvailable
            &movedBytes1);
    
    //[dTextIn release];
    //[dKey release];
    
    NSString * sResult;
    if (encryptOrDecrypt == kCCDecrypt){
        sResult = [[NSString alloc] initWithData:[NSData dataWithBytes:bufferPtr1 length:movedBytes1] encoding:EnC];
        free(bufferPtr1);
    }
    else {

        NSData *dResult = [NSData dataWithBytes:bufferPtr1 length:movedBytes1];
        free(bufferPtr1);
        sResult = [GYDes encodeBase64WithData:dResult];
    }
    return sResult;
}
//Lab中数字变化时，渐变
+ (void)gradualChangeLabWithEndNum:(NSString *)endNum Lab:(UILabel *)Lab Timer:(NSTimer *)changeTimer{
//    NSLog(@"endNum:%@",endNum);
    //如果第一次进某个界面，lab内容为空，直接替换，防止计算闪退
    if (!Lab.text) {
        Lab.text = endNum;
        return;
    }
    //如果变化数值变化超过20个单位，则直接替换
    static int flag = 1;
    //确定每次加减的值
    NSString * changeStr;
    NSArray * sellArray;
    if ([Lab.text length] > [endNum length]) {
        sellArray = [Lab.text componentsSeparatedByString:@"."];
    }else{
         sellArray = [endNum componentsSeparatedByString:@"."];
    }
    
    if (sellArray.count > 1) {
        NSMutableString * str = [[NSMutableString alloc]initWithString:@"0."];
        for (NSInteger i = 1; i < [sellArray[1] length]; i++) {
            [str appendFormat:@"0"];
        }
        [str appendFormat:@"1"];
        changeStr = str;
    }else{
        changeStr = @"1";
    }

    NSDecimalNumber * endNumber = [NSDecimalNumber decimalNumberWithString:endNum];
    NSDecimalNumber * labNum= [NSDecimalNumber decimalNumberWithString:Lab.text];
    NSComparisonResult result = [labNum compare:endNumber];
//    NSLog(@"end:%@",endNumber);
//    NSLog(@"lab:%@",labNum);
    
    //如果已经变化了20次，则直接替换
    if (flag == 20) {
        Lab.text = endNum;
        [changeTimer setFireDate:[NSDate distantFuture]];
        flag = 1;
        return;
    }
    //小于
    if (result == NSOrderedAscending) {
        
        NSDecimalNumber * priceNumber = [NSDecimalNumber decimalNumberWithString:Lab.text];
        
        NSDecimalNumber * addNum = [NSDecimalNumber decimalNumberWithString:changeStr];
        
        NSDecimalNumber *product = [priceNumber decimalNumberByAdding:addNum];
        Lab.text = [NSString stringWithFormat:@"%@",product];
        
        
    } else if (result == NSOrderedSame) {
        [changeTimer setFireDate:[NSDate distantFuture]];
        flag = 1;
        return;
    } else if (result == NSOrderedDescending) {
        NSDecimalNumber * priceNumber = [NSDecimalNumber decimalNumberWithString:Lab.text];

        NSDecimalNumber * subNum = [NSDecimalNumber decimalNumberWithString:changeStr];
        NSDecimalNumber *product = [priceNumber decimalNumberBySubtracting:subNum];
//        
//        NSLog(@"subNum:%@",subNum);
        Lab.text = [NSString stringWithFormat:@"%@",product];
    }
    flag++;
    
}
//判断字符串是否包含汉字
+ (BOOL)includeChinese:(NSString *)string
{
    for(int i=0; i< [string length];i++)
    {
        int a =[string characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}
//计算两个时间点之间的分钟差如08:00到09:00
+(NSInteger )ComputingTimeWithDateArray:(NSArray *)dateArray{
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"HH:mm";
    [dateFomatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSDate * startDate = [dateFomatter dateFromString:dateArray[0]];
    
    NSDate * endDate = [dateFomatter dateFromString:dateArray[1]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    //                    NSLog(@"%@",earlyDate);
    NSDateComponents *dateCom = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    if (dateCom.minute < 0) {
        return dateCom.minute + 1440;
    }
    
    return dateCom.minute;
}

@end
