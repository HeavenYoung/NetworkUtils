//
//  BaseRequest.h
//  NetworkUtils
//
//  Created by Heaven on 16/9/21.
//  Copyright © 2016年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RequestSuccessBlock) (id object, id responseObject);
typedef void (^RequestFailureBlock) (NSInteger errorCode, id responseObject);

@class BaseResponse;

@interface BaseRequest : NSObject
{
    /* 用来做解析的类 */
    BaseResponse * _responseParser;
}
/* 主机地址 */
@property (nonatomic, copy) NSString *hostURLString;
/* 接口地址 */
@property (nonatomic, copy) NSString *URLString;
/* 接口参数 */
@property (nonatomic, strong) id parameters;
/* 借口请求方式 */
@property (nonatomic, copy) NSString *httpMethod;
/* NSURLSessionDataTask */
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
/* 请求成功的回调 */
@property (nonatomic, copy) RequestSuccessBlock successBlock;
/* 请求失败的回调 */
@property (nonatomic, copy) RequestFailureBlock failureBlock;

@end
