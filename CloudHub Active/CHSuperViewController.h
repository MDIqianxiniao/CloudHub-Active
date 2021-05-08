//
//  CHSuperViewController.h
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/25.
//

#import <UIKit/UIKit.h>
#import "CHVideoView.h"
#import "CHBeautySetView.h"
#import "CHVideoSetView.h"
#import "CHResolutionView.h"


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

@property (nonatomic, strong) CHLiveChannelModel *liveModel;

@property (nonatomic, strong) CHBeautySetView *beautyView;

@property (nonatomic, strong) CHVideoSetView *videoSetView;

/// resolution
@property (nonatomic, weak) CHResolutionView *resolutionView;

/// rate
@property (nonatomic, weak) CHResolutionView *rateView;

@property (nonatomic, assign) CHUserRoleType roleType;

@property (nonatomic, copy) NSString *chToken;

- (BOOL)sendMessageWithText:(NSString *)message withMessageType:(CHChatMessageType)messageType withMemberModel:(CHRoomUser *)memberModel;

@end

NS_ASSUME_NONNULL_END
