//
//  NSBundle+CHCategory.h
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (CHCategory)

+ (nullable NSString *)ch_mainResourcePath;

+ (nonnull NSString *)ch_mainBundlePath;

- (nullable UIImage *)ch_imageWithAssetsName:(NSString *)assetsName imageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
