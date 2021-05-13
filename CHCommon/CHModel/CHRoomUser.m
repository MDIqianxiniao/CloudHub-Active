//
//  CHRoomUser.m
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import "CHRoomUser.h"

@implementation CHRoomUser

- (instancetype)init
{
    @throw [NSException exceptionWithName:NSGenericException reason:@"init not supported, use initWithPeerId: instead." userInfo:nil];
    return nil;
}

- (instancetype)initWithPeerId:(NSString *)peerID
{
    self = [super init];
    if (self)
    {
        self.peerID = peerID;
        [self initProperties];
    }
    
    return self;
}

- (instancetype)initWithPeerId:(NSString *)peerID properties:(NSDictionary*)properties
{
    self = [super init];
    if (self)
    {
        if (![peerID ch_isNotEmpty])
        {
            return nil;
        }

        self.peerID = peerID;
        
        [self initProperties];

        if (![properties ch_isNotEmptyDictionary])
        {
            return self;
        }
        
        [self updateWithProperties:properties];
    }
    
    return self;
}

- (void)initProperties
{
    self.properties = [NSMutableDictionary dictionary];
}

- (NSString *)nickName
{
    return [self.properties ch_stringForKey:sCHUserNickname];
}

- (void)setNickName:(NSString *)nickName
{
    if ([nickName ch_isNotEmpty])
    {
        [self.properties ch_setString:nickName forKey:sCHUserNickname];
    }
}

- (CHUserRoleType)role
{
    return [self.properties ch_intForKey:sCHUserRole withDefault:-2];
}

- (void)setRole:(CHUserRoleType)role
{
    [self.properties ch_setInteger:role forKey:sCHUserRole];
}

- (CHDeviceFaultType)afail
{
    CHDeviceFaultType fail = [self.properties ch_uintForKey:sCHUserAudioFail withDefault:CHDeviceFaultNone];
    
    return fail;
}

- (void)setAfail:(CHDeviceFaultType)afail
{
    [self.properties ch_setUInteger:afail forKey:sCHUserAudioFail];
}

- (CHPublishState)publishState
{
    return [self.properties ch_uintForKey:sCHUserPublishstate];
}

- (NSDictionary *)sourceListDic
{
    return [self.properties ch_dictionaryForKey:sCHUserCameras];
}

- (void)updateWithProperties:(NSDictionary *)properties
{
    if ([properties ch_isNotEmptyDictionary])
    {
        [self.properties addEntriesFromDictionary:properties];
    }
}

- (void)sendToChangeAfail:(CHDeviceFaultType)afail
{
    [self.properties ch_setUInteger:afail forKey:sCHUserAudioFail];

    [self sendToChangeProperty:@(afail) forKey:sCHUserAudioFail tellWhom:CHRoomPubMsgTellAll];
}

- (void)sendToChangePublishstate:(CHPublishState)publishstate
{
    [self.properties ch_setUInteger:publishstate forKey:sCHUserPublishstate];

    [self sendToChangeProperty:@(publishstate) forKey:sCHUserPublishstate tellWhom:CHRoomPubMsgTellAll];
}

- (NSDictionary *)getVideoSourceWithSourceId:(NSString *)sourceId
{
    NSDictionary *source = [self.sourceListDic ch_dictionaryForKey:sourceId];
    
    return source;
}

- (CHDeviceFaultType)getVideoVfailWithSourceId:(NSString *)sourceId
{
    NSDictionary *source = [self getVideoSourceWithSourceId:sourceId];
    CHDeviceFaultType videoVfail = [source ch_uintForKey:sCHUserVideoFail withDefault:CHDeviceFaultNone];
    if (![source ch_isNotEmpty])
    {
        videoVfail = CHDeviceFaultNotFind;
    }
    
    return videoVfail;
}

- (void)sendToChangeVideoVfail:(CHDeviceFaultType)vfail withSourceId:(NSString *)sourceId
{
    NSMutableDictionary *sourceListDic = [NSMutableDictionary dictionaryWithDictionary:self.sourceListDic];
    
    NSMutableDictionary *source = [NSMutableDictionary dictionaryWithDictionary:[sourceListDic ch_dictionaryForKey:sourceId]];
    [source ch_setUInteger:vfail forKey:sCHUserVideoFail];
    [sourceListDic setObject:source forKey:sourceId];
    
    [self sendToChangeProperty:sourceListDic forKey:sCHUserCameras tellWhom:CHRoomPubMsgTellAll];
}

- (void)sendToChangeProperty:(id)property forKey:(NSString *)propertyKey tellWhom:(NSString *)whom
{
    NSDictionary *propertyDic = @{propertyKey : property};
    [self.cloudHubRtcEngineKit setPropertyOfUid:self.peerID tell:whom properties:[propertyDic ch_toJSON]];
}


@end
