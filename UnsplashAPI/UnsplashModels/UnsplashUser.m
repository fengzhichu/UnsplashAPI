//
//  UnsplashUser.m
//  Picaso
//
//  Created by Hummer on 16/7/30.
//  Copyright © 2016年 Amazation. All rights reserved.
//

#import "UnsplashUser.h"

@implementation UnsplashUser
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userID" : @"id",
             @"userUID" : @"uid",
             @"userName" : @"username",
             @"firstName" : @"first_name",
             @"lastName" : @"last_name",
             @"portfolioUrl" : @"portfolio_url",
             @"totalLikes" : @"total_likes",
             @"totalPhotos" : @"total_photos",
             @"totalCollections" : @"total_collections",
             @"profileImage" : @"profile_image",
             @"uploadsRemaining" : @"uploads_remaining",
             @"instagramUsername" : @"instagram_username",
            };
}

//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    return @{@"links" : @"NSString",
//             @"profileImage" : @"NSString"};
//}
ModelSynthCoderAndHash
@end
