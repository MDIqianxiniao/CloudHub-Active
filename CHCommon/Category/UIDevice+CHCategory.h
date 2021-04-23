//
//  UIDevice+CHCategory.h
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (CHCategory)

+ (BOOL)ch_isIPhoneNotchScreen;
+ (BOOL)ch_isiPad;
+ (BOOL)ch_isiPhone;

@end

NS_ASSUME_NONNULL_END
