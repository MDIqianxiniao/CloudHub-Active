//
//  CHSetToolView.h
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/26.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CHSetToolViewButton_LinkMic,
    CHSetToolViewButton_Camera,
    CHSetToolViewButton_Mic,
    CHSetToolViewButton_SwitchCam,
    CHSetToolViewButton_VideoSet
} CHSetToolViewButton;

NS_ASSUME_NONNULL_BEGIN

@interface CHSetToolView : UIView

/// 当前用户是否上台
@property (nonatomic, assign) BOOL isUpStage;

@property (nonatomic, copy) void(^setToolViewButtonsClick)(UIButton *button);

- (instancetype)initWithFrame:(CGRect)frame  WithUserType:(CHUserRoleType)roleType;

@end

NS_ASSUME_NONNULL_END
