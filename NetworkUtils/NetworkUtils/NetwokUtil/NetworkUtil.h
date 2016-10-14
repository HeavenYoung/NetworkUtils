//
//  NetworkUtil.h
//  NetworkUtils
//
//  Created by Heaven on 16/9/21.
//  Copyright © 2016年 Heaven. All rights reserved.
//
// 只是对AFNetworking做的封装

#import <Foundation/Foundation.h>
#import "NetworkConst.h"
#import "BaseRequest.h"

@interface NetworkUtil : NSObject

+ (instancetype)sharedNetworkUtil;

- (void)sendRequest:(BaseRequest *)request;

- (void)cancelRequest:(BaseRequest *)request;

- (void)suspendRequest:(BaseRequest *)request;

@end
