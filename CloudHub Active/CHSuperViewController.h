//
//  CHSuperViewController.h
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/25.
//

#import <UIKit/UIKit.h>
#import "CHVideoView.h"
#import "CHBeautySetView.h"

#define CellGap ([UIDevice ch_isiPad] ? 20.0f : 8.0f)

NS_ASSUME_NONNULL_BEGIN

@interface CHSuperViewController : UIViewController
<
    CloudHubRtcEngineDelegate,
    CHVideoViewDelegate
>

@property (nonatomic, strong,nullable) CloudHubRtcEngineKit *rtcEngine;

@property (nonatomic, strong) CHVideoView *largeVideoView;

@property (nonatomic, copy) NSString *channelId;
/// user nick name
@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, strong) CHBeautySetView *beautyView;

@end

NS_ASSUME_NONNULL_END
