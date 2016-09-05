//
//  CustomTableViewCell.h
//  UnsplashAPI
//
//  Created by Jouen on 16/9/5.
//  Copyright © 2016年 Hummer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UnsplashPhoto, UnsplashCollection;
@interface CustomTableViewCell : UITableViewCell
@property (nonatomic, strong) UnsplashPhoto *photo;
@property (nonatomic, strong) UnsplashCollection *collection;
@end
