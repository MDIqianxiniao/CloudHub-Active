//
//  CHNetworkRequest.m
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/29.
//

#import "CHNetworkRequest.h"


#define CHTimeoutInterval 10
 

@implementation CHNetworkRequest


/// get
+ (void)getWithURLString:(NSString *)URLString params:(NSDictionary *)params progress:(void(^)(NSProgress *downloadProgress))progress success:(void(^)(NSDictionary * dictionary))success  failure:(void(^)(NSError *error))failure
{
    // 创建AFN
    AFHTTPSessionManager *manager = [self manager];
    
    [manager GET:URLString parameters:params headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        // 进度回调
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        success(dict);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 失败回调
        if (error) {
            failure(error);
        }
    }];
}

/// post
+ (void)postWithURLString:(NSString *)URLString params:(NSDictionary *)params progress:(void(^)(NSProgress *uploadProgress))progress success:(void(^)(NSDictionary * dictionary))success  failure:(void(^)(NSError *error))failure
{
    // 创建AFN
    AFHTTPSessionManager *manager = [self manager];
    // 发送POST请求
    [manager POST:URLString parameters:params headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        // 进度回调
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        // 成功回调
        if (success) {
            success(dict);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 失败回调
        if (error) {
            failure(error);
        }
    }];
}

/**
 *  创建session对象
 *
 *  @return <#return value description#>
 */
+ (AFHTTPSessionManager *)manager
{
    // 创建AFN
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 请求参数为json数据
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 返回参数为map参数
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 设置请求时长
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = CHTimeoutInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];

    return manager;
}


@end
