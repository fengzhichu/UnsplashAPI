//
//  CollectionsViewController.m
//  UnsplashAPI
//
//  Created by Jouen on 16/9/5.
//  Copyright © 2016年 Hummer. All rights reserved.
//

#import "CollectionsViewController.h"
#import "CustomTableViewCell.h"
#import "UnsplashApiManager.h"
#import "UnsplashCollection.h"

@interface CollectionsViewController ()
@property (nonatomic, strong) NSArray *collections;
@end

@implementation CollectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UnsplashApiManager listCuratedCollectionsWithPage:1 perPage:20 completeHandler:^(id  _Nullable data, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            self.collections = [NSArray arrayWithArray:data];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.collections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"collectionCell" forIndexPath:indexPath];
    cell.collection = self.collections[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UnsplashCollection *collection = self.collections[indexPath.row];
    CGFloat height = (CGFloat)collection.coverPhoto.height / collection.coverPhoto.width * [UIScreen mainScreen].bounds.size.width;
    return height + 40;
}


@end
