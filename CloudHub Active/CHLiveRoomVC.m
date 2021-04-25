//
//  CHLiveRoomVC.m
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/25.
//

#import "CHLiveRoomVC.h"
#import "CHCloudHubUtil.h"
#import "CHLiveRoomFrontView.h"


static NSString *const kToken = nil;

@interface CHLiveRoomVC ()

/// current user
@property (nonatomic, strong) CHRoomUser *localUser;

@property (nonatomic, strong) NSMutableDictionary *smallVideoViews;

@property (nonatomic, weak) CHLiveRoomFrontView *liveRoomFrontView;

@end

@implementation CHLiveRoomVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.yellowColor;
    
    self.userList = [NSMutableArray array];
    
    self.smallVideoViews = [NSMutableDictionary dictionary];
    
    [self setupFrontViewUI];
    
    [self beginLiveJoinChannel];
    
}

- (void)setupFrontViewUI
{
    CHLiveRoomFrontView *liveRoomFrontView = [[CHLiveRoomFrontView alloc]initWithFrame:self.view.bounds WithUserType:CHUserType_Anchor];
    self.liveRoomFrontView = liveRoomFrontView;
    [self.view addSubview:liveRoomFrontView];
    liveRoomFrontView.nickName = self.nickName;
    
    CHWeakSelf
    liveRoomFrontView.liveRoomFrontViewButtonsClick = ^(UIButton * _Nonnull button) {
        [weakSelf frontViewButtonsClick:button];
    };
}

- (void)frontViewButtonsClick:(UIButton *)button
{
    switch (button.tag)
    {
        case CHLiveRoomFrontButton_userList:
        {
            
        }
            break;
        case CHLiveRoomFrontButton_Back:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case CHLiveRoomFrontButton_Chat:
        {
            
        }
            break;
        case CHLiveRoomFrontButton_Music:
        {
            
        }
            break;
        case CHLiveRoomFrontButton_Beauty:
        {
            [UIView animateWithDuration:0.25 animations:^{
                self.beautyView.ch_originY = self.view.ch_height - self.beautyView.ch_height;
           }];
            
            [self.beautyView ch_bringToFront];
        }
            break;
            
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self.liveFrontView.liveNumField resignFirstResponder];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.beautyView.ch_originY = self.view.ch_height;
//        self.videoSetView.ch_originY = self.view.ch_height;
//        self.resolutionView.ch_originY = self.view.ch_height;
//        self.rateView.ch_originY = self.view.ch_height;
    }];
}

#pragma mark - Join Channel

/// Join Channel
- (void)beginLiveJoinChannel
{
//    self.nickName = [[NSUserDefaults standardUserDefaults] objectForKey:CHCacheAnchorName];
    
    // user property
    NSMutableDictionary *userProperty = [NSMutableDictionary dictionary];
    [userProperty ch_setString:self.nickName forKey:sCHUserNickname];
    NSMutableDictionary *userCameras = [NSMutableDictionary dictionary];
    [userCameras setObject:@{sCHUserVideoFail: @(CHDeviceFaultNone)} forKey:sCHUserDefaultSourceId];
    [userProperty setObject:userCameras forKey:sCHUserCameras];
    [userProperty ch_setUInteger:CHDeviceFaultNone forKey:sCHUserAudioFail];

    NSString *str = [userProperty ch_toJSON];

    [self.rtcEngine joinChannelByToken:kToken channelId:self.channelId properties:str uid:nil joinSuccess:nil];
}

- (void)rtcEngine:(CloudHubRtcEngineKit *)engine didJoinChannel:(NSString *)channel withUid:(NSString *)uid elapsed:(NSInteger)elapsed
{
    CHRoomUser *roomUser = [[CHRoomUser alloc] initWithPeerId:uid];
    roomUser.nickName = self.nickName;
    roomUser.cloudHubRtcEngineKit = self.rtcEngine;
    self.localUser = roomUser;
    
    [self.userList addObject:self.localUser];
    
    [self.rtcEngine enableAudio];
    [self.rtcEngine enableLocalAudio:YES];
    [self.rtcEngine enableVideo];
    [self.rtcEngine enableLocalVideo:YES];
    
    [self.rtcEngine startPlayingLocalVideo:self.largeVideoView.contentView renderMode:CloudHubVideoRenderModeHidden mirrorMode:CloudHubVideoMirrorModeDisabled];
    self.largeVideoView.roomUser = self.localUser;
    self.largeVideoView.sourceId = self.localUser.peerID;
    self.largeVideoView.streamId = self.localUser.peerID;

    [self.rtcEngine publishStream];
    
}

