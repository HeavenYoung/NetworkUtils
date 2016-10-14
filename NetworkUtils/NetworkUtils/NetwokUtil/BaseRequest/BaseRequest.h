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
    BaseResponse * _responseParser;
}
@property (nonatomic, copy) NSString *hostURLString;
@property (nonatomic, copy) NSString *URLString;
@property (nonatomic, strong) id parameters;
@property (nonatomic, copy) NSString *httpMethod;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, copy) RequestSuccessBlock successBlock;
@property (nonatomic, copy) RequestFailureBlock failureBlock;
/** 设置成功回调 */
- (void)setSuccessBlock:(RequestSuccessBlock)successBlock;
/** 设置失败回调 */
- (void)setFailureBlock:(RequestFailureBlock)failureBlock;
/** 整合参数 */
- (void)parametersWithProperties;
/** 发送请求 */
- (void)sendRequest;
/** 取消请求 */
- (void)cacelRequest;
/** 挂起请求 */
- (void)suspendRequest;
/** 解析 */
- (BaseResponse *)responseParser;

#define ResponserParserGenerate(responseClassName) \
-(BaseResponse *)responseParser{\
if (!_responseParser) {\
_responseParser=[[responseClassName alloc]init];\
[_responseParser setRequest:self];\
}\
return _responseParser;\
}

@end
