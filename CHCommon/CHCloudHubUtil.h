//
//  CHCloudHubUtil.h
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHCloudHubUtil : NSObject

/// 检测设备授权
+ (BOOL)checkAuthorizationStatus:(AVMediaType)mediaType;

/// Get device language
+ (NSString *)getCurrentLanguage;

+ (BOOL)isDomain:(NSString *)host;

/// Check data type
+ (BOOL)checkDataClass:(id)data;
/// Convert data to dictionary NSDictionary
+ (nullable NSDictionary *)convertWithData:(nullable id)data;


/// File extension check, whether it is a media file
+ (BOOL)checkIsMedia:(NSString *)filetype;
/// File extension check, whether it is a video file
+ (BOOL)checkIsVideo:(NSString *)filetype;
/// File extension check, whether it is an audio file
+ (BOOL)checkIsAudio:(NSString *)filetype;

/// Create UUID
+ (NSString *)createUUID;

/// Change URL host
+ (NSString *)changeUrl:(NSURL *)url withProtocol:(nullable NSString *)protocol host:(NSString *)host;

/// Get keywindow of different versions of iOS
+ (UIWindow *)getKeyWindow;

@end

NS_ASSUME_NONNULL_END
