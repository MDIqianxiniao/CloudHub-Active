//
//  CHLiveRoomVC.m
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/25.
//

#import "CHLiveRoomVC.h"
#import "CHCloudHubUtil.h"
#import "CHLiveRoomFrontView.h"
#import "CHMusicView.h"
#import "CHSetToolView.h"
#import "CHUserListTableView.h"
#import "CHChatInputView.h"

#define VideoWidth 86.0f
#define VideoHeight 115.0f

@interface CHLiveRoomVC ()

/// user nick name
@property (nonatomic, copy) NSString *myNickName;

@property (nonatomic, copy) NSString *myPeerId;

@property (nonatomic, strong) CHVideoView *myVideoView;

@property (nonatomic, strong) CHRoomUser *anchorUser;

@property (nonatomic, strong) NSMutableDictionary *smallVideoViews;

@property (nonatomic, assign) BOOL isJoinChannel;

@property (nonatomic, weak) CHLiveRoomFrontView *liveRoomFrontView;

@property (nonatomic, strong) CHUserListTableView *userListTableView;

@property (nonatomic, strong) CHMusicView *musicView;

@property (nonatomic, strong) CHChatInputView *chatInputView;

@property (nonatomic, strong) CHSetToolView *setToolView;

@property (nonatomic, strong) NSMutableArray<CHChatMessageModel *> *messageArray;

@property (nonatomic, assign) NSTimeInterval timeInterval;

@property (nonatomic, strong) NSTimer *tipMessageTimer;

@property (nonatomic, assign)BOOL anchorLeft;

@property (nonatomic, copy) NSString *sendResolution;

@property (nonatomic, assign) NSInteger sendRate;

@end

@implementation CHLiveRoomVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.rtcEngine.delegate = self;
    
    self.userList = [NSMutableArray array];
        
    self.messageArray = [NSMutableArray array];
    
    self.smallVideoViews = [NSMutableDictionary dictionary];
    
    self.myNickName = [CHUserDefault objectForKey:CHCacheAnchorName];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setupFrontViewUI];
        
    [self setupMusicView];
    
    [self setupChatInputView];
    
    self.tipMessageTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(getNewUserJoinChannel) userInfo:nil repeats:YES];
    
    self.myPeerId = [[NSUUID UUID] UUIDString];
    NSDictionary *dict = @{@"user_id":self.myPeerId,@"username":self.myNickName,@"user_role":@(self.roleType)};
    CHWeakSelf
    [CHNetworkRequest postWithURLString:sCHStoreTheChannel params:dict progress:nil success:^(NSDictionary * _Nonnull dictionary) {

        [weakSelf beginLiveJoinChannel];
    } failure:^(NSError * _Nonnull error) {

    }];
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
}

- (void)setupMusicView
{
    CHMusicView *musicView = [[CHMusicView alloc] init];
    self.musicView = musicView;
    musicView.frame = CGRectMake(0, self.view.ch_height, self.view.ch_width, 200.0f);
    [self.view addSubview:musicView];
}

- (void)setupChatInputView
{
    CHChatInputView *chatInputView = [[CHChatInputView alloc]initWithFrame:CGRectMake(0, self.view.ch_height, self.view.ch_width, 45)];
    self.chatInputView = chatInputView;
    [self.view addSubview:chatInputView];
    CHWeakSelf
    chatInputView.sendMessage = ^(NSString * _Nonnull message) {
            [weakSelf sendMessageWithText:message withMessageType:CHChatMessageType_Text withMemberModel:weakSelf.localUser];
        };
}

