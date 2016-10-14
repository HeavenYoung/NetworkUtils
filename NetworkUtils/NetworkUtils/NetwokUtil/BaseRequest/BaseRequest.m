//
//  BaseRequest.m
//  NetworkUtils
//
//  Created by Heaven on 16/9/21.
//  Copyright © 2016年 Heaven. All rights reserved.
//

#import "BaseRequest.h"
#import "NetworkUtil.h"

@implementation BaseRequest

- (instancetype)init {

    self = [super init];
    if (self) {
        _hostURLString = BASE_SERVER_URL;
        _httpMethod = @"GET";
        _timeoutInterval = 15.0f;
    }
    return self;
}

- (void)sendRequest {
    [[NetworkUtil sharedNetworkUtil] sendRequest:self];
}

- (void)cacelRequest {
    [[NetworkUtil sharedNetworkUtil] cancelRequest:self];
}

- (void)suspendRequest {
    [[NetworkUtil sharedNetworkUtil] suspendRequest:self];
}

- (void)parametersWithProperties {
    
    // _cmd 代表本类方法
    [self doesNotRecognizeSelector:_cmd];
}

- (BaseResponse *)responseParser {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
