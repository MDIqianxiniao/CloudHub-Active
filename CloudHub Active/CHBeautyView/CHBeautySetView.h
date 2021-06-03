//
//  CHBeautySetView.h
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/23.
//

#import <UIKit/UIKit.h>
#import "CHBeautySetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CHBeautySetView : UIView

/// 美颜数据
@property (nonatomic, strong) CHBeautySetModel *beautySetModel;

@property (nonatomic, copy) void(^beautySetModelChange)(CHBeautySetModel *beautySetModel);

- (instancetype)initWithFrame:(CGRect)frame itemGap:(CGFloat)gap;

@end

NS_ASSUME_NONNULL_END
