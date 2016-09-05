//
//  NSURL+Extension.m
//  Picaso
//
//  Created by Hummer on 16/8/5.
//  Copyright © 2016年 Amazation. All rights reserved.
//

#import "NSURL+Extension.h"

@implementation NSURL (Extension)
@dynamic queryPairs;
@dynamic fullPath;
- (NSString *)fullPath {
    return [NSString stringWithFormat:@"%@://%@%@", self.scheme, self.host, self.path];
}
- (NSDictionary *)queryPairs {
    NSMutableDictionary *results = [NSMutableDictionary dictionary];
    NSArray *pairs = [self.query componentsSeparatedByString:@"&"];
    for (NSString *pair in pairs) {
        NSArray *keyValue = [pair componentsSeparatedByString:@"="];
        [results setObject:keyValue[1] forKey:keyValue[0]];
    }
    return results;
}
@end
