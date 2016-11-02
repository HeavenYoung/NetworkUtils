//
//  ViewController.m
//  NetworkUtils
//
//  Created by Heaven on 16/9/21.
//  Copyright © 2016年 Heaven. All rights reserved.
//

#import "ViewController.h"
#import "DownloadUtil.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"%@", NSHomeDirectory());
    
    DownloadUtil *download = [DownloadUtil shareUtil];
    [download downloadWithUrl:@"https://codeload.github.com/HeavenYoung/NetworkUtils/zip/master"
              filePath:DownloadPath()
     
              downloadSuccess:^(NSURLResponse *response, NSURL *filePath) {
              
              }
              downloadFailure:^(NSURL *filePath, NSError *error) {
        
              }
              downloadProgress:^(NSProgress *progress) {
                 NSLog(@"%@", progress);
              }
     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
