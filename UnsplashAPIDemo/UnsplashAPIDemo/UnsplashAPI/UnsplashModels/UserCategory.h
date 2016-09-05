//
//  UserCategory.h
//  Picaso
//
//  Created by Hummer on 16/7/30.
//  Copyright © 2016年 Amazation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCategory : NSObject <NSCoding, NSCopying>
@property (nonatomic, assign) NSUInteger categoryId; //id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSUInteger photoCount; //photo_count;
@property (nonatomic, strong) NSDictionary *links;
@end
