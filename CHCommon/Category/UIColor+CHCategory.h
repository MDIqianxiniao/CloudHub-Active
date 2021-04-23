//
//  UIColor+CHCategory.h
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (CHCategory)

@property (nonatomic, readonly) CGFloat ch_red;
@property (nonatomic, readonly) CGFloat ch_green;
@property (nonatomic, readonly) CGFloat ch_blue;

+ (UIColor *)ch_colorWithHex:(UInt32)hex;
+ (UIColor *)ch_colorWithHex:(UInt32)hex alpha:(CGFloat)alpha;

+ (nullable UIColor *)ch_colorWithHexString:(nullable NSString *)stringToConvert;
+ (nullable UIColor *)ch_colorWithHexString:(nullable NSString *)stringToConvert alpha:(CGFloat)alpha;
+ (nullable UIColor *)ch_colorWithHexString:(nullable NSString *)stringToConvert default:(nullable UIColor *)color;
+ (nullable UIColor *)ch_colorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha default:(nullable UIColor *)color;

- (UIColor *)ch_changeAlpha:(CGFloat)alpha;

- (nullable UIColor *)ch_colorByDarkeningTo:(CGFloat)f;

@end

NS_ASSUME_NONNULL_END
