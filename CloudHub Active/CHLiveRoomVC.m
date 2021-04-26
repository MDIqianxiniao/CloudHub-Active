//
//  CHLiveRoomVC.m
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/25.
//

#import "CHLiveRoomVC.h"
#import "CHCloudHubUtil.h"
#import "CHLiveRoomFrontView.h"

#define VideoWidth 86
#define VideoHeight 115

static NSString *const kToken = nil;

@interface CHLiveRoomVC ()

/// user nick name
@property (nonatomic, copy) NSString *myNickName;

/// current user
@property (nonatomic, strong) CHRoomUser *localUser;

@property (nonatomic, strong) NSMutableDictionary *smallVideoViews;

@property (nonatomic, weak) CHLiveRoomFrontView *liveRoomFrontView;

@property (nonatomic, assign) BOOL isJoinChannel;

@end

@implementation CHLiveRoomVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.rtcEngine.delegate = self;
    
    self.userList = [NSMutableArray array];
    
    self.smallVideoViews = [NSMutableDictionary dictionary];
    
    self.myNickName = [[NSUserDefaults standardUserDefaults] objectForKey:CHCacheAnchorName];
    
    [self setupFrontViewUI];
    
    [self beginLiveJoinChannel];
}

- (void)setupFrontViewUI
{
    CHLiveRoomFrontView *liveRoomFrontView = [[CHLiveRoomFrontView alloc]initWithFrame:self.view.bounds WithUserType:self.roleType];
    self.liveRoomFrontView = liveRoomFrontView;
    [self.view addSubview:liveRoomFrontView];
    liveRoomFrontView.nickName = self.myNickName;
    
    CHWeakSelf
    liveRoomFrontView.liveRoomFrontViewButtonsClick = ^(UIButton * _Nonnull button) {
        [weakSelf frontViewButtonsClick:button];
    };
    
    liveRoomFrontView.sendMessage = ^(NSString * _Nonnull message) {
        [weakSelf sendMessageWithText:message withMessageType:CHChatMessageType_Text withMemberModel:weakSelf.localUser];
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
            [self leftChannel];
            
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
    [self.liveRoomFrontView.inputView resignFirstResponder];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.beautyView.ch_originY = self.view.ch_height;

    }];
}

#pragma mark - Join Channel

/// Join Channel
- (void)beginLiveJoinChannel
{
    // user property
    NSMutableDictionary *userProperty = [NSMutableDictionary dictionary];
    [userProperty ch_setString:self.myNickName forKey:sCHUserNickname];
    NSMutableDictionary *userCameras = [NSMutableDictionary dictionary];
    [userCameras setObject:@{sCHUserVideoFail: @(CHDeviceFaultNone)} forKey:sCHUserDefaultSourceId];
    [userProperty setObject:userCameras forKey:sCHUserCameras];
    [userProperty ch_setUInteger:CHDeviceFaultNone forKey:sCHUserAudioFail];
    [userProperty ch_setUInteger:self.roleType forKey:sCHUserRole];

    NSString *str = [userProperty ch_toJSON];

    BOOL dskj =  [self.rtcEngine joinChannelByToken:kToken channelId:self.liveModel.channelId properties:str uid:nil joinSuccess:nil];
    
    NSLog(@"%@,%d",self.rtcEngine,dskj);
}

