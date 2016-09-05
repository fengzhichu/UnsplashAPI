//
//  UnsplashPhotoStats.h
//  Picaso
//
//  Created by Hummer on 16/8/18.
//  Copyright © 2016年 Amazation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnsplashPhotoStats : NSObject
@property (nonatomic, assign) NSUInteger downloads;
@property (nonatomic, assign) NSUInteger likes;
@property (nonatomic, assign) NSUInteger views;
@property (nonatomic, strong) NSDictionary *links;
@end
