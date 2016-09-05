//
//  CustomTableViewCell.m
//  UnsplashAPI
//
//  Created by Jouen on 16/9/5.
//  Copyright © 2016年 Hummer. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "UnsplashUser.h"
#import "UnsplashPhoto.h"
#import "UnsplashCollection.h"
#import "UIImageView+WebCache.h"

@interface CustomTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@end

@implementation CustomTableViewCell

- (void)setPhoto:(UnsplashPhoto *)photo {
    _photo = photo;
    _title.text = photo.user.userName;
    [_image sd_setImageWithURL:[NSURL URLWithString:photo.photoUrls[@"small"]]];
}

- (void)setCollection:(UnsplashCollection *)collection {
    _collection = collection;
    _title.text = collection.title;
    [_image sd_setImageWithURL:[NSURL URLWithString:collection.coverPhoto.photoUrls[@"small"]]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
