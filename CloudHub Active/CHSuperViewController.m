//
//  CHSuperViewController.m
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/25.
//

#import "CHSuperViewController.h"



@interface CHSuperViewController ()


@end

@implementation CHSuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rtcEngine = RtcEngine;
    self.rtcEngine.delegate = self;

    
    
    
    
    // 主播视频
    [self setupLargeVideoView];
}



// 主播视频
- (void)setupLargeVideoView
{
    CHVideoView *largeVideoView = [[CHVideoView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:largeVideoView];
    largeVideoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    largeVideoView.isBigView = YES;
    self.largeVideoView = largeVideoView;
    [self.rtcEngine startPlayingLocalVideo:self.largeVideoView.contentView renderMode:CloudHubVideoRenderModeHidden mirrorMode:CloudHubVideoMirrorModeDisabled];
}

- (CHBeautySetView *)beautyView
{
    if (!_beautyView)
    {
        _beautyView = [[CHBeautySetView alloc]initWithFrame:CGRectMake(0, self.view.ch_height, self.view.ch_width, 0) itemGap:CellGap];
        
        [self.view addSubview:_beautyView];
    }
    return _beautyView;
}

- (BOOL)sendMessageWithText:(NSString *)message withMessageType:(CHChatMessageType)messageType withMemberModel:(CHRoomUser *)memberModel
{
    if ([message ch_isNotEmpty])
    {
//        NSTimeInterval timeInterval = self.tCurrentTime;
//        NSString *time = [NSDate ch_stringFromTs:timeInterval formatter:@"HH:mm"];
//        NSString *messageId = [NSString stringWithFormat:@"chat_%@_%@", self.localUser.peerID, @((NSUInteger)(timeInterval))];
        NSString *toUserNickname = @"";
        NSString *toUserID = @"";
        if ([memberModel.peerID ch_isNotEmpty]) {
            toUserNickname = memberModel.nickName;
            toUserID = memberModel.peerID;
        }

//        NSString *senderId = self.localUser.peerID;
//        NSNumber *role = @(self.localUser.role);
//        NSString *nickname = self.localUser.nickName;
        
        NSMutableDictionary *messageDic = [[NSMutableDictionary alloc] init];
        // 0 消息
        [messageDic setObject:@(0) forKey:@"type"];
//        [messageDic setObject:time forKey:@"time"];
//        [messageDic setObject:@(timeInterval) forKey:@"timeInterval"];
//        [messageDic setObject:messageId forKey:@"id"];
        [messageDic setObject:toUserNickname forKey:@"toUserNickname"];
        [messageDic setObject:toUserID forKey:@"toUserID"];
        NSDictionary *senderDic = @{ @"role" : @(self.roleType), @"nickname" : self.nickName };
        [messageDic setObject:senderDic forKey:@"sender"];

        return ([self.rtcEngine sendChatMsg:message to:CHRoomPubMsgTellAll withExtraData:[messageDic ch_toJSON]] == 0);
    }
    return NO;
}




- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


@end
