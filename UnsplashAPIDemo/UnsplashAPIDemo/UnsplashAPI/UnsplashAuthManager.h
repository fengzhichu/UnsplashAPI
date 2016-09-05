//
//  UnsplashAuthManager.h
//  Picaso
//
//  Created by Hummer on 16/8/2.
//  Copyright © 2016年 Amazation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

static NSString * const kDomain = @"com.unsplash.error";
typedef NS_ENUM(NSUInteger, UnsplashErrorCode) {
    /// The client is not authorized to request an access token using this method.
    UnsplashErrorCodeUnauthorizedClient = 1,
    /// The resource owner or authorization server denied the request.
    UnsplashErrorCodeAccessDenied,
    /// The authorization server does not support obtaining an access token using this method.
    UnsplashErrorCodeUnsupportedResponseType,
    /// The authorization server encountered an unexpected condition that prevented it from
    /// fulfilling the request.
    UnsplashErrorCodeServerError,
    /// The requested scope is invalid, unknown, or malformed.
    UnsplashErrorCodeInvalidScope,
    /// Client authentication failed due to unknown client, no client authentication included,
    /// or unsupported authentication method.
    UnsplashErrorCodeInvalidClient,
    /// The request is missing a required parameter, includes an unsupported parameter value, or
    /// is otherwise malformed.
    UnsplashErrorCodeInvalidRequest,
    /// The provided authorization grant is invalid, expired, revoked, does not match the
    /// redirection URI used in the authorization request, or was issued to another client.
    UnsplashErrorCodeInvalidGrant,
    /// The authorization server is currently unable to handle the request due to a temporary
    /// overloading or maintenance of the server.
    UnsplashErrorCodeTemporarilyUnavailable,
    /// The user canceled the authorization process.
    UnsplashErrorCodeUserCanceledAuth,
    /// Some other error
    UnsplashErrorCodeUnkown
};

///  UnsplashAuthManager
@class UnsplashAccessToken;
@interface UnsplashAuthManager : NSObject
+ (instancetype)sharedAuthManager;
- (void)authorizeFromController:(UIViewController *)controller completeHandler:(void (^)(UnsplashAccessToken *token, NSError *error))handler;
- (UnsplashAccessToken *)getAccessToken;
- (BOOL)clearAccessToken;
@end

///  UnsplashConnectController
@interface UnsplashConnectController : UIViewController
@property (nonatomic, copy) void (^onWillDismiss)(BOOL);
@property (nonatomic, copy) void (^onMatchedURL)(NSURL *);
- (instancetype)initWithStartURL:(NSURL *)startUrl dismissOnMatchURL:(NSURL *)dismissUrl;
@end

///  UnsplashAccessToken
@interface UnsplashAccessToken : NSObject
@property (nonatomic, copy, readonly) NSString *clientId;
@property (nonatomic, copy, readonly) NSString *accessToken;
@property (nonatomic, copy, readonly) NSString *tokenType;
@property (nonatomic, strong, readonly) NSDictionary *scope;
@property (nonatomic, assign, readonly) NSTimeInterval createdAt;
- (instancetype)initWithClientId:(NSString *)clientId authResponse:(NSDictionary *)response;
- (instancetype)initWithClientId:(NSString *)clientId accessToken:(NSString *)token;
@end

///  UnsplashError
@interface UnsplashError : NSObject
+ (NSError *)errorWithCodeString:(NSString *)string description:(NSString *)description;
+ (NSError *)errorWithCode:(UnsplashErrorCode)code description:(NSString *)description;
@end

///  UnsplashKeychain
@interface UnsplashKeychain : NSObject
+ (CFDictionaryRef)queryWithDict:(NSDictionary *)query;
+ (BOOL)setKey:(NSString *)key inString:(NSString *)string;
+ (BOOL)setKey:(NSString *)key inData:(NSData *)data;
+ (NSData *)getDataWithKey:(NSString *)key;
+ (NSString *)getKey:(NSString *)key;
+ (BOOL)deleteKey:(NSString *)key;
+ (BOOL)clear;
@end