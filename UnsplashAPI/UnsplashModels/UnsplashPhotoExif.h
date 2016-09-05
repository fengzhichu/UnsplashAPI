//
//  UnsplashPhotoExif.h
//  Picaso
//
//  Created by Hummer on 16/8/18.
//  Copyright © 2016年 Amazation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnsplashPhotoExif : NSObject
@property (nonatomic, copy) NSString *exposureTime; //exposure_time;
@property (nonatomic, assign) NSUInteger iso;
@property (nonatomic, copy) NSString *model;
@property (nonatomic, copy) NSString *aperture;
@property (nonatomic, copy) NSString *focalLenght; // focal_length;
@property (nonatomic, copy) NSString *make;
@end
