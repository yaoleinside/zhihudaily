//
//  NSString+Md5.m
//  ZhihuDaily
//
//  Created by 姚乐 on 16/10/9.
//  Copyright © 2016年 yaole. All rights reserved.
//

#import "NSString+Md5.h"
#import <CommonCrypto/CommonCrypto.h>


@implementation NSString (Md5)

+(NSString *)stringToMd5:(NSString *)aString {
    const char* cStr = [aString UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result);
    
    NSMutableString* ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02X", result[i]];
    }
    
    return ret;
}

@end
