//
//  UnsplashStats.h
//  Picaso
//
//  Created by Hummer on 16/8/19.
//  Copyright © 2016年 Amazation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnsplashStats : NSObject
@property (nonatomic, assign) NSUInteger photoDownloads; // photo_downloads;
@property (nonatomic, assign) NSUInteger totalPhotos; // total_photos;
@property (nonatomic, assign) NSUInteger batchDownloads; // batch_downloads;
@end
