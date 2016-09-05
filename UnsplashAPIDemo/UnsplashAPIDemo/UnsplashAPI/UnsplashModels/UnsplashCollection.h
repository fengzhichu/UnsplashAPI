//
//  UnsplashCollection.h
//  Picaso
//
//  Created by Hummer on 16/7/30.
//  Copyright © 2016年 Amazation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UnsplashPhoto, UnsplashUser;
@interface UnsplashCollection : NSObject <NSCoding, NSCopying>
@property (nonatomic, assign) NSUInteger collectionId; //id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *collectionDescription;
@property (nonatomic, copy) NSString *publishedAt; //published_at;
@property (nonatomic, assign) BOOL curated;
@property (nonatomic, assign) NSUInteger totalPhotos; // total_photos
@property (nonatomic, assign) BOOL isPrivate; // private
@property (nonatomic, copy) NSString *shareKey; // share_key
@property (nonatomic, strong) UnsplashPhoto *coverPhoto; //cover_photo;
@property (nonatomic, strong) UnsplashUser *user;
@property (nonatomic, strong) NSDictionary *links;
@end










