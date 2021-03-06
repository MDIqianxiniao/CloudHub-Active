//
//  CHBeautySetModel.h
//  YSLive
//
//  Created by jiang deng on 2021/3/30.
//  Copyright © 2021 CH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHBeautySetModel : NSObject

/// 美白值
@property (nonatomic, assign) CGFloat whitenValue;
/// 瘦脸值
@property (nonatomic, assign) CGFloat thinFaceValue;
/// 大眼值
@property (nonatomic, assign) CGFloat bigEyeValue;
/// 磨皮值
@property (nonatomic, assign) CGFloat exfoliatingValue;
/// 红润值
@property (nonatomic, assign) CGFloat ruddyValue;

@end

NS_ASSUME_NONNULL_END
