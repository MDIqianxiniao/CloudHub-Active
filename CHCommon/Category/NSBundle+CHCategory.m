//
//  NSBundle+CHCategory.m
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import "NSBundle+CHCategory.h"

static inline NSString *ch_getAssetsName(NSString *assetsName)
{
    if ([assetsName rangeOfString:@".xcassets"].location != NSNotFound)
    {
        return assetsName;
    }
    
    return [assetsName stringByAppendingPathExtension:@"xcassets"];
}

@implementation NSBundle (CHCategory)

+ (NSString *)ch_mainResourcePath
{
    return [NSBundle mainBundle].resourcePath;
}

+ (NSString *)ch_mainBundlePath
{
    return [NSBundle mainBundle].bundlePath;
}

- (UIImage *)ch_imageWithAssetsName:(NSString *)assetsName imageName:(NSString *)imageName
{
    NSString *bundlePath = [self resourcePath];
    NSString *basePath = [bundlePath stringByAppendingPathComponent:ch_getAssetsName(assetsName)];

    NSString *imageTmpName = [imageName stringByDeletingPathExtension];
    NSString *imagePathName = [imageTmpName stringByAppendingPathExtension:@"imageset"];

    if (@available(iOS 10.0, *)) {
         NSString *imageFilePath = [[basePath stringByAppendingPathComponent:imagePathName] stringByAppendingPathComponent:imageName];
         return [UIImage imageWithContentsOfFile:imageFilePath];
     }

    NSString *name = [NSString stringWithFormat:@"%@@2x", imageName];
    NSString *imageFilePath = [[basePath stringByAppendingPathComponent:imagePathName] stringByAppendingPathComponent:name];
    UIImage *image = [UIImage imageWithContentsOfFile:imageFilePath];
    if (!image)
    {
        NSString *name = [NSString stringWithFormat:@"%@@3x", imageName];
        NSString *imageFilePath = [[basePath stringByAppendingPathComponent:imagePathName] stringByAppendingPathComponent:name];
        image = [UIImage imageWithContentsOfFile:imageFilePath];
    }
    if (!image)
    {
        NSString *imageFilePath = [[basePath stringByAppendingPathComponent:imagePathName] stringByAppendingPathComponent:imageName];
        image = [UIImage imageWithContentsOfFile:imageFilePath];
    }

    return image;
}

@end