- (void)rtcEngine:(CloudHubRtcEngineKit * _Nonnull)engine didReJoinChannel:(NSString * _Nonnull)channel withUid:(NSString * _Nonnull)uid elapsed:(NSInteger) elapsed
{
    NSLog(@"rtcEngine didReJoinChannel %@ %@ %@", channel, uid, @(elapsed));

    for (UIView *smallview in [self.smallVideoViews allValues])
    {
        if (smallview.superview)
        {
            [smallview removeFromSuperview];
        }
    }
    [self.smallVideoViews removeAllObjects];
    
    [self.userList removeAllObjects];
    [self.userList addObject:self.localUser];

    [self.rtcEngine startPlayingLocalVideo:self.largeVideoView.contentView renderMode:CloudHubVideoRenderModeHidden mirrorMode:CloudHubVideoMirrorModeDisabled];
    self.largeVideoView.roomUser = self.localUser;
    self.largeVideoView.sourceId = self.localUser.peerID;
    self.largeVideoView.streamId = self.localUser.peerID;

    [self.rtcEngine publishStream];
}

- (void)rtcEngine:(CloudHubRtcEngineKit * _Nonnull)engine didLeaveChannel:(CloudHubChannelStats * _Nonnull)stats;
{
    NSLog(@"rtcEngine didLeaveChannel");
    
//    if (self.chatView)
//    {
//        [self.chatView removeFromSuperview];
//        [self.chatView destory];
//        self.chatView = nil;
//    }

    [self.rtcEngine enableLocalAudio:NO];
    [self.rtcEngine enableLocalVideo:NO];
    [self.rtcEngine disableAudio];
    [self.rtcEngine disableVideo];

    self.rtcEngine.delegate = nil;
    self.rtcEngine = nil;
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)rtcEngine:(CloudHubRtcEngineKit * _Nonnull)engine didJoinedOfUid:(NSString * _Nonnull)uid properties:(NSString * _Nullable)properties isHistory:(BOOL)isHistory fromChannel:(NSString* _Nonnull)srcChannel
{
    NSLog(@"rtcEngine didJoinedOfUid %@ %@ %d %@", uid, properties, isHistory, srcChannel);

    NSDictionary *propertDic = [CHCloudHubUtil convertWithData:properties];
    CHRoomUser *roomUser = [self addRoomUserWithId:uid properties:propertDic];
    
    NSLog(@"rtcEngine %@ didJoined", roomUser.nickName);
}

#pragma mark - userList

- (CHRoomUser *)addRoomUserWithId:(NSString *)peerId properties:(NSDictionary *)properties
{
    CHRoomUser *existRoomUser = nil;
    
    for (CHRoomUser *roomUser in self.userList)
    {
        if ([roomUser.peerID isEqualToString:peerId])
        {
            existRoomUser = roomUser;
            break;
        }
    }
    
    if (existRoomUser)
    {
        [existRoomUser updateWithProperties:properties];
    }
    else
    {
        if ([properties ch_containsObjectForKey:sCHUserNickname])
        {
            existRoomUser = [[CHRoomUser alloc] initWithPeerId:peerId properties:properties];
            existRoomUser.cloudHubRtcEngineKit = self.rtcEngine;
            [self.userList addObject:existRoomUser];
        }
    }
    
    return existRoomUser;
}

- (CHRoomUser *)removeRoomUserWithId:(NSString *)peerId
{
    // not remove self
    if ([peerId isEqualToString:self.localUser.peerID])
    {
        return self.localUser;
    }
    
    CHRoomUser *existRoomUser = nil;

    for (CHRoomUser *roomUser in self.userList)
    {
        if ([peerId isEqualToString:roomUser.peerID])
        {
            existRoomUser = roomUser;
            [self.userList removeObject:roomUser];
            break;
        }
    }
    
    return existRoomUser;
}

- (CHRoomUser *)getRoomUserWithId:(NSString *)userId
{
    if (![userId ch_isNotEmpty])
    {
        return nil;
    }

    CHRoomUser *user = [self.userList ch_findFirstObjectWithKey:@"peerID" value:userId];
    return user;
}


@end
