//
//  UnsplashStats.m
//  Picaso
//
//  Created by Hummer on 16/8/19.
//  Copyright © 2016年 Amazation. All rights reserved.
//

#import "UnsplashStats.h"

@implementation UnsplashStats
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"photoDownloads" : @"photo_downloads",
             @"totalPhotos" : @"total_photos",
             @"batchDownloads" : @"batch_downloads",
             };
}
ModelSynthCoderAndHash
@end
