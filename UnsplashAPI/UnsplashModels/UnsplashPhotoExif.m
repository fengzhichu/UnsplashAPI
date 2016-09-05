//
//  UnsplashPhotoExif.m
//  Picaso
//
//  Created by Hummer on 16/8/18.
//  Copyright © 2016年 Amazation. All rights reserved.
//

#import "UnsplashPhotoExif.h"

@implementation UnsplashPhotoExif
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"exposureTime" : @"exposure_time",
             @"focalLenght" : @"focal_length",
             };
}
ModelSynthCoderAndHash
@end
