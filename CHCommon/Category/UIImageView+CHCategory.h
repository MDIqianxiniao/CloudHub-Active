//
//  UIImageView+CHCategory.h
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (CHCategory)

+ (nullable instancetype)ch_imageViewWithImageArray:(NSArray *)imageArray duration:(NSTimeInterval)duration;
+ (nullable instancetype)ch_imageViewWithImageArray:(NSArray *)imageArray duration:(NSTimeInterval)duration repeatCount:(NSUInteger)repeatCount;

- (void)ch_animationWithImageArray:(NSArray *)imageArray duration:(NSTimeInterval)duration repeatCount:(NSUInteger)repeatCount;
- (void)ch_animationWithImageArray:(NSArray *)imageArray duration:(NSTimeInterval)duration repeatCount:(NSUInteger)repeatCount imageWithIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
