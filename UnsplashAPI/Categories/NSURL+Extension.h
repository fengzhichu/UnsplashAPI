//
//  NSURL+Extension.h
//  Picaso
//
//  Created by Hummer on 16/8/5.
//  Copyright © 2016年 Amazation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Extension)
@property (nonatomic, strong, readonly) NSString *fullPath;
@property (nonatomic, strong, readonly) NSDictionary *queryPairs;
@end
