//
//  CHRoomUser.h
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHRoomUser : NSObject

/// CloudHubRtcEngineKit
@property (nonatomic, weak) CloudHubRtcEngineKit *cloudHubRtcEngineKit;

/// User Id
@property (nonatomic, strong) NSString *peerID;

#pragma mark - 用户属性

/// User property
@property (nonatomic, strong) NSMutableDictionary *properties;

/// User nickname
@property (nonatomic, weak) NSString *nickName;

/// User role
@property (nonatomic, assign) CHUserRoleType role;

/// Microphone device failure
@property (nonatomic, assign) CHDeviceFaultType afail;

/// Volume
@property (nonatomic, assign) NSInteger volume;

/// Turn off the audio
@property (nonatomic, assign) BOOL muteAudio;

/// Turn off the video
@property (nonatomic, assign) BOOL muteVideo;

/// Post status
@property (nonatomic, assign) CHPublishState publishState;

- (instancetype)init NS_UNAVAILABLE;

/// Initialize user
/// @param peerID User ID
- (instancetype)initWithPeerId:(NSString *)peerID;


/// Initialize user
/// @param peerID  User ID
/// @param properties User properties
- (instancetype)initWithPeerId:(NSString *)peerID properties:(NSDictionary *)properties;

/// Update user properties
/// @param properties user properties
- (void)updateWithProperties:(NSDictionary *)properties;

/// Modify microphone audio device fault and send property change
/// @param afail Audio device failure
- (void)sendToChangeAfail:(CHDeviceFaultType)afail;

- (void)sendToChangePublishstate:(CHPublishState)publishstate;

/// Get video device fault
/// @param sourceId Source Id
/// @return CHDeviceFaultType
- (CHDeviceFaultType)getVideoVfailWithSourceId:(NSString *)sourceId;

/// Modify the video device failure and send the property change
/// @param vfail Video device failure
/// @param sourceId Source Id
- (void)sendToChangeVideoVfail:(CHDeviceFaultType)vfail withSourceId:(NSString *)sourceId;

@end

NS_ASSUME_NONNULL_END
