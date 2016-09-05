//
//  UnsplashPhoto.m
//  Picaso
//
//  Created by Hummer on 16/7/30.
//  Copyright © 2016年 Amazation. All rights reserved.
//

#import "UnsplashPhoto.h"

@implementation UnsplashPhoto
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"photoId" : @"id",
             @"createdAt" : @"created_at",
             @"likedByUser" : @"liked_by_user",
             @"userCollection" : @"current_user_collections",
             @"userCategory" : @"categories",
             @"photoUrls" : @"urls",
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"userCategory" : @"UserCategory",
             @"userCollection" : @"UnsplashCollection"};
}
ModelSynthCoderAndHash
@end
