//
//  CHAppEnum.h
//  CloudHub
//
//  Created by 马迪 on 2021/1/27.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#ifndef CHAppEnum_h
#define CHAppEnum_h

#pragma mark - Room enumeration

/// CHUserRoleType User roles
typedef NS_ENUM(NSInteger, CHUserRoleType)
{
    /// Anchor
    CHUserType_Anchor = 0,
    /// Audience
    CHUserType_Audience = 1,
};

/// Room type
typedef NS_ENUM(NSUInteger, CHRoomUseType)
{
    /// Class
    CHRoomUseTypeSmallClass = 3,
    /// Live
    CHRoomUseTypeLiveRoom = 4
};


#pragma mark - About media
/// CHDeviceFaultType Type of equipment failure
typedef NS_ENUM(NSUInteger, CHDeviceFaultType)
{
    /// None
    CHDeviceFaultNone           = 0,
    /// Unknown
    CHDeviceFaultUnknown        = 1,
    /// Not Found
    CHDeviceFaultNotFind        = 2,
    /// Forbidden
    CHDeviceFaultNotAuth        = 3,
    /// Occupied
    CHDeviceFaultOccupied       = 4,
    
    CHDeviceFaultConError       = 5,

    CHDeviceFaultConFalse       = 6,

    CHDeviceFaultStreamOverTime = 7,

    CHDeviceFaultStreamEmpty    = 8,

    CHDeviceFaultSDPFail        = 9
};

/// Media stream publishing status
typedef NS_ENUM(NSUInteger, CHMediaState)
{
    /// Stop
    CHMediaState_Stop = 0,
    /// Play
    CHMediaState_Play = 1,
    /// Pause
    CHMediaState_Pause
};


#pragma mark - Message

typedef NS_ENUM(NSInteger, CHChatMessageType)
{
    /// Chat message
    CHChatMessageType_Text,
    /// Prompt information
    CHChatMessageType_Tips
};


#endif /* CHAppEnum_h */
