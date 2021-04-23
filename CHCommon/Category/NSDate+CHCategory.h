//
//  NSDate+CHCategory.h
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (CHCategory)

+ (NSString *)ch_stringFromTs:(NSTimeInterval)timestamp formatter:(NSString *)formatter;

+ (NSString *)ch_countDownENStringDateFromTs:(NSUInteger)count;

@end

NS_ASSUME_NONNULL_END
