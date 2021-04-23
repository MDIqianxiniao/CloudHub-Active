//
//  UIButton+CHCategory.h
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (CHCategory)

+ (nonnull instancetype)ch_buttonWithFrame:(CGRect)frame image:(nullable UIImage *)image;
+ (nonnull instancetype)ch_buttonWithFrame:(CGRect)frame image:(nullable UIImage *)image highlightedImage:(nullable UIImage *)highlightedImage;

+ (nonnull instancetype)ch_buttonWithFrame:(CGRect)frame color:(nonnull UIColor *)color highlightedColor:(nonnull UIColor *)highlightedColor disableColor:(nonnull UIColor *)disableColor;

@end

NS_ASSUME_NONNULL_END
