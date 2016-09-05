//
//  UnsplashUser.h
//  Picaso
//
//  Created by Hummer on 16/7/30.
//  Copyright © 2016年 Amazation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UnsplashBadge;
@interface UnsplashUser : NSObject <NSCoding, NSCopying>
@property (nonatomic, copy) NSString *userID; // id;
@property (nonatomic, copy) NSString *userUID; // uid;
@property (nonatomic, copy) NSString *userName; // username;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *firstName; // first_name;
@property (nonatomic, copy) NSString *lastName; // last_name;
@property (nonatomic, copy) NSString *portfolioUrl; // portfolio_url;
@property (nonatomic, copy) NSString *bio;
@property (nonatomic, strong) UnsplashBadge *badge;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, assign) NSUInteger totalLikes; // total_likes
@property (nonatomic, assign) NSUInteger totalPhotos;// total_photos
@property (nonatomic, assign) NSUInteger totalCollections; // total_collections
@property (nonatomic, assign) NSUInteger downloads;
@property (nonatomic, strong) NSDictionary *profileImage; // profile_image; small, medium, large, custom;
@property (nonatomic, strong) NSDictionary *links; // userSelf, html, photos, likes, download;
@property (nonatomic, assign) NSUInteger uploadsRemaining; // uploads_remaining
@property (nonatomic, copy) NSString *instagramUsername;  // instagram_username
@property (nonatomic, copy) NSString *email;
@end
