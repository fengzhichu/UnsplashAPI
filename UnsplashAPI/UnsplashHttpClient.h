//
//  UnsplashHttpClient.h
//  Picaso
//
//  Created by Hummer on 16/7/30.
//  Copyright © 2016年 Amazation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^RequestCompleteHandler)(id _Nullable data, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, UnsplashNetworkMethod) {
    Get = 0,
    Post,
    Put,
    Delete
};

typedef NS_ENUM(NSUInteger, InValidContentType) {
    InValidContentTypePhoto,
    InValidContentTypeCollectoin,
    InValidContentTypeCategory,
};

@interface UnsplashHttpClient : AFHTTPSessionManager

+ (instancetype)sharedJsonClient;
+ (instancetype)changeJsonClient;

- (void)requestJsonDataWithPath:(NSString *)path
                     parameters:(NSDictionary *)params
                     methodType:(UnsplashNetworkMethod)method
                completeHandler:(RequestCompleteHandler)handler;

- (void)requestJsonDataWithPath:(NSString *)path
                     parameters:(NSDictionary *)params
                     methodType:(UnsplashNetworkMethod)method
                      showError:(BOOL)show
                completeHandler:(RequestCompleteHandler)handler;

- (void)requestJsonDataWithPath:(NSString *)path
                           file:(NSDictionary *)file
                     parameters:(NSDictionary *)params
                     methodType:(UnsplashNetworkMethod)method
                completeHandler:(RequestCompleteHandler)handler;

- (void)reportInValidContentWithType:(InValidContentType)type
                          parameters:(NSDictionary *)params;

- (void)uploadPhoto:(UIImage *)photo
               path:(NSString *)path
               name:(NSString *)name
           progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
            success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
            failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;
@end

NS_ASSUME_NONNULL_END