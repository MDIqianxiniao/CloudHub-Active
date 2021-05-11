//
//  CHAppDefine.h
//  CloudHub
//
//  Created by 马迪 on 2021/1/29.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#ifndef CHAppDefine_h
#define CHAppDefine_h

#define CH_VCBUNDLE_NAME        @"CHResources.bundle"
#define CHVC_Localized          [NSBundle bundleWithPath:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:CH_VCBUNDLE_NAME]]
#define CH_Localized(s)       [CHVC_Localized localizedStringForKey:s value:@"" table:nil]

#define CHLiveActive_Server          @"api.roadofcloud.net"


/// The cache key
static NSString *const CHCacheAnchorName                  = @"AnchorName";

/// Send a message to everyone on the channel
static NSString *const CHRoomPubMsgTellAll                  = @"__all";

/// Send a message to everyone on the channel except yourself
static NSString *const CHRoomPubMsgTellAllExceptSender      = @"__allExceptSender";
/// Send a message to everyone on the channel except the auditing user
static NSString *const CHRoomPubMsgTellAllExceptAuditor     = @"__allExceptAuditor";
/// Send only to special roles (TA and teacher)
static NSString *const CHRoomPubMsgTellAllSuperUsers        = @"__allSuperUsers";
/// Only send information to the server, not to anyone
static NSString *const CHRoomPubMsgTellNone                 = @"__none";
/// synchronize server time
static NSString *const sCHSignal_UpdateTime                 = @"UpdateTime";
/// Class begin
static NSString *const sCHSignal_ClassBegin                 = @"ClassBegin";
/// Class over
static NSString *const sCHSignal_Server_RoomEnd             = @"Server_RoomEnd";

/// User properties
static NSString *const sCHUserProperties            = @"properties";

/// User nickname
static NSString *const sCHUserNickname              = @"userName";
/// User role
static NSString *const sCHUserRole                  = @"userRole";

static NSString *const sCHUserDefaultSourceId       = @"default_source_id";
static NSString *const sCHUserCameras               = @"cameras";
static NSString *const sCHUserVideoFail             = @"vfail";
static NSString *const sCHUserAudioFail             = @"afail";
static NSString *const sCHUserPublishstate          = @"publishstate";

/// Number of large room users
static NSString *const sCHSignal_Notice_BigRoom_Usernum     = @"Notice_BigRoom_Usernum";

static NSString *const sCHStoreTheChannel = @"https://cna-dorado-user-api.cloudhub.vip/channel_users";

/// Gets the configuration information before creating the channel
static NSString *const sCHGetConfig              = @"https://cna-dorado-user-api.cloudhub.vip/config";

/// Get lists of channels
static NSString *const sCHGetChannelList         = @"https://cna-dorado-user-api.cloudhub.vip/channels";

/// User Entry and Exit Record
static NSString *const sCHJoinChannelRecord         = @"https://cna-dorado-user-api.cloudhub.vip/record";

/// Gets a list of users for the specified channel
static NSString *const sCHGetUserList        = @"https://cna-dorado-user-api.cloudhub.vip/channel_users";

/// Query individual Channel details
//static NSString *const sCHGetShowChannelDate     = @"https://cna-dorado-user-api.cloudhub.vip/channels/live";
///// deleteChannel
//static NSString *const sCHDeleteTheChannel       = @"https://cna-dorado-user-api.cloudhub.vip/channels/live";



#endif /* CHAppDefine_h */
