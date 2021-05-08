//
//  CHCreatLiveView.h
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/22.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CHCreateRoomFrontButton_Back,
    CHCreateRoomFrontButton_Camera,
    CHCreateRoomFrontButton_Beauty,
    CHCreateRoomFrontButton_Start,
    CHCreateRoomFrontButton_Setting,
} CHCreateRoomFrontButton;

NS_ASSUME_NONNULL_BEGIN

@interface CHCreatLiveFrontView : UIView

@property (nonatomic, copy) NSString *channelId;

@property (nonatomic, weak,readonly) UITextField *liveNumField;

@property (nonatomic, copy) void(^creatLiveViewButtonsClick)(UIButton *sender);

@end

NS_ASSUME_NONNULL_END