- (void)frontViewButtonsClick:(UIButton *)button
{
    switch (button.tag)
    {
        case CHLiveRoomFrontButton_userList:
        {
            if (self.userListTableView.ch_originY < self.view.ch_height)
            {
                [UIView animateWithDuration:0.25 animations:^{
                    self.userListTableView.ch_originY = self.view.ch_height;
               }];
            }
            else
            {
                [self getUserList];
            }
        }
            break;
        case CHLiveRoomFrontButton_Back:
        {
            [self leftChannel];
        }
            break;
        case CHLiveRoomFrontButton_Tools:
        {
            if (!self.setToolView)
            {
//                CHSetToolView *setToolView = [[CHSetToolView alloc]initWithFrame:CGRectMake(0, self.view.ch_height, self.view.ch_width, 0) WithUserType:self.roleType];
//                self.setToolView = setToolView;
//                [self.view addSubview:setToolView];
                
                CHWeakSelf
                self.setToolView.setToolViewButtonsClick = ^(UIButton * _Nonnull button) {
                    [weakSelf setToolButtonsClick:button];
                };
            }
            
            [UIView animateWithDuration:0.25 animations:^{
                self.setToolView.ch_originY = self.view.ch_height - self.setToolView.ch_height;
           }];
            
            [self.setToolView ch_bringToFront];
        }
            break;
        case CHLiveRoomFrontButton_Music:
        {
            [UIView animateWithDuration:0.25 animations:^{
                self.musicView.ch_originY = self.view.ch_height - self.musicView.ch_height;
            }];
            
            [self.musicView ch_bringToFront];
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
            
        case CHLiveRoomFrontButton_Chat:
        {
            [self.chatInputView.inputView becomeFirstResponder];
        }
            break;
            
        default:
            break;
    }
}

- (CHSetToolView *)setToolView
{
    if (!_setToolView)
    {
        _setToolView = [[CHSetToolView alloc]initWithFrame:CGRectMake(0, self.view.ch_height, self.view.ch_width, 0) WithUserType:self.roleType];
        [self.view addSubview:_setToolView];
    }
    return _setToolView;
}

- (void)getUserList
{
    CHWeakSelf
    [CHNetworkRequest getWithURLString:sCHGetUserList params:@{@"channel":self.liveModel.channelId} progress:nil success:^(NSDictionary * _Nonnull dictionary) {
        
        NSArray *array = dictionary[@"data"];
        
        [weakSelf.userList removeAllObjects];
        
        for (NSDictionary *dict in array)
        {
            NSString * peerId = dict[@"user_id"];
            
            CHRoomUser *user = [[CHRoomUser alloc]initWithPeerId:peerId];
            user.nickName = dict[@"username"];
            
            if ([weakSelf.localUser.peerID isEqualToString:peerId] && weakSelf.roleType == CHUserType_Anchor )
            {
                user.role = CHUserType_Anchor;
            }
            
            for (CHVideoView *videoView in weakSelf.smallVideoViews.allValues)
            {
                if ([videoView.roomUser.peerID isEqualToString:peerId])
                {
                    [user.properties ch_setUInteger:CHUser_PublishState_UP forKey:sCHUserPublishstate];
                    
                    break;
                }
            }

            user.cloudHubRtcEngineKit = weakSelf.rtcEngine;
            
            [weakSelf.userList addObject:user];
        }
        weakSelf.userListTableView.userListArray = weakSelf.userList;
        
        [weakSelf pushUserListTableView];
        
    } failure:^(NSError * _Nonnull error) {
        
        [weakSelf.userList removeAllObjects];
        weakSelf.userListTableView.userListArray = nil;
        [CHProgressHUD ch_showHUDAddedTo:weakSelf.view animated:YES withText:@"获取用户列表失败" delay:CHProgressDelay];
        
        [weakSelf pushUserListTableView];
    }];
}

- (void)pushUserListTableView
{
    [UIView animateWithDuration:0.25 animations:^{
        self.setToolView.ch_originY = self.view.ch_height;
        self.beautyView.ch_originY = self.view.ch_height;
        self.musicView.ch_originY = self.view.ch_height;
        self.videoSetView.ch_originY = self.view.ch_height;
        self.resolutionView.ch_originY = self.view.ch_height;
        self.rateView.ch_originY = self.view.ch_height;
                            
        self.userListTableView.ch_originY = self.view.ch_height - self.userListTableView.ch_height;
   }];
    
    [self.userListTableView ch_bringToFront];
}

- (void)setToolButtonsClick:(UIButton *)sender
{
    switch (sender.tag)
    {
        case CHSetToolViewButton_LinkMic:
        {
            sender.selected = !sender.selected;
            if (sender.selected)
            {
                [self.localUser sendToChangePublishstate:CHUser_PublishState_UP];
            }
            else
            {
                [self clickRemoveButtonToCloseVideoView:self.myVideoView];
            }
        }
            break;
        case CHSetToolViewButton_Camera:
        {
            sender.selected = !sender.selected;
            [self.rtcEngine muteLocalVideoStream:sender.selected];
                        
            [self freshPlayVideo:self.localUser.peerID streamId:self.localUser.peerID mute:sender.selected];
        }
            break;
        case CHSetToolViewButton_Mic:
        {
            sender.selected = !sender.selected;
            [self.rtcEngine muteLocalAudioStream:sender.selected];
            
        }
            break;
        case CHSetToolViewButton_SwitchCam:
        {
            [self.rtcEngine switchCamera:sender.selected];
            sender.selected = !sender.selected;
        }
            break;
        case CHSetToolViewButton_VideoSet:
        {
            [UIView animateWithDuration:0.25 animations:^{
                self.setToolView.ch_originY = self.view.ch_height;
                self.videoSetView.ch_originY = self.view.ch_height - self.videoSetView.ch_height;
           }];
            
            [self.videoSetView ch_bringToFront];
        }
            break;
            
        default:
            break;
    }
    
    [self.setToolView ch_bringToFront];
}

- (void)getNewUserJoinChannel
{
    //在这里执行事件
    CHWeakSelf
    [CHNetworkRequest getWithURLString:sCHJoinChannelRecord params:@{@"name":self.liveModel.channelId,@"point":@(self.timeInterval)} progress:nil success:^(NSDictionary * _Nonnull dictionary) {
        
        weakSelf.timeInterval = [dictionary[@"point"] doubleValue];
        
        NSArray *array = dictionary[@"data"];
        
        if ([array ch_isNotEmpty])
        {
            for (NSDictionary *dict in array)
            {
                CHChatMessageModel *messageModel = [[CHChatMessageModel alloc] init];
                messageModel.chatMessageType = CHChatMessageType_Tips;
                if ([dict[@"status"] integerValue])
                {
                    messageModel.message = [NSString stringWithFormat:@"%@ %@",dict[@"username"],CH_Localized(@"Login.EnterRoom")];
                }
                else
                {
                    messageModel.message = [NSString stringWithFormat:@"%@ %@",dict[@"username"],CH_Localized(@"Login.LeaveRoom")];
                }
                
                [weakSelf.messageArray addObject:messageModel];
                
                weakSelf.liveRoomFrontView.messageList = weakSelf.messageArray;
            }
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = nil;
    
    for (UITouch *cc in touches)
    {
        touch = cc;
        break;
    }
    CGPoint point = [touch locationInView:self.view];
    
    [self.liveRoomFrontView.inputView resignFirstResponder];
    
    if (point.y < self.resolutionView.ch_originY && self.resolutionView && self.resolutionView.ch_originY < self.view.ch_height)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.resolutionView.ch_originY = self.view.ch_height;
            self.videoSetView.ch_originY = self.view.ch_height - self.videoSetView.ch_height;
        }];
        return;
    }
    
    if (point.y < self.rateView.ch_originY && self.rateView && self.rateView.ch_originY < self.view.ch_height)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.rateView.ch_originY = self.view.ch_height;
            self.videoSetView.ch_originY = self.view.ch_height - self.videoSetView.ch_height;
        }];
        return;
    }
    
    if (point.y < self.videoSetView.ch_originY && self.videoSetView && self.videoSetView.ch_originY < self.view.ch_height)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.videoSetView.ch_originY = self.view.ch_height;
            self.setToolView.ch_originY = self.view.ch_height - self.setToolView.ch_height;
        }];
        return;
    }
    
    if (point.y < self.beautyView.ch_originY && self.beautyView && self.beautyView.ch_originY < self.view.ch_height)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.beautyView.ch_originY = self.view.ch_height;
        }];
        return;
    }
    
    if (point.y < self.setToolView.ch_originY && self.setToolView && self.setToolView.ch_originY < self.view.ch_height)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.setToolView.ch_originY = self.view.ch_height;
        }];
        return;
    }
    
    if (point.y < self.musicView.ch_originY && self.musicView && self.musicView.ch_originY < self.view.ch_height)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.musicView.ch_originY = self.view.ch_height;
        }];
        return;
    }
    
    if (point.y < self.userListTableView.ch_originY && self.userListTableView && self.userListTableView.ch_originY < self.view.ch_height)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.userListTableView.ch_originY = self.view.ch_height;
        }];
        return;
    }

    if (self.chatInputView.ch_originY < self.view.ch_height)
    {
        [self.chatInputView.inputView resignFirstResponder];
    }
}

