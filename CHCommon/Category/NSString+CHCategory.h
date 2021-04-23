//
//  NSString+CHCategory.h
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CHCategory)

- (NSString *)ch_trimAllSpace;

- (CGSize)ch_sizeToFitWidth:(CGFloat)width withFont:(nullable UIFont *)font;
- (CGSize)ch_sizeToFit:(CGSize)maxSize withFont:(nullable UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGFloat)ch_widthToFitHeight:(CGFloat)height withFont:(UIFont *)font;
@end

NS_ASSUME_NONNULL_END
