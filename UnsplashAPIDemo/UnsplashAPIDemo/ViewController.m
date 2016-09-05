//
//  ViewController.m
//  UnsplashAPIDemo
//
//  Created by Jouen on 16/9/5.
//  Copyright © 2016年 Hummer. All rights reserved.
//

#import "ViewController.h"
#import "UnsplashAuthManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)authorize:(id)sender {
    [[UnsplashAuthManager sharedAuthManager] authorizeFromController:self completeHandler:^(UnsplashAccessToken *token, NSError *error) {
        NSLog(@"%@", token.accessToken);
    }];
}

@end
