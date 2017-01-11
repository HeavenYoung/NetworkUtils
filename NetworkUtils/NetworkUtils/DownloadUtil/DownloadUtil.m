//
//  DownloadUtil.m
//  NetworkUtils
//
//  Created by Heaven on 2016/11/1.
//  Copyright © 2016年 Heaven. All rights reserved.
//

#import "DownloadUtil.h"
#import "AFNetworking.h"

@interface DownloadUtil ()
/** 下载URL数组 */
@property (nonatomic, strong) NSMutableArray *downloadUrlArray;
/** 下载任务数组 */
@property (nonatomic, strong) NSMutableArray *downloadTaskArray;
@end

@implementation DownloadUtil

+ (instancetype)shareUtil {

    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[DownloadUtil alloc] init];
    });
    return instance;
}

- (instancetype)init {

    self = [super init];
    if (self) {
        
        // 创建下载文件夹
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:DownloadPath() withIntermediateDirectories:YES attributes:nil error:nil];

        _downloadUrlArray = [[NSMutableArray alloc] init];
        _downloadTaskArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)downloadWithUrl:(NSString *)downloadUrl filePath:(NSString *)filePath downloadSuccess:(downloadSuccessBlock)success downloadFailure:(downloadFailureBlock)failure downloadProgress:(downloadProgressBlock)progress withIdentifier:(NSString *)identifier {

    // 1. 查重，防止开启多个相同文件的下载任务
    if ([_downloadUrlArray containsObject:downloadUrl]) {
        NSLog(@"此任务已经存在任务列表");
        return;
    }

    // 2. URL处理，添加到下载URL数组
    NSURL *URL = [NSURL URLWithString:downloadUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [_downloadUrlArray addObject:downloadUrl];
    
    // 3. 开启下载任务，添加到下载任务数组
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

    if (identifier != nil) {
    
        configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier];

    }

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        progress(downloadProgress);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *fullPath = [NSString stringWithFormat:@"%@/%@", filePath, [response suggestedFilename]];

        return [NSURL fileURLWithPath:fullPath];
            
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error) {
            
            // 错误的回调
            failure(filePath, error);
        } else {
            
            // 成功的回调
            success(response, filePath);
        }

        [self removeDownloadedDataWithUrl:downloadUrl];
//        [manager.session invalidateAndCancel];
    }];

    [downloadTask resume];
    
    [_downloadTaskArray addObject:downloadTask];
    
}

/** 内部方法，清空已下载数据的内存 */
- (void)removeDownloadedDataWithUrl:(NSString *)downloadUrl {

    if (downloadUrl == nil || _downloadUrlArray.count || _downloadTaskArray.count == 0) {
        return;
    }
    
    for (int i = 0; _downloadUrlArray.count; ++i) {
        
        NSString *tagetDownloadUrl = [_downloadUrlArray objectAtIndex:i];
        if ([tagetDownloadUrl isEqualToString:downloadUrl]) {
            
            [_downloadUrlArray removeObjectAtIndex:i];
            [_downloadUrlArray removeObjectAtIndex:i];
            
            break;
        }
    }

}

- (void)cancelDownloadWithUrl:(NSString *)downloadUrl {
    
    // 容错，防止downloadUrl为空
    if (downloadUrl == nil || _downloadUrlArray.count || _downloadTaskArray.count == 0) {
        return;
    }
}

- (void)cancelAllDownload {

    if (_downloadUrlArray.count == 0 || _downloadTaskArray.count == 0) {
        return;
    }
    
    for (int i = 0; _downloadUrlArray.count; ++i) {
        NSURLSessionDownloadTask *downloadTask = [_downloadTaskArray objectAtIndex:i];
        
        if (downloadTask.state == NSURLSessionTaskStateRunning || downloadTask.state == NSURLSessionTaskStateSuspended) {
            [downloadTask cancel];
        }
    }

}

- (void)pauseDownloadWithUrl:(NSString *)downloadUrl {
    // 容错，防止downloadUrl为空
    if (downloadUrl == nil || _downloadUrlArray.count || _downloadTaskArray.count == 0) {
        return;
    }
    
    for (int i = 0; _downloadUrlArray.count; ++i) {
        
        NSString *tagetDownloadUrl = [_downloadUrlArray objectAtIndex:i];
        if ([tagetDownloadUrl isEqualToString:downloadUrl]) {
            NSURLSessionDownloadTask *downloadTask = [_downloadTaskArray objectAtIndex:i];
            if (downloadTask.state == NSURLSessionTaskStateRunning) {
                [downloadTask suspend];
            }
            break;
        }
    }

}

- (void)pauseAllDownload {

    if (_downloadUrlArray.count == 0 || _downloadTaskArray.count == 0) {
        return;
    }
    
    for (int i = 0; _downloadUrlArray.count; ++i) {
        NSURLSessionDownloadTask *downloadTask = [_downloadTaskArray objectAtIndex:i];
        
        if (downloadTask.state == NSURLSessionTaskStateRunning) {
            [downloadTask suspend];
        }
    }

}

- (void)resumeDownloadWithUrl:(NSString *)downloadUrl {
    // 容错，防止downloadUrl为空
    if (downloadUrl == nil || _downloadUrlArray.count || _downloadTaskArray.count == 0) {
        return;
    }

    for (int i = 0; _downloadUrlArray.count; ++i) {
        
        NSString *tagetDownloadUrl = [_downloadUrlArray objectAtIndex:i];
        if ([tagetDownloadUrl isEqualToString:downloadUrl]) {
            NSURLSessionDownloadTask *downloadTask = [_downloadTaskArray objectAtIndex:i];
            if (downloadTask.state == NSURLSessionTaskStateSuspended) {
                [downloadTask resume];
            }
            break;
        }
    }

}

- (void)resumeAllDownload {

    if (_downloadUrlArray.count == 0) {
        return;
    }
    
    for (int i = 0; _downloadUrlArray.count; ++i) {
        NSURLSessionDownloadTask *downloadTask = [_downloadTaskArray objectAtIndex:i];
        if (downloadTask.state == NSURLSessionTaskStateSuspended) {
            [downloadTask resume];
        }
    }

}

@end
