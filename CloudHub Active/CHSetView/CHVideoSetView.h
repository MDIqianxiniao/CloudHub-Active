//
//  CHVideoSetView.h
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHVideoSetView : UIView

@property (nonatomic, copy) void(^setArrowButtonClick)(UIButton *button);

- (instancetype)initWithFrame:(CGRect)frame itemGap:(CGFloat)gap;

@end

NS_ASSUME_NONNULL_END
