//
//  HyBridBridge1.m
//  London2
//
//  Created by Mr.Yao on 16/3/24.
//  Copyright © 2016年 yaoquafeng. All rights reserved.
//

#import "HyBridBridge.h"

@interface HyBridBridge ()

@property (strong, nonatomic) NSMutableDictionary *handlersDict;

@end

@implementation HyBridBridge

- (NSMutableDictionary *)handlersDict {
    if (!_handlersDict){
        _handlersDict = [NSMutableDictionary dictionary];
    }
    return _handlersDict;
}

- (BOOL)registerHybridUrlHanlder:(id<HybridUrlHanlder>)handler andBridge:(WebViewJavascriptBridge *)bridge {
    NSAssert([handler actionNames], @"action can not be nil");
    if (![handler actionNames]) {
        return NO;
    }
    for (NSString *action in [handler actionNames]) {
        [self.handlersDict setObject:handler forKey:action];

        [bridge registerHandler : action handler :^ (id data, WVJBResponseCallback responseCallback) {
            
            id<HybridUrlHanlder> handler = [self.handlersDict objectForKey:[NSString stringWithFormat:@"%@",data[@"actionName"]]];

            if (handler) {
                [handler handleDictionAry:data callback:^(BOOL isSucc, NSDictionary *nativeResponseData) {
                    if (isSucc) {
                        responseCallback(@{@"data":nativeResponseData}); //需要返回给HTML 部分参数 例子：pay 支付结果
                        return ;
                    }
                }];
            }
        }];
    }

    return YES;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com