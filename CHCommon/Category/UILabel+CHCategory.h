//
//  UILabel+CHCategory.h
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (CHCategory)

- (CGSize)ch_labelSizeToFit:(CGSize)maxSize;

- (CGSize)ch_attribSizeToFit:(CGSize)maxSize;

- (CGFloat)ch_calculatedHeight;

@end

NS_ASSUME_NONNULL_END
