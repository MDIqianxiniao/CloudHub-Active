//
//  UIImage+CHCategory.h
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (CHCategory)

+ (nullable UIImage *)ch_imageWithColor:(UIColor *)color;
+ (nullable UIImage *)ch_imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)ch_imageWithTintColor:(UIColor *)tintColor;

@end

NS_ASSUME_NONNULL_END
