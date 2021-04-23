//
//  CHCloudHubUtil.m
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import "CHCloudHubUtil.h"
#import <arpa/inet.h>
#import <sys/utsname.h>
#import <CommonCrypto/CommonCrypto.h>

@implementation CHCloudHubUtil

/// 检测设备授权
+ (BOOL)checkAuthorizationStatus:(AVMediaType)mediaType
{
    AVAuthorizationStatus authorStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authorStatus == AVAuthorizationStatusRestricted ||
        authorStatus == AVAuthorizationStatusDenied)
    {
        return NO;
    }
    
    return YES;
}

+ (NSString *)getCurrentLanguage
{
    NSArray *language = [NSLocale preferredLanguages];
    if ([language objectAtIndex:0]) {
        NSString *currentLanguage = [language objectAtIndex:0];
        if ([currentLanguage length] >= 7 &&
            [[currentLanguage substringToIndex:7] isEqualToString:@"zh-Hans"])
        {
            return @"ch";
        }

        if ([currentLanguage length] >= 7 &&
            [[currentLanguage substringToIndex:7] isEqualToString:@"zh-Hant"])
        {
            return @"tw";
        }

        if ([currentLanguage length] >= 3 &&
            [[currentLanguage substringToIndex:3] isEqualToString:@"en-"])
        {
            return @"en";
        }
    }
    return @"en";
}

+ (BOOL)isDomain:(NSString *)host
{
    const char *hostN= [host UTF8String];
    in_addr_t rt = inet_addr(hostN);
    if (rt == INADDR_NONE)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/// Check data type
+ (BOOL)checkDataClass:(id)data
{
    if (!data)
    {
        return YES;
    }
    if ([data isKindOfClass:[NSNumber class]] || [data isKindOfClass:[NSString class]] || [data isKindOfClass:[NSDictionary class]]  || [data isKindOfClass:[NSArray class]])
    {
        return YES;
    }
    
    return NO;
}

+ (NSString *)stringFromJSONString:(NSString *)JSONString
{
    NSMutableString *mutableJSONString = [NSMutableString stringWithString:JSONString];
    NSString *character = nil;
    for (int i = 0; i < mutableJSONString.length; i ++)
    {
        character = [mutableJSONString substringWithRange:NSMakeRange(i, 1)];
        if ([character isEqualToString:@"\\"])
        {
            [mutableJSONString deleteCharactersInRange:NSMakeRange(i, 1)];
        }
    }
    
    return mutableJSONString;
}

+ (NSDictionary *)convertWithData:(id)data
{
    if (!data)
    {
        return nil;
    }
    
    NSDictionary *dataDic = nil;
    if ([data isKindOfClass:[NSString class]])
    {
        NSString *tDataString = [NSString stringWithFormat:@"%@", data];
        NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
        if (tJsData)
        {
            dataDic = [NSJSONSerialization JSONObjectWithData:tJsData
                                                      options:NSJSONReadingMutableContainers
                                                        error:nil];
        }
    }
    else if ([data isKindOfClass:[NSDictionary class]])
    {
        dataDic = (NSDictionary *)data;
    }
    else if ([data isKindOfClass:[NSData class]])
    {
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        dataDic = [CHCloudHubUtil convertWithData:dataStr];
    }
    
    return dataDic;
}

+ (BOOL)checkIsMedia:(NSString *)filetype;
{
    if ([filetype isEqualToString:@"mp3"]
        || [filetype isEqualToString:@"mp4"]
        || [filetype isEqualToString:@"webm"]
        || [filetype isEqualToString:@"ogg"]
        || [filetype isEqualToString:@"wav"])
    {
        return YES;
    }
    
    return NO;
}

+ (BOOL)checkIsVideo:(NSString *)filetype;
{
    if ([filetype isEqualToString:@"mp4"] || [filetype isEqualToString:@"webm"])
    {
        return YES;
    }
    
    return NO;
}

+ (BOOL)checkIsAudio:(NSString *)filetype;
{
    if ([filetype isEqualToString:@"mp3"] || [filetype isEqualToString:@"ogg"] || [filetype isEqualToString:@"wav"])
    {
        return YES;
    }
    
    return NO;
}

+ (NSString *)createUUID
{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef cfstring = CFUUIDCreateString(kCFAllocatorDefault, uuid);
    const char *cStr = CFStringGetCStringPtr(cfstring,CFStringGetFastestEncoding(cfstring));
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    CFRelease(uuid);
    CFRelease(cfstring);
   
    NSString *openUDID = [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%08lx",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15],
                 (unsigned long)(arc4random() % NSUIntegerMax)];
    
    return openUDID;
}

+ (NSString *)changeUrl:(NSURL *)url withProtocol:(NSString *)protocol host:(NSString *)host
{
    NSString *new;
    [protocol ch_trimAllSpace];
    
    if (![protocol ch_isNotEmpty])
    {
        protocol = url.scheme;
    }
    
    NSString *path = url.path;
    if ([path ch_isNotEmpty])
    {
        new = [NSString stringWithFormat:@"%@://%@/%@", protocol, host, path];
    }
    else
    {
        new = [NSString stringWithFormat:@"%@://%@", protocol, host];
    }
    
    return new;
}

+ (UIWindow *)getKeyWindow
{
    UIWindow *keywindow = nil;
    if (@available(iOS 13.0, *))
    {        
        for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes)
        {
            if (windowScene.activationState == UISceneActivationStateForegroundActive || windowScene.activationState == UISceneActivationStateForegroundInactive)
            {
                keywindow = windowScene.windows.lastObject;
            }
        }
    }
    else
    {
        keywindow = [UIApplication sharedApplication].keyWindow;
    }
    
    return keywindow;
}

@end