#pragma mark - Join Channel

/// Join Channel
- (void)beginLiveJoinChannel
{
    NSMutableDictionary *userProperty = [NSMutableDictionary dictionary];
    [userProperty ch_setString:self.myNickName forKey:sCHUserNickname];
    NSMutableDictionary *userCameras = [NSMutableDictionary dictionary];
    [userCameras setObject:@{sCHUserVideoFail: @(CHDeviceFaultNone)} forKey:sCHUserDefaultSourceId];
    [userProperty setObject:userCameras forKey:sCHUserCameras];
    [userProperty ch_setUInteger:CHDeviceFaultNone forKey:sCHUserAudioFail];
    [userProperty ch_setUInteger:self.roleType forKey:sCHUserRole];

    NSString *str = [userProperty ch_toJSON];

    [self.rtcEngine joinChannelByToken:self.chToken channelId:self.liveModel.channelId properties:str uid:self.myPeerId autoSubscribeAudio:YES autoSubscribeVideo:YES joinSuccess:nil];
}

- (void)leftChannel
{
    if (!self.isJoinChannel)
    {
        [self.rtcEngine stopPlayingLocalVideo];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        CHWeakSelf
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:CH_Localized(@"Live_EntLive") message:CH_Localized(@"Live_EntLiveNow") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:CH_Localized(@"Live_Sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf.rtcEngine leaveChannel:nil];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:CH_Localized(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
        
        [alertVc addAction:sure];
        [alertVc addAction:cancel];
        
        [self presentViewController:alertVc animated:YES completion:nil];
    }
}

- (void)rtcEngine:(CloudHubRtcEngineKit *)engine didOccurError:(CloudHubErrorCode)errorCode withMessage:(NSString *)message
{
    
}

- (void)rtcEngine:(CloudHubRtcEngineKit *)engine didJoinChannelwithUid:(NSString *)uid elapsed:(NSInteger)elapsed
{
    self.isJoinChannel = YES;
    
    CHRoomUser *roomUser = [[CHRoomUser alloc] initWithPeerId:uid];
    roomUser.nickName = self.myNickName;
    roomUser.cloudHubRtcEngineKit = self.rtcEngine;
    roomUser.role = self.roleType;
    self.localUser = roomUser;
    [self.userList addObject:self.localUser];

    [self.rtcEngine enableAudio];
    [self.rtcEngine enableLocalAudio:YES];
    [self.rtcEngine enableVideo];
    [self.rtcEngine enableLocalVideo:YES];
    
    // 开启音量报告
    [self.rtcEngine enableAudioVolumeIndication:500 smooth:3 reportVAD:YES];
    
    if (self.roleType == CHUserType_Anchor)
    {
        [self.rtcEngine startPlayingLocalVideo:self.largeVideoView.contentView renderMode:CloudHubVideoRenderModeHidden mirrorMode:CloudHubVideoMirrorModeEnabled];
        self.largeVideoView.roomUser = self.localUser;
        self.largeVideoView.sourceId = self.localUser.peerID;
        self.largeVideoView.streamId = self.localUser.peerID;

        [self.rtcEngine publishStream];
        
        self.anchorUser = roomUser;
    }
}

- (void)rtcEngine:(CloudHubRtcEngineKit *)engine didReJoinChannelwithUid:(NSString *)uid elapsed:(NSInteger)elapsed
{
    NSLog(@"rtcEngine didReJoinChannel %@ %@", uid, @(elapsed));

    for (UIView *smallview in [self.smallVideoViews allValues])
    {
        if (smallview.superview)
        {
            [smallview removeFromSuperview];
        }
    }
    [self.smallVideoViews removeAllObjects];
    self.myVideoView = nil;
    
    [self.userList removeAllObjects];
    [self.userList addObject:self.localUser];

    if (self.roleType == CHUserType_Anchor)
    {
        [self.rtcEngine startPlayingLocalVideo:self.largeVideoView.contentView renderMode:CloudHubVideoRenderModeHidden mirrorMode:CloudHubVideoMirrorModeEnabled];
        self.largeVideoView.roomUser = self.localUser;
        self.largeVideoView.sourceId = self.localUser.peerID;
        self.largeVideoView.streamId = self.localUser.peerID;

        [self.rtcEngine publishStream];
    }
}

- (void)rtcEngine:(CloudHubRtcEngineKit *)engine didLeaveChannel:(CloudHubChannelStats *)stats
{
    if (self.anchorLeft)
    {
        [CHProgressHUD ch_showHUDAddedTo:self.view animated:YES withText:CH_Localized(@"Live_LeaveRoom") delay:CHProgressDelay];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CHProgressDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self leaveRoom];
        });
    }
    else
    {
        [self leaveRoom];
    }
}

