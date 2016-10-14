//
//  NetworkConst.h
//  NetworkUtils
//
//  Created by Heaven on 16/9/21.
//  Copyright © 2016年 Heaven. All rights reserved.
//
// 网络基础参数配置

#ifndef NetworkConst_h
#define NetworkConst_h

typedef enum : NSUInteger {
    GET = 0,
    POST,
    HEAD,
    DELETE,
    PUT,
} HttpMethod;

/* 主机地址 自己指定*/
#define BASE_SERVER_URL @"www.xxoo.com"

/********      Const     ********/
#define NETWORK_TIMEOUTINTERVAL         15.0f
#define kMaxConnection                  5.0f

/********    Error code   ********/
#define NETWORK_ERROR_UNKNOW            -99                          // 未知的错误
#define NETWORK_ERROR_REQUEST_PARAMS    -100                         // 由于请求参数校验未通过而终止
#define NETWORK_ERROR_PARSE_FAILED      -101                         // 解析失败
#define NETWORK_ERROR_USER_CANCELED     -102                         // 用户取消
#define NETWORK_ERROR_NOTREACHABLE      -103                         // 无网络
#define NETWORK_ERROR_PARAMS_ERROR      200001                       // 参数错误
#define NETWORK_ERROR_NORESULTS         200002                       // 查无结果
/********      End         ********/

#define CODE_SUCCESS        0

#endif /* NetworkConst_h */
