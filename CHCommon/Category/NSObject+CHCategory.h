//
//  NSObject+CHCategory.h
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CHCategory)

- (BOOL)ch_isValided;
- (BOOL)ch_isNotNSNull;
- (BOOL)ch_isNotEmpty;
- (BOOL)ch_isNotEmptyExceptNSNull;
- (BOOL)ch_isNotEmptyDictionary;

@end

NS_ASSUME_NONNULL_END
