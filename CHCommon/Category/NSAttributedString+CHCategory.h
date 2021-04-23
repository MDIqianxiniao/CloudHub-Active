//
//  NSAttributedString+CHCategory.h
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (CHCategory)

- (CGSize)ch_sizeToFitWidth:(CGFloat)width;
- (CGSize)ch_sizeToFitHeight:(CGFloat)height;
- (CGSize)ch_sizeToFit:(CGSize)maxSize lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end

NS_ASSUME_NONNULL_END
