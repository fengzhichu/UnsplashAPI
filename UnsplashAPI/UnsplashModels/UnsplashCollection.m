//
//  UnsplashCollection.m
//  Picaso
//
//  Created by Hummer on 16/7/30.
//  Copyright © 2016年 Amazation. All rights reserved.
//

#import "UnsplashCollection.h"

@implementation UnsplashCollection
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"collectionId" : @"id",
             @"publishedAt" : @"published_at",
             @"totalPhotos" : @"total_photos",
             @"isPrivate" : @"private",
             @"shareKey" : @"share_key",
             @"collectionDescription" : @"description",
             @"coverPhoto" : @"cover_photo",
             };
}
//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    return @{@"links" : @"NSString"};
//}
ModelSynthCoderAndHash
@end


