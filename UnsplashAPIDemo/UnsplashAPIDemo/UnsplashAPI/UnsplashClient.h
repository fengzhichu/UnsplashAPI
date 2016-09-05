//
//  UnsplashClient.h
//  Picaso
//
//  Created by Hummer on 16/8/9.
//  Copyright © 2016年 Amazation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UnsplashHttpClient, UnsplashAccessToken;
@interface UnsplashClient : NSObject
@property (nonatomic, strong) UnsplashHttpClient *requestClient;
@property (nonatomic, strong) UnsplashAccessToken *token;
+ (instancetype)defaultClient;
+ (BOOL)hasAuthed;
- (BOOL)changeToken;
- (BOOL)unauthorizeClient;
@end
