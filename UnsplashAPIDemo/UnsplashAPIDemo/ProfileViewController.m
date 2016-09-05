//
//  ProfileViewController.m
//  UnsplashAPI
//
//  Created by Jouen on 16/9/5.
//  Copyright © 2016年 Hummer. All rights reserved.
//

#import "ProfileViewController.h"
#import "UnsplashApiManager.h"
#import "UnsplashUser.h"
#import "UIImageView+WebCache.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *proImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *likes;
@property (weak, nonatomic) IBOutlet UILabel *photos;
@property (weak, nonatomic) IBOutlet UILabel *collections;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UnsplashApiManager getUserProfileWithCompleteHandler:^(id  _Nullable data, NSError * _Nullable error) {
        UnsplashUser *user = data;
        [self.proImage sd_setImageWithURL:[NSURL URLWithString:user.profileImage[@"medium"]]];
        self.userName.text = user.userName;
        self.name.text = user.name;
        self.likes.text = [NSString stringWithFormat:@"%@ %d", self.likes.text, user.totalLikes];
        self.photos.text = [NSString stringWithFormat:@"%@ %d", self.photos.text, user.totalPhotos];
        self.collections.text = [NSString stringWithFormat:@"%@ %d", self.collections.text, user.totalCollections];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
