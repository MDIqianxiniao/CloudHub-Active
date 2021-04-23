//
//  NSNumber+BMCategory.h
//  BMBasekit
//
//  Created by DennisDeng on 16/1/21.
//  Copyright © 2016年 DennisDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (CHCategory)

// 0 --> 0.00
- (nullable NSString *)ch_stringWithDecimalStyle;

// 0 --> 0
- (nullable NSString *)ch_stringWithNormalDecimalStyle;

// 转换数字保留scale位小数
- (nullable NSString *)ch_stringWithNoStyleDecimalScale:(short)scale;
- (nullable NSString *)ch_stringWithNoStyleDecimalNozeroScale:(short)scale;
- (nullable NSString *)ch_stringWithDecimalStyleDecimalScale:(short)scale;

- (nullable NSString *)ch_stringWithNoStyleMaximumFractionDigits:(NSUInteger)maximumFractionDigits minimumFractionDigits:(NSUInteger)minimumFractionDigits;
- (nullable NSString *)ch_stringWithDecimalStyleMaximumFractionDigits:(NSUInteger)maximumFractionDigits minimumFractionDigits:(NSUInteger)minimumFractionDigits;

- (nullable NSString *)ch_stringWithNumberFormatUsePositiveFormat:(nullable NSString *)positiveFormat;

- (nullable NSString *)ch_stringWithNumberFormat:(nullable NSNumberFormatter *)formatter;

@end
