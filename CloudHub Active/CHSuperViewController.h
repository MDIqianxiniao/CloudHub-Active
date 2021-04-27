//
//  CHSuperViewController.h
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/25.
//

#import <UIKit/UIKit.h>
#import "CHVideoView.h"
#import "CHBeautySetView.h"
#import "CHLiveModel.h"

#define CellGap ([UIDevice ch_isiPad] ? 20.0f : 8.0f)

NS_ASSUME_NONNULL_BEGIN

@interface CHSuperViewController : UIViewController
<
    CloudHubRtcEngineDelegate,
    CHVideoViewDelegate
>

@property (nonatomic, strong,nullable) CloudHubRtcEngineKit *rtcEngine;

/// current user
@property (nonatomic, strong) CHRoomUser *localUser;

@property (nonatomic, strong) CHVideoView *largeVideoView;

@property (nonatomic, strong) CHLiveModel *liveModel;

@property (nonatomic, strong) CHBeautySetView *beautyView;

@property (nonatomic, assign) CHUserRoleType roleType;


- (BOOL)sendMessageWithText:(NSString *)message withMessageType:(CHChatMessageType)messageType withMemberModel:(CHRoomUser *)memberModel;

@end

NS_ASSUME_NONNULL_END
