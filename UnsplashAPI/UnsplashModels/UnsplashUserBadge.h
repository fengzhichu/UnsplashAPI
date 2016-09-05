//
//  UnsplashUserBadge.h
//  Picaso
//
//  Created by Hummer on 16/7/30.
//  Copyright © 2016年 Amazation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnsplashUserBadge : NSObject <NSCoding, NSCopying>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL primary;
@property (nonatomic, copy) NSString *slug;
@property (nonatomic, copy) NSString *link;
@end
