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

static NSString *const kToken = nil;

@interface CHLiveRoomVC ()

/// current user
@property (nonatomic, strong) CHRoomUser *localUser;

@property (nonatomic, strong) NSMutableDictionary *smallVideoViews;

@property (nonatomic, weak) CHLiveRoomFrontView *liveRoomFrontView;

@property (nonatomic, strong) CHMusicView *musicView;

@end

@implementation CHLiveRoomVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.userList = [NSMutableArray array];
    
    self.smallVideoViews = [NSMutableDictionary dictionary];
    
    [self setupFrontViewUI];
    
    [self beginLiveJoinChannel];
    
    [self setupMusicView];
}

- (void)setupFrontViewUI
{
    CHLiveRoomFrontView *liveRoomFrontView = [[CHLiveRoomFrontView alloc]initWithFrame:self.view.bounds WithUserType:self.roleType];
    self.liveRoomFrontView = liveRoomFrontView;
    [self.view addSubview:liveRoomFrontView];
    liveRoomFrontView.nickName = self.nickName;
    
    CHWeakSelf
    liveRoomFrontView.liveRoomFrontViewButtonsClick = ^(UIButton * _Nonnull button) {
        [weakSelf frontViewButtonsClick:button];
    
    };
    liveRoomFrontView.sendMessage = ^(NSString * _Nonnull message) {
        [weakSelf sendMessageWithText:message withMessageType:CHChatMessageType_Text withMemberModel:weakSelf.localUser];
    };
    
    CHChatMessageModel *model = [[CHChatMessageModel alloc]init];
    model.sendUser = self.localUser;
    model.message = @"更多功能";
    
    
    CHChatMessageModel *model1 = [[CHChatMessageModel alloc]init];
    model1.sendUser = self.localUser;
    model1.message = @"文字聊天与进出信息显示";
    
    CHChatMessageModel *model2 = [[CHChatMessageModel alloc]init];
    model2.sendUser = self.localUser;
    model2.message = @"花名册：主播可以通过花名册邀请观众连麦（主播邀请->观众同意->观众上麦）、断开正在连麦的观众，以及查看/同意/拒绝观众的连麦申请；";
    
    CHChatMessageModel *model3 = [[CHChatMessageModel alloc]init];
    model3.sendUser = self.localUser;
    model3.message = @"美颜功能（待定）";
    
    CHChatMessageModel *model4 = [[CHChatMessageModel alloc]init];
    model4.sendUser = self.localUser;
    model4.message = @"播放背景音乐：从系统内预置的几段音乐中选择一段播放；";
    
    
    CHChatMessageModel *model5 = [[CHChatMessageModel alloc]init];
    model5.sendUser = self.localUser;
    model5.message = @"更多功能：查看实时数据（当前房间视频参数、接收码率和丢包率、发送码率和丢";
    
    CHChatMessageModel *model6 = [[CHChatMessageModel alloc]init];
    model6.sendUser = self.localUser;
    model6.message = @"包率）、视频设置（分辨率、帧率、码率）、摄像头翻转、开关摄像头和麦克风；连麦浮窗：最多3路观众上麦，连麦浮窗上显示观众名称，主播可关闭其下麦；";
    
    CHChatMessageModel *model7 = [[CHChatMessageModel alloc]init];
    model7.sendUser = self.localUser;
    model7.message = @"当本通道有观众连麦时，不可发起跨房间PK，当无人连麦时，主播可以发起跨房间PK，如下所示：";
    
    NSMutableArray * mutArray = [NSMutableArray array];
    [mutArray addObject:model];
    [mutArray addObject:model1];
    [mutArray addObject:model2];
    [mutArray addObject:model3];
    [mutArray addObject:model4];
    [mutArray addObject:model5];
    [mutArray addObject:model6];
    [mutArray addObject:model7];
    liveRoomFrontView.SCMessageList = mutArray;
}

- (void)setupMusicView
{
    CHMusicView *musicView = [[CHMusicView alloc] init];
    self.musicView = musicView;
    musicView.frame = CGRectMake(0, self.view.ch_height, self.view.ch_width, 200.0f);
    [self.view addSubview:musicView];
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
            
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.liveRoomFrontView.inputView resignFirstResponder];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.beautyView.ch_originY = self.view.ch_height;
//        self.videoSetView.ch_originY = self.view.ch_height;
//        self.resolutionView.ch_originY = self.view.ch_height;
//        self.rateView.ch_originY = self.view.ch_height;
        self.musicView.ch_originY = self.view.ch_height;
    }];
}

#pragma mark - Join Channel

/// Join Channel
- (void)beginLiveJoinChannel
{
    // user property
    NSMutableDictionary *userProperty = [NSMutableDictionary dictionary];
    [userProperty ch_setString:self.nickName forKey:sCHUserNickname];
    NSMutableDictionary *userCameras = [NSMutableDictionary dictionary];
    [userCameras setObject:@{sCHUserVideoFail: @(CHDeviceFaultNone)} forKey:sCHUserDefaultSourceId];
    [userProperty setObject:userCameras forKey:sCHUserCameras];
    [userProperty ch_setUInteger:CHDeviceFaultNone forKey:sCHUserAudioFail];
    [userProperty ch_setUInteger:self.roleType forKey:sCHUserRole];

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
