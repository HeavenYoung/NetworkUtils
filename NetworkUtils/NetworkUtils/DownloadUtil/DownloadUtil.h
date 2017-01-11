//
//  DownloadUtil.h
//  NetworkUtils
//
//  Created by Heaven on 2016/11/1.
//  Copyright © 2016年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Folder [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0]
#define PathNAME @"Download"
#define DownloadPath() [Folder stringByAppendingPathComponent:PathNAME]

typedef void(^downloadSuccessBlock)(NSURLResponse *response, NSURL *filePath);
typedef void(^downloadFailureBlock)(NSURL *filePath, NSError *error);
typedef void(^downloadProgressBlock)(NSProgress *progress);

@interface DownloadUtil : NSObject

/**
 开启下载任务
 
 @param downloadUrl downloadUrl
 @param filePath filePath
 @param success success
 @param failure failure
 @param progress progress
 */
- (void)downloadWithUrl:(NSString *)downloadUrl filePath:(NSString *)filePath downloadSuccess:(downloadSuccessBlock)success downloadFailure:(downloadFailureBlock)failure downloadProgress:(downloadProgressBlock)progress withIdentifier:(NSString *)Identifier;

/** 单例方法 */
+ (instancetype)shareUtil;
/** 取消单个下载 */
- (void)cancelDownloadWithUrl:(NSString *)downloadUrl;
/** 全部取消 */
- (void)cancelAllDownload;
/** 暂停单个下载 */
- (void)pauseDownloadWithUrl:(NSString *)downloadUrl;
/** 暂停全部下载 */
- (void)pauseAllDownload;
/** 重新开启单个下载 */
- (void)resumeDownloadWithUrl:(NSString *)downloadUrl;
/** 重新开启全部下载 */
- (void)resumeAllDownload;
@end
