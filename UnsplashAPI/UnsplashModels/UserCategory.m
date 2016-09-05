//
//  UserCategory.m
//  Picaso
//
//  Created by Hummer on 16/7/30.
//  Copyright © 2016年 Amazation. All rights reserved.
//

#import "UserCategory.h"

@implementation UserCategory
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"categoryId" : @"id",
             @"photoCount" : @"photo_count",
            };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"links" : @"NSString"};
}
ModelSynthCoderAndHash
@end
