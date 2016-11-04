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
    
    NSArray *downloadArray = @[@"https://codeload.github.com/HeavenYoung/NetworkUtils/zip/master",@"https://codeload.github.com/HeavenYoung/BrightnessView/zip/master",@"https://codeload.github.com/onevcat/VVDocumenter-Xcode/zip/master", @"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.2.0.dmg"];
    

    for (NSString *downloadUrl in downloadArray) {
        
        DownloadUtil *download = [DownloadUtil shareUtil];
        [download downloadWithUrl:downloadUrl
                         filePath:DownloadPath()
         
                  downloadSuccess:^(NSURLResponse *response, NSURL *filePath) {
                      NSLog(@"%@------------下载完成",downloadUrl);
                  }
                  downloadFailure:^(NSURL *filePath, NSError *error) {
                      
                  }
                 downloadProgress:^(NSProgress *progress) {
                     NSLog(@"%@", progress);
                 }
         ];

        
    }
    
//    DownloadUtil *download = [DownloadUtil shareUtil];
//    [download downloadWithUrl:@"https://codeload.github.com/HeavenYoung/NetworkUtils/zip/master"
//              filePath:DownloadPath()
//     
//              downloadSuccess:^(NSURLResponse *response, NSURL *filePath) {
//              
//              }
//              downloadFailure:^(NSURL *filePath, NSError *error) {
//        
//              }
//              downloadProgress:^(NSProgress *progress) {
//                 NSLog(@"%@", progress);
//              }
//     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
