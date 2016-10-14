//
//  BaseResponse.h
//  NetworkUtils
//
//  Created by Heaven on 16/9/21.
//  Copyright © 2016年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseRequest;

@interface BaseResponse : NSObject

@property (nonatomic, weak) BaseRequest *request;
@property (nonatomic, assign) NSInteger errorCode;
@property (nonatomic, strong) id responseObject;

/** 解析正确数据 */
- (void)parseResponseObject;
/** 数据错误时候的处理 */
- (void)parseResponseFailure;
/** 数据请求成功，刷新UI */
- (void)showSuccessInfo:(id)object;
/** 展示错误信息界面 */
- (void)showFailureInfo:(NSInteger)errorCode;

@end