- (void)leftChannel
{
    if (self.isJoinChannel)
    {
        [self.rtcEngine leaveChannel:nil];
        return;
    }

//    self.rtcEngine.delegate = nil;
//    self.rtcEngine = nil;
    
    [self.rtcEngine stopPlayingLocalVideo];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rtcEngine:(CloudHubRtcEngineKit *)engine didJoinChannel:(NSString *)channel withUid:(NSString *)uid elapsed:(NSInteger)elapsed
{
    self.isJoinChannel = YES;
    
    CHRoomUser *roomUser = [[CHRoomUser alloc] initWithPeerId:uid];
    roomUser.nickName = self.myNickName;
    roomUser.cloudHubRtcEngineKit = self.rtcEngine;
    self.localUser = roomUser;
    
    [self.userList addObject:self.localUser];
    
    if (self.roleType == CHUserType_Anchor)
    {
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
   
    CHChatMessageModel *model2 = [[CHChatMessageModel alloc]init];
    model2.sendUser = self.localUser;
    model2.message = @"花名册：主播可以通过花名册邀请观众连麦（主播邀请->观众同意->观众上麦）、断开正在连麦的观众，以及查看/同意/拒绝观众的连麦申请；";
    
    CHChatMessageModel *model3 = [[CHChatMessageModel alloc]init];
    model3.sendUser = self.localUser;
    model3.message = @"美颜功能（待定）";
    
    CHChatMessageModel *model4 = [[CHChatMessageModel alloc]init];
    model4.sendUser = self.localUser;
    model4.message = @"播放背景音乐：从系统内预置的几段音乐中选择一段播放；";
    model4.chatMessageType = CHChatMessageType_Tips;
    
    
    CHChatMessageModel *model5 = [[CHChatMessageModel alloc]init];
    model5.sendUser = self.localUser;
    model5.message = @"更多功能：查看实时数据（当前房间视频参数、接收码率和丢包率、发送码率和丢";
        
    NSMutableArray * mutArray = [NSMutableArray array];

    [mutArray addObject:model2];
    [mutArray addObject:model3];
    [mutArray addObject:model4];
    [mutArray addObject:model5];

    self.liveRoomFrontView.SCMessageList = mutArray;
    
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

    [self.rtcEngine enableLocalAudio:NO];
    [self.rtcEngine enableLocalVideo:NO];
    [self.rtcEngine disableAudio];
    [self.rtcEngine disableVideo];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rtcEngine:(CloudHubRtcEngineKit * _Nonnull)engine didJoinedOfUid:(NSString * _Nonnull)uid properties:(NSString * _Nullable)properties isHistory:(BOOL)isHistory fromChannel:(NSString* _Nonnull)srcChannel
{
    NSLog(@"rtcEngine didJoinedOfUid %@ %@ %d %@", uid, properties, isHistory, srcChannel);

    NSDictionary *propertDic = [CHCloudHubUtil convertWithData:properties];
    
    [self addRoomUserWithId:uid properties:propertDic];
}

- (void)rtcEngine:(CloudHubRtcEngineKit * _Nonnull)engine remoteVideoStateChangedOfUid:(NSString * _Nonnull)uid sourceID:(NSString * _Nonnull)sourceID streamID:(NSString * _Nonnull)streamID type:(CloudHubMediaType)type state:(CloudHubVideoRemoteState)state reason:(CloudHubVideoRemoteStateReason)reason
{
    NSLog(@"rtcEngine remoteVideoStateChangedOfUid:%@ %@ %@ %@ %@", uid, sourceID, @(type), @(state), @(reason));
        
//    CHRoomUser *roomUser = [self getRoomUserWithId:uid];
//
//    if (roomUser.role == CHUserType_Anchor)
//    {
//        [self.rtcEngine startPlayingRemoteVideo:self.largeVideoView.contentView streamID:streamID renderMode:CloudHubVideoRenderModeHidden mirrorMode:CloudHubVideoMirrorModeDisabled];
//        return;
//    }
    
    if (state == CloudHubVideoRemoteStateStarting)
    {
        if (type & CloudHub_MEDIA_TYPE_AUDIO_AND_VIDEO || type & CloudHub_MEDIA_TYPE_AUDIO_ONLY)
        {
            if (reason == CloudHubVideoRemoteStateReasonRemoteUnmuted)
            {
                [self freshPlayVideo:uid streamId:streamID sourceId:sourceID mute:NO];
                return;
            }
        }
        
        if (reason == CloudHubVideoRemoteStateReasonAddRemoteStream)
        {
            [self playVideo:uid streamId:streamID sourceId:sourceID];
        }
    }
    else if (state == CloudHubVideoRemoteStateStopped)
    {
        if (type & CloudHub_MEDIA_TYPE_AUDIO_AND_VIDEO || type & CloudHub_MEDIA_TYPE_AUDIO_ONLY)
        {
            if (reason == CloudHubVideoRemoteStateReasonRemoteMuted)
            {
                [self freshPlayVideo:uid streamId:streamID sourceId:sourceID mute:YES];
                return;
            }
        }
        
        if (reason == CloudHubVideoRemoteStateReasonRemoveRemoteStream)
        {
            [self unPlayVideo:uid streamId:streamID];
        }
    }
}

- (void)unPlayVideo:(NSString*)uid streamId:(NSString *)streamId
{
    if ([self.largeVideoView.roomUser.peerID isEqualToString:uid])
    {
        [self.rtcEngine stopPlayingRemoteVideo:self.largeVideoView.streamId];
        return;
    }
    
    CHVideoView *view = [self.smallVideoViews objectForKey:streamId];
    
    [self.rtcEngine stopPlayingRemoteVideo:streamId];
    [view removeFromSuperview];
    
    [self.smallVideoViews removeObjectForKey:streamId];
    
    [self arrangeVideoViews];
}

- (void)freshPlayVideo:(NSString*)uid streamId:(NSString *)streamId sourceId:(NSString *)sourceId mute:(BOOL)mute
{
    if ([uid isEqualToString:self.largeVideoView.roomUser.peerID])
    {
        if ([uid isEqualToString:self.localUser.peerID])
        {
            if (mute)
            {
                [self.rtcEngine stopPlayingLocalVideo];
            }
            else
            {
                [self.rtcEngine startPlayingLocalVideo:self.largeVideoView.contentView renderMode:CloudHubVideoRenderModeHidden mirrorMode:CloudHubVideoMirrorModeDisabled];
            }
        }
        else
        {
            if (mute)
            {
                [self.rtcEngine stopPlayingRemoteVideo:streamId];
            }
            else
            {
                [self.rtcEngine startPlayingRemoteVideo:self.largeVideoView.contentView streamID:streamId renderMode:CloudHubVideoRenderModeHidden mirrorMode:CloudHubVideoMirrorModeDisabled];
            }
        }
        
        return;
    }
    
    CHVideoView *videoView = [self.smallVideoViews objectForKey:streamId];
    
    if (videoView)
    {
        [self freshPlayVideoView:videoView streamId:streamId mute:mute];
    }
}

- (void)freshPlayVideoView:(CHVideoView *)videoView streamId:(NSString *)streamId mute:(BOOL)mute
{
    if (mute)
    {
        if (videoView.roomUser == self.localUser)
        {
            [self.rtcEngine stopPlayingLocalVideo];
        }
        else
        {
            [self.rtcEngine stopPlayingRemoteVideo:streamId];
        }
    }
    else
    {
        if (videoView.roomUser == self.localUser)
        {
            [self.rtcEngine startPlayingLocalVideo:videoView.contentView renderMode:CloudHubVideoRenderModeHidden mirrorMode:CloudHubVideoMirrorModeDisabled];
        }
        else
        {
            [self.rtcEngine startPlayingRemoteVideo:videoView.contentView streamID:streamId renderMode:CloudHubVideoRenderModeHidden mirrorMode:CloudHubVideoMirrorModeDisabled];
        }
    }
}

#pragma mark - playVideo

- (void)playVideo:(NSString*)uid streamId:(NSString *)streamId sourceId:(NSString *)sourceId
{
    if ([uid isEqualToString:self.largeVideoView.roomUser.peerID])
    {
        return;
    }
    
    @synchronized (self.smallVideoViews)
    {
        CHVideoView *view = [self.smallVideoViews objectForKey:streamId];
        if (!view)
        {
            view = [[CHVideoView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
            [self.view addSubview:view];
            view.delegate = self;
            view.streamId = streamId;
            view.sourceId = sourceId;
            
            CHRoomUser *roomUser = [self getRoomUserWithId:uid];
            view.roomUser = roomUser;
            
            [self.smallVideoViews setObject:view forKey:streamId];
            
            [self arrangeVideoViews];
        }
        
        [self freshPlayVideoView:view streamId:streamId mute:NO];
    }
}

- (void)arrangeVideoViews
{
    CGFloat margin = [UIDevice ch_isiPad] ? 10 : 5;
    CGFloat x = self.view.ch_width - VideoWidth - 5;
    CGFloat y = self.view.ch_height - 100 - VideoHeight;
    
    NSArray *array = [self.smallVideoViews allValues];
    
    for (int i = 0; i < array.count; i++)
    {
        UIView *smallview = array[i];
        
        CGRect frame = CGRectMake(x, y - i * (VideoHeight + margin), VideoWidth, VideoHeight);
        
        [smallview setFrame:frame];

        [self.view bringSubviewToFront:smallview];
    }
}

#pragma mark - CHVideoViewDelegate

- (void)clickViewToControlWithVideoView:(CHVideoView *)videoView
{
    CHRoomUser *roomUser = videoView.roomUser;
    CHRoomUser *largeRoomUser = self.largeVideoView.roomUser;
    NSString *streamId = self.largeVideoView.streamId;
    NSString *sourceId = self.largeVideoView.sourceId;

    if (largeRoomUser == self.localUser)
    {
        [self.rtcEngine stopPlayingLocalVideo];
    }
    else if (largeRoomUser)
    {
        [self.rtcEngine stopPlayingRemoteVideo:self.largeVideoView.streamId];
    }
    
    if (roomUser == self.localUser )
    {
        [self.rtcEngine stopPlayingLocalVideo];
        [self.smallVideoViews removeObjectForKey:self.localUser.peerID];
        
        [self.rtcEngine startPlayingLocalVideo:self.largeVideoView.contentView renderMode:CloudHubVideoRenderModeHidden mirrorMode:CloudHubVideoMirrorModeDisabled];
        self.largeVideoView.roomUser = self.localUser;
        self.largeVideoView.sourceId = self.localUser.peerID;
        self.largeVideoView.streamId = self.localUser.peerID;
    }
    else
    {
        [self.rtcEngine stopPlayingRemoteVideo:videoView.streamId];
        [self.smallVideoViews removeObjectForKey:videoView.streamId];
        
        [self.rtcEngine startPlayingRemoteVideo:self.largeVideoView.contentView streamID:videoView.streamId renderMode:CloudHubVideoRenderModeHidden mirrorMode:CloudHubVideoMirrorModeDisabled];
        self.largeVideoView.roomUser = roomUser;
        self.largeVideoView.streamId = videoView.streamId;
        self.largeVideoView.sourceId = videoView.sourceId;
    }
    self.largeVideoView.roomUser = roomUser;

    [videoView removeFromSuperview];
        
    if (!largeRoomUser)
    {
        [self arrangeVideoViews];
        return;
    }
    
    [self playVideo:largeRoomUser.peerID streamId:streamId sourceId:sourceId];
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

- (BOOL)sendMessageWithText:(NSString *)message withMessageType:(CHChatMessageType)messageType withMemberModel:(CHRoomUser *)memberModel
{
    if ([message ch_isNotEmpty])
    {
        NSMutableDictionary *messageDic = [[NSMutableDictionary alloc] init];
        // 0 消息
        [messageDic setObject:@(0) forKey:@"type"];
        NSDictionary *senderDic = @{ @"role" : @(self.roleType), @"nickname" : self.myNickName };
        [messageDic setObject:senderDic forKey:@"sender"];

        return ([self.rtcEngine sendChatMsg:message to:CHRoomPubMsgTellAll withExtraData:[messageDic ch_toJSON]] == 0);
    }
    return NO;
}

@end
