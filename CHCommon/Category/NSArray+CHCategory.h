//
//  NSArray+CHCategory.h
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (CHCategory)

- (nullable id)ch_safeObjectAtIndex:(NSUInteger)index;

- (nullable id)ch_findFirstObjectWithKey:(NSString *)key value:(nonnull id)value;

@end

NS_ASSUME_NONNULL_END
