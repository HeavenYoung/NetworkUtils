//
//  BaseResponse.m
//  NetworkUtils
//
//  Created by Heaven on 16/9/21.
//  Copyright © 2016年 Heaven. All rights reserved.
//

#import "BaseResponse.h"
#import "BaseRequest.h"

@implementation BaseResponse

- (void)parseResponseObject {
    
}

- (void)parseResponseFailure {
    [self showFailureInfo:_errorCode];
}

- (void)showSuccessInfo:(id)object {
    
    if (_request.successBlock) {
        
        if ([NSThread currentThread].isMainThread) {
            _request.successBlock(object, _responseObject);
        } else {
            
            __strong __block id requestObj = _request;
            dispatch_async(dispatch_get_main_queue(), ^{
                _request.successBlock(object, _responseObject);
                requestObj=nil;
            });
        }
    }
}

- (void)showFailureInfo:(NSInteger)errorCode {
    if (_request.failureBlock) {
        
        if ([NSThread currentThread].isMainThread) {
            _request.failureBlock(errorCode, _responseObject);
        } else {
            __strong __block id requestObj = _request;
            dispatch_async(dispatch_get_main_queue(), ^{
                _request.failureBlock(errorCode, _responseObject);
                requestObj=nil;
            });
        }
    }
    
}

@end
