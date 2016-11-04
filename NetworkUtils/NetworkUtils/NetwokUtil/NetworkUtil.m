//
//  NetworkUtil.m
//  NetworkUtils
//
//  Created by Heaven on 16/9/21.
//  Copyright © 2016年 Heaven. All rights reserved.
//

#import "NetworkUtil.h"
#import "AFNetworking.h"
#import "BaseResponse.h"

@interface NetworkUtil ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation NetworkUtil

+ (instancetype)sharedNetworkUtil {
    
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        [configuration setHTTPMaximumConnectionsPerHost:kMaxConnection];
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = NETWORK_TIMEOUTINTERVAL;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                             @"text/json",
                                                             @"text/javascript",
                                                             @"text/plain",
                                                             @"text/html", nil];
        
        [(AFJSONResponseSerializer *)manager.responseSerializer setRemovesKeysWithNullValues:YES];
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        }];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        NetworkUtil *tool = [[self alloc] init];
        tool.manager = manager;
        instance = tool;
    });
    
    return instance;
}

#pragma mark -- NetworkTool class action
- (void)sendRequest:(BaseRequest *)request {
    
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if (AFNetworkReachabilityStatusNotReachable == status) {
        [self paserErrorWithCode:NETWORK_ERROR_NOTREACHABLE request:request];
        return;
    }
    
    // append URL
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:request.hostURLString];
    NSString *appendUrlString = [[NSString alloc] init];
    
    [self.manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    self.manager.requestSerializer.timeoutInterval = request.timeoutInterval;;
    [self.manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    if (request.URLString) {
        appendUrlString = request.URLString;
    } else {
        appendUrlString = @"";
    }
    [urlString appendString:appendUrlString];
    
    [request parametersWithProperties];
    
    NSURLSessionDataTask *dataTask;
    if ([request.httpMethod isEqualToString:@"GET"]) {
        dataTask = [self.manager GET:urlString parameters:request.parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self paserResponse:responseObject request:request];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self paserErrorWithCode:error.code request:request];
        }];
        
    } else if ([request.httpMethod isEqualToString:@"POST"] || [request.httpMethod isEqualToString:@"POST-RAW"]) {
        
        dataTask = [self.manager POST:urlString parameters:request.parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self paserResponse:responseObject request:request];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self paserErrorWithCode:error.code request:request];
            
        }];
        
    } else if ([request.httpMethod isEqualToString:@"DELETE"]) {
        
        dataTask = [self.manager DELETE:urlString parameters:request.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self paserResponse:responseObject request:request];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self paserErrorWithCode:error.code request:request];
            
        }];
        
    } else if([request.httpMethod isEqualToString:@"POST-UPLOAD"]) {
        
        dataTask =  [self.manager POST:urlString parameters:request.parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            [request.parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if([obj isKindOfClass:[NSData class]])
                {
                    [formData appendPartWithFileData:obj name:key fileName:@"file.jpg" mimeType:@"image/jpeg"];
                }
                else
                {
                    [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",obj] dataUsingEncoding:NSUTF8StringEncoding] name:key];
                }
            }];
            
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self paserResponse:responseObject request:request];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self paserErrorWithCode:error.code request:request];
            
        }];
    }
    
    request.dataTask = dataTask;
    
}

- (void)cancelRequest:(BaseRequest *)request {
    NSURLSessionDataTask *dataTask = request.dataTask;
    [request responseParser].errorCode = NETWORK_ERROR_USER_CANCELED;
    [dataTask cancel];
};

- (void)suspendRequest:(BaseRequest *)request {
    NSURLSessionDataTask *dataTask = request.dataTask;
    [dataTask suspend];
};

#pragma mark -- paserResponse
- (void)paserResponse:(id)response request:(nonnull BaseRequest *)request {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // class error
        if (![response isKindOfClass:[NSDictionary class]]) {
            [self paserErrorWithCode:NETWORK_ERROR_UNKNOW request:request];
        } else {
            [[request responseParser] setResponseObject:response];
            [[request responseParser] parseResponseObject];
        }
    });
}

- (void)paserErrorWithCode:(NSInteger)errorCode request:(nonnull BaseRequest *)request {
    if (!errorCode) {
        [[request responseParser] parseResponseFailure];
        return;
    }
    
    [[request responseParser] setErrorCode:errorCode];
    [[request responseParser] parseResponseFailure];
}


@end