- (void)leaveRoom
{
    [self.rtcEngine enableLocalAudio:NO];
    [self.rtcEngine enableLocalVideo:NO];
    [self.rtcEngine disableAudio];
    [self.rtcEngine disableVideo];
    
    [self.tipMessageTimer invalidate];
    self.tipMessageTimer = nil;

    [self.rtcEngine stopPlayingLocalVideo];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)rtcEngine:(CloudHubRtcEngineKit *)engine didJoinedOfUid:(NSString *)uid properties:(NSString *)properties isHistory:(BOOL)isHistory fromChannel:(NSString *)srcChannel
{
    NSLog(@"rtcEngine didJoinedOfUid %@ %@ %d %@", uid, properties, isHistory, srcChannel);

    NSDictionary *propertDic = [CHCloudHubUtil convertWithData:properties];
    
    CHRoomUser *roomUser = [self addRoomUserWithId:uid properties:propertDic];
    
    if (roomUser.role == CHUserType_Anchor)
    {
        self.anchorUser = roomUser;
    }
}

- (void)rtcEngine:(CloudHubRtcEngineKit *)engine didOfflineOfUid:(NSString *)uid
{
    NSLog(@"CHSessionManager didOfflineOfUid: %@", uid);
    
    CHRoomUser *roomUser = [self getRoomUserWithId:uid];

    if (roomUser.role == CHUserType_Anchor)
    {
        self.anchorLeft = YES;
        
        [self.rtcEngine leaveChannel:nil];
    }
}

