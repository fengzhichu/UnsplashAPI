//
//  UnsplashModels.h
//  Picaso
//
//  Created by Hummer on 16/8/1.
//  Copyright © 2016年 Amazation. All rights reserved.
//

#ifndef UnsplashModels_h
#define UnsplashModels_h

#import "UserCategory.h" // deprecated
#import "UnsplashUserBadge.h"
#import "UnsplashUser.h"
#import "UnsplashPhoto.h"
#import "UnsplashPhotoStats.h"
#import "UnsplashPhotoExif.h"
#import "UnsplashPhotoLocation.h"
#import "UnsplashCollection.h"
#import "UnsplashStats.h"

// KEY for photo url
static NSString * const PHOTO_QUALITY_RAW = @"raw";
static NSString * const PHOTO_QUALITY_FULL = @"full";
static NSString * const PHOTO_QUALITY_REGULAR = @"regular";
static NSString * const PHOTO_QUALITY_SMALL = @"small";
static NSString * const PHOTO_QUALITY_THUMB = @"thumb";
static NSString * const PHOTO_QUALITY_CUSTOM = @"custom";

// KEY for profile image url 
static NSString * const PROFILE_IMAGE_SMALL = @"small";
static NSString * const PROFILE_IMAGE_MEDIUM = @"medium";
static NSString * const PROFILE_IMAGE_LARGE = @"large";
static NSString * const PROFILE_IMAGE_CUSTOM = @"custom";

#endif /* UnsplashModels_h */
