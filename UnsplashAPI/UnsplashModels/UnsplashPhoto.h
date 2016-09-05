//
//  UnsplashPhoto.h
//  Picaso
//
//  Created by Hummer on 16/7/30.
//  Copyright © 2016年 Amazation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UnsplashUser, UnsplashPhotoExif, UnsplashPhotoLocation, UserCategory, UnsplashCollection;
@interface UnsplashPhoto : NSObject <NSCoding, NSCopying>
@property (nonatomic, copy) NSString *photoId; //id;
@property (nonatomic, copy) NSString *createdAt; // created_at;
@property (nonatomic, assign) NSUInteger width;
@property (nonatomic, assign) NSUInteger height;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, assign) NSUInteger likes;
@property (nonatomic, assign) BOOL likedByUser; //liked_by_user;
@property (nonatomic, strong) UnsplashPhotoExif *exif;
@property (nonatomic, strong) UnsplashPhotoLocation *location;
@property (nonatomic, strong) UnsplashUser *user;
@property (nonatomic, strong) NSArray<UnsplashCollection *> *userCollection; //current_user_collections;
@property (nonatomic, strong) NSArray<UserCategory *> *userCategory; //categories;
@property (nonatomic, strong) NSDictionary *photoUrls; //urls; raw, full, regular, small, thumb, custom;
@property (nonatomic, strong) NSDictionary *links; //userSelf, html, photos, likes, download;
@end
