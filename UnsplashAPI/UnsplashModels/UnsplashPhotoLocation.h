//
//  UnsplashPhotoLocation.h
//  Picaso
//
//  Created by Hummer on 16/8/18.
//  Copyright © 2016年 Amazation. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct UnsplashPhotoPosition {
    CGFloat longitude;
    CGFloat latitude;
} UnsplashPhotoPosition;

@interface UnsplashPhotoLocation : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *confidential;
@property (nonatomic, assign) UnsplashPhotoPosition position;
@end


