//
//  CHChatMessageModel.h
//  CloudHub
//
//

#import <Foundation/Foundation.h>
#import "CHRoomUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface CHChatMessageModel : NSObject

/// Sender
@property (nullable, nonatomic, strong) CHRoomUser *sendUser;

/// Sender Id
@property (nullable, nonatomic, strong) NSString *senderPeerId;

/// Sender nickname
@property (nullable, nonatomic, strong) NSString *senderNickName;

/// Sender role
@property (nullable, nonatomic, strong) NSString *senderRole;

/// Receiver
@property (nullable, nonatomic, strong) CHRoomUser *receiveUser;

/// Message time
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, strong) NSString *timeStr;

/// Message content
@property (nullable, nonatomic, strong) NSString *message;

/// Message type
@property (nonatomic, assign) CHChatMessageType chatMessageType;

@property (nonatomic, assign) CGFloat messageHeight;

@property (nonatomic, assign) CGSize messageSize;

@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
