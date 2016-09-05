//
//  UnsplashClient.m
//  Picaso
//
//  Created by Hummer on 16/8/9.
//  Copyright © 2016年 Amazation. All rights reserved.
//

#import "UnsplashClient.h"
#import "UnsplashAuthManager.h"
#import "UnsplashHttpClient.h"

@implementation UnsplashClient

static UnsplashClient *_defaultClient = nil;
+ (instancetype)defaultClient {
    if ([[UnsplashAuthManager sharedAuthManager] getAccessToken]) {
        static dispatch_once_t _onceToken;
        dispatch_once(&_onceToken, ^{
            _defaultClient = [[UnsplashClient alloc] init];
        });
    }
    return _defaultClient;
}

- (BOOL)changeToken {
    _token = [[UnsplashAuthManager sharedAuthManager] getAccessToken];
    return _token != nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _token = [[UnsplashAuthManager sharedAuthManager] getAccessToken];
        _requestClient = [UnsplashHttpClient sharedJsonClient];
    }
    return self;
}

+ (BOOL)hasAuthed {
    return [UnsplashClient defaultClient].token != nil;
}

- (BOOL)unauthorizeClient {
    [[UnsplashAuthManager sharedAuthManager] clearAccessToken];
    return ![self changeToken];
}

@end
