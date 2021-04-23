//
//  UIDevice+CHCategory.m
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import "UIDevice+CHCategory.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <mach/mach.h>

@implementation UIDevice (CHCategory)

+ (BOOL)ch_isIPhoneNotchScreen
{
    BOOL result = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone)
    {
        return result;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0f)
        {
            result = YES;
        }
    }
    
    return result;
}

+ (NSString *)ch_devicePlatform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    
    return platform;
}

+ (BOOL)ch_isiPad
{
    if ([[[self ch_devicePlatform] substringToIndex:4] isEqualToString:@"iPad"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)ch_isiPhone
{
    if ([[[self ch_devicePlatform] substringToIndex:6] isEqualToString:@"iPhone"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
