//
//  CHNetworkRequest.h
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/29.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"



NS_ASSUME_NONNULL_BEGIN

@interface CHNetworkRequest : NSObject

+ (AFHTTPSessionManager *)manager;

/// get
+ (void)getWithURLString:(NSString *)URLString params:(nullable NSDictionary * )params progress:(nullable void(^)(NSProgress *downloadProgress))progress success:(nullable void(^)(NSDictionary * dictionary))success  failure:(nullable void(^)(NSError *error))failure;

/// post
+ (void)postWithURLString:(NSString *)URLString params:(nullable NSDictionary *)params progress:(nullable void(^)(NSProgress *uploadProgress))progress success:(nullable void(^)(NSDictionary * dictionary))success  failure:(nullable void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
