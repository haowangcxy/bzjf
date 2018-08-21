//
//  HyBridBridge1.h
//  London2
//
//  Created by Mr.Yao on 16/3/24.
//  Copyright © 2016年 yaoquafeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HybirdUrlHandler.h"

@interface HyBridBridge : NSObject

- (BOOL)registerHybridUrlHanlder:(id<HybridUrlHanlder>)handler andBridge:(WebViewJavascriptBridge*)bridge ;


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com