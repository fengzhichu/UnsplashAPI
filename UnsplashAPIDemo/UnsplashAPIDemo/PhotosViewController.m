//
//  PhotosViewController.m
//  UnsplashAPI
//
//  Created by Jouen on 16/9/5.
//  Copyright © 2016年 Hummer. All rights reserved.
//

#import "PhotosViewController.h"
#import "CustomTableViewCell.h"
#import "UnsplashApiManager.h"
#import "UnsplashPhoto.h"

@interface PhotosViewController ()
@property (nonatomic, strong) NSArray *photos;
@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UnsplashApiManager listCuratedPhotosWithPage:1 perPage:20 orderBy:UnsplashPhotosOrderByLatest completeHandler:^(id  _Nullable data, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            self.photos = [NSArray arrayWithArray:data];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell" forIndexPath:indexPath];
    cell.photo = self.photos[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UnsplashPhoto *photo = self.photos[indexPath.row];
    CGFloat height = (CGFloat)photo.height / photo.width * [UIScreen mainScreen].bounds.size.width;
    return height + 40;
}

@end