- (void)rtcEngine:(CloudHubRtcEngineKit * _Nonnull)engine
onSetPropertyOfUid:(NSString * _Nonnull)uid
             from:(NSString * _Nullable)fromuid
       properties:(NSString * _Nonnull)prop
{
    NSLog(@"rtcEngine onSetPropertyOfUid %@ %@ %@", uid, fromuid, prop);

    NSData *propData = [prop dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *properties = nil;
    if (propData)
    {
        properties = [NSJSONSerialization JSONObjectWithData:propData options:NSJSONReadingMutableContainers error:nil];
    }

    if (!properties)
    {
        return;
    }
        
    if ([properties ch_containsObjectForKey:sCHUserPublishstate])
    {
        CHPublishState publishState = [properties ch_intForKey:sCHUserPublishstate];
                
        if ([self.localUser.peerID isEqualToString:uid] && self.roleType == CHUserType_Audience)
        {
            [self changeMyPublishState:publishState];

            if (publishState == CHUser_PublishState_UP)
            {
                self.setToolView.isUpStage = YES;
            }
            else
            {
                self.setToolView.isUpStage = NO;
            }
        }
        else if (self.roleType == CHUserType_Anchor)
        {
            if (self.userListTableView.ch_originY < self.view.ch_height)
            {
                CHRoomUser *roomUser = [self getRoomUserWithId:uid];
                
                if (![fromuid isEqualToString:self.localUser.peerID])
                {
                    [roomUser.properties ch_setUInteger:publishState forKey:sCHUserPublishstate];
                }
                
                self.userListTableView.userListArray = self.userList;
            }
        }
        return;
    }
}

- (void)rtcEngine:(CloudHubRtcEngineKit *)engine remoteVideoStateChangedOfUid:(NSString *)uid streamId:(NSString *)streamId type:(CloudHubMediaType)type state:(CloudHubVideoRemoteState)state reason:(CloudHubVideoRemoteStateReason)reason
{
    if (state == CloudHubVideoRemoteStateStarting)
    {
        if (type & CloudHub_MEDIA_TYPE_AUDIO_AND_VIDEO || type & CloudHub_MEDIA_TYPE_AUDIO_ONLY)
        {
            if (reason == CloudHubVideoRemoteStateReasonRemoteUnmuted)
            {
                [self freshPlayVideo:uid streamId:streamId mute:NO];
                return;
            }
        }
        
        if (reason == CloudHubVideoRemoteStateReasonAddRemoteStream)
        {
            [self playVideo:uid streamId:streamId];
        }
    }
    else if (state == CloudHubVideoRemoteStateStopped)
    {
        if (type & CloudHub_MEDIA_TYPE_AUDIO_AND_VIDEO || type & CloudHub_MEDIA_TYPE_AUDIO_ONLY)
        {
            if (reason == CloudHubVideoRemoteStateReasonRemoteMuted)
            {
                [self freshPlayVideo:uid streamId:streamId mute:YES];
                return;
            }
        }
        
         if (reason == CloudHubVideoRemoteStateReasonRemoveRemoteStream)
        {
            [self unPlayVideo:uid streamId:streamId];
        }
    }
}

- (void)rtcEngine:(CloudHubRtcEngineKit * _Nonnull)engine localVideoStats:(CloudHubRtcLocalVideoStats * _Nonnull)stats
{
    NSLog(@"rtcEngine localVideoStats:%@ %@", @(stats.encodedFrameWidth), @(stats.encodedFrameHeight));
    
    if (self.largeVideoView.roomUser == self.localUser)
    {
        self.sendRate = stats.sentFrameRate;
        if (stats.encodedFrameHeight > 0 && stats.encodedFrameWidth > 0) {
            self.sendResolution = [NSString stringWithFormat:@"%@ × %@",@(stats.encodedFrameHeight),@(stats.encodedFrameWidth)];
        }
    }
}

- (void)rtcEngine:(CloudHubRtcEngineKit *)engine
         onPubMsg:(NSString *)msgName
            msgId:(NSString *)msgId
             from:(NSString *)fromuid
         withData:(NSString *)data
associatedWithUser:(NSString *)uid
associatedWithMsg:(NSString *)assMsgID
               ts:(NSUInteger)ts
    withExtraData:(NSString *)extraData
        isHistory:(BOOL)isHistory
              seq:(NSInteger)seq
{
    // 房间用户数
    if ([msgName isEqualToString:sCHSignal_Notice_BigRoom_Usernum])
    {
        NSDictionary *dataDic = [CHCloudHubUtil convertWithData:data];
        NSUInteger count = [dataDic ch_uintForKey:@"num"];
        
        self.liveRoomFrontView.userNum = count;
    }
}

- (void)rtcEngine:(CloudHubRtcEngineKit *)engine
         onDelMsg:(NSString *)msgName
            msgId:(NSString *)msgId
             from:(NSString *)fromuid
         withData:(NSString *)data
{
//    NSDictionary *dataDic = [CHCloudHubUtil convertWithData:data];
    
  
}

#pragma mark - Message 即时消息

/// 即时消息
// 收到聊天消息
- (void)rtcEngine:(CloudHubRtcEngineKit *)engine
onChatMessageArrival:(NSString *)message
             from:(NSString *)fromuid
    withExtraData:(NSString *)extraData
{
    if (![message ch_isNotEmpty] || ![fromuid ch_isNotEmpty])
    {
        return;
    }
            
    NSData *propData = [extraData dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *messageDic = nil;
    if (propData)
    {
        messageDic = [NSJSONSerialization JSONObjectWithData:propData options:NSJSONReadingMutableContainers error:nil];
    }

    if (!messageDic)
    {
        return;
    }

    
    CHRoomUser *user = [[CHRoomUser alloc] initWithPeerId:fromuid];
    user.nickName = [messageDic ch_stringForKey:sCHUserNickname];
    user.role = [messageDic ch_intForKey:sCHUserRole];
    
    CHChatMessageModel *messageModel = [[CHChatMessageModel alloc] init];
    messageModel.sendUser = user;
    
    if ([[messageDic ch_stringForKey:@"msgtype"] isEqualToString:@"text"])
    {
        messageModel.chatMessageType = CHChatMessageType_Text;
    }
    
    messageModel.message = message;
    
    [self.messageArray addObject:messageModel];
    
    self.liveRoomFrontView.messageList = self.messageArray;
}

#pragma mark - 改变自己视频流发布状态

- (void)changeMyPublishState:(CHPublishState)publishState
{
    CHRoomUser *roomUser = self.localUser;
    
    if (publishState == CHUser_PublishState_UP)
    {
        [self.rtcEngine publishStream];//sCHUserDefaultSourceId
        [self playVideo:roomUser.peerID streamId:roomUser.peerID];
    }
    else
    {
        [self.rtcEngine unPublishStream];
        [self unPlayVideo:roomUser.peerID streamId:roomUser.peerID];
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
/*
- (void)unPlayAllVideo:(NSString*)uid
{
    for (CHVideoView *view in self.smallVideoViews.allValues)
    {
        if ([view.roomUser.peerID isEqualToString:uid])
        {
            [self unPlayVideo:uid streamId:view.streamId];
        }
    }
    
    if ([uid isEqualToString:self.largeVideoView.roomUser.peerID])
    {
        [self unPlayVideo:uid streamId:self.largeVideoView.streamId];
    }
}
 */

- (void)freshPlayVideo:(NSString*)uid streamId:(NSString *)streamId mute:(BOOL)mute
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
                [self.rtcEngine startPlayingLocalVideo:self.largeVideoView.contentView renderMode:CloudHubVideoRenderModeHidden mirrorMode:CloudHubVideoMirrorModeEnabled];
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
                [self.rtcEngine startPlayingRemoteVideo:self.largeVideoView.contentView streamId:streamId renderMode:CloudHubVideoRenderModeHidden mirrorMode:CloudHubVideoMirrorModeDisabled];
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
            [self.rtcEngine startPlayingLocalVideo:videoView.contentView renderMode:CloudHubVideoRenderModeHidden mirrorMode:CloudHubVideoMirrorModeEnabled];
        }
        else
        {
            [self.rtcEngine startPlayingRemoteVideo:videoView.contentView streamId:streamId renderMode:CloudHubVideoRenderModeHidden mirrorMode:CloudHubVideoMirrorModeDisabled];
        }
    }
}

#pragma mark - playVideo

- (void)playVideo:(NSString*)uid streamId:(NSString *)streamId
{
    if ([self.anchorUser.peerID isEqualToString:uid])
    {
        self.largeVideoView.roomUser = self.anchorUser;
        [self freshPlayVideoView:self.largeVideoView streamId:streamId mute:NO];
        return;
    }
    
    CHRoomUser *roomUser = [self getRoomUserWithId:uid];
    if (![roomUser ch_isNotEmpty])
    {
        roomUser = [[CHRoomUser alloc] initWithPeerId:uid];
        roomUser.cloudHubRtcEngineKit = self.rtcEngine;
        roomUser.role = CHUserType_Audience;
//        [self.userList addObject:roomUser];
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
            view.sourceId = [streamId componentsSeparatedByString:@":"].lastObject;
            view.roomUser = roomUser;
            
            [self.smallVideoViews setObject:view forKey:streamId];
            
            [self arrangeVideoViews];
            
            if ([uid isEqualToString:self.localUser.peerID])
            {
                self.myVideoView = view;
            }
        }
        
        if (self.roleType == CHUserType_Anchor)
        {
            [self.userListTableView ch_bringToFront];
            view.canRemove = YES;
        }
        else if ([self.localUser.peerID isEqualToString:uid])
        {
            view.canRemove = YES;
            
            if (self.setToolView.ch_originY < self.view.ch_height)
            {
                [self.setToolView ch_bringToFront];
            }
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
/*
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
        self.myVideoView = nil;
        
        [self.rtcEngine startPlayingLocalVideo:self.largeVideoView.contentView renderMode:CloudHubVideoRenderModeHidden mirrorMode:CloudHubVideoMirrorModeEnabled];
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
    
    [self playVideo:largeRoomUser.peerID streamId:streamId];
}

 */
- (void)clickRemoveButtonToCloseVideoView:(CHVideoView *)videoView
{
    if (self.roleType == CHUserType_Anchor)
    {
        [videoView.roomUser sendToChangePublishstate:CHUser_PublishState_DOWN];
    }
    else
    {
        [self.localUser sendToChangePublishstate:CHUser_PublishState_DOWN];
        
        [self.rtcEngine unPublishStream];
        [self unPlayVideo:self.localUser.peerID streamId:self.localUser.peerID];
    }
}

- (void)setSendResolution:(NSString *)sendResolution
{
    _sendResolution = sendResolution;
    
    if ([sendResolution ch_isNotEmpty] && ![sendResolution isEqualToString:self.videoSetView.resolutionString])
    {
        self.videoSetView.resolutionString = self.sendResolution;
    }
}

- (void)setSendRate:(NSInteger)sendRate
{
    _sendRate = sendRate;
    
    if (sendRate && [self.videoSetView.rateString integerValue] != sendRate)
    {
        self.videoSetView.rateString = [NSString stringWithFormat:@"%@",@(sendRate)];
    }
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
    
    if (self.roleType == CHUserType_Anchor && self.userListTableView.ch_originY < self.view.ch_height)
    {
        self.userListTableView.userListArray = self.userList;
    }
    
    return existRoomUser;
}
 
 
/*
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
    
    if (self.roleType == CHUserType_Anchor && self.userListTableView.ch_originY < self.view.ch_height)
    {
        self.userListTableView.userListArray = self.userList;
    }
    
    return existRoomUser;
}
 */
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
        [messageDic setObject:@(CHChatMessageType_Text) forKey:@"type"];
//        NSDictionary *senderDic = @{ sCHUserRole : @(self.roleType), sCHUserNickname : self.myNickName };
        [messageDic setObject:@(self.roleType) forKey:sCHUserRole];
        [messageDic setObject:self.myNickName forKey:sCHUserNickname];

        return ([self.rtcEngine sendChatMsg:message to:CHRoomPubMsgTellAll withExtraData:[messageDic ch_toJSON]] == 0);
    }
    return NO;
}

- (CHUserListTableView *)userListTableView
{
    if (!_userListTableView)
    {
        _userListTableView = [[CHUserListTableView alloc]initWithFrame:CGRectMake(0, self.view.ch_height, self.view.ch_width, 300)];
        [self.view addSubview:_userListTableView];
        
        _userListTableView.userListCellClick = ^(CHRoomUser * _Nonnull userModel) {
            [userModel sendToChangePublishstate:!userModel.publishState];
        };
    }
    
    return _userListTableView;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardF = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.chatInputView.ch_originY = self.view.ch_height - keyboardF.size.height - self.chatInputView.ch_height;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.chatInputView.ch_originY = self.view.ch_height;
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
