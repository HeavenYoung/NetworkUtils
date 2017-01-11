//
//  ViewController.m
//  NetworkUtils
//
//  Created by Heaven on 16/9/21.
//  Copyright © 2016年 Heaven. All rights reserved.
//

#import "ViewController.h"
#import "DownloadUtil.h"

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"%@", NSHomeDirectory());
    
    NSArray *downloadArray = @[@"https://codeload.github.com/HeavenYoung/NetworkUtils/zip/master",@"https://codeload.github.com/HeavenYoung/BrightnessView/zip/master",@"https://codeload.github.com/onevcat/VVDocumenter-Xcode/zip/master", @"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.2.0.dmg"];

//    NSArray *downloadArray = @[@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.2.0.dmg"];

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
                     NSLog(@"--------%@", progress);

                 }
                   withIdentifier:downloadUrl];
    }
    
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(getInternetface) userInfo:nil repeats:YES];
//    
//    [timer fireDate];
}

- (void)getInternetface {
    
    long long hehe = [self getInterfaceBytes];
    
    
    
    NSLog(@"实时流量------:%lld",hehe);
    
}



/*获取网络流量信息*/

- (long long) getInterfaceBytes {
    
    struct ifaddrs *ifa_list = 0, *ifa;
    
    if (getifaddrs(&ifa_list) == -1) {
        
        return 0;
        
    }
    uint32_t iBytes = 0;
    
    uint32_t oBytes = 0;
    
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        
        if (AF_LINK != ifa->ifa_addr->sa_family)
            
            continue;
        
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            
            continue;
        
        if (ifa->ifa_data == 0)
            
            continue;
        
        /* Not a loopback device. */
        
        if (strncmp(ifa->ifa_name, "lo", 2)) {
            
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            
            iBytes += if_data->ifi_ibytes;
            
            oBytes += if_data->ifi_obytes;
            
        }
        
    }
    
    freeifaddrs(ifa_list);
    
    NSLog(@"\n[getInterfaceBytes-Total]%d,%d",iBytes,oBytes);
    
    return iBytes + oBytes;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
