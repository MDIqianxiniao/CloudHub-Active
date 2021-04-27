//
//  CHVideoView.h
//  CloudHub
//
//  Created by jiang deng on 2021/1/29.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.


#import <UIKit/UIKit.h>
#import "CHRoomUser.h"

@class CHVideoView;

NS_ASSUME_NONNULL_BEGIN

@protocol CHVideoViewDelegate <NSObject>

@optional

/// click callback
- (void)clickViewToControlWithVideoView:(CHVideoView *)videoView;

@end

@interface CHVideoView : UIView

@property (nonatomic, weak) id <CHVideoViewDelegate> delegate;

/// background view, show video state without video
@property (nonatomic, strong, readonly) UIImageView *bgImageView;
/// for show video
@property (nonatomic, strong, readonly) UIView *contentView;

/// video stream id
@property (nonatomic, strong) NSString *streamId;
/// video device id
@property (nonatomic, strong) NSString *sourceId;

/// user model
@property (nullable, nonatomic, strong) CHRoomUser *roomUser;
@property (nonatomic, assign) CHRoomUseType roomType;
/// big video view
@property (nonatomic, assign) BOOL isBigView;

/// refresh view by user properties
- (void)freshWithRoomUserProperty;

@end

NS_ASSUME_NONNULL_END
