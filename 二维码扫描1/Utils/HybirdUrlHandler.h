
#ifndef HybridUrlHanlder1_h
#define HybridUrlHanlder1_h
#import "WebViewJavascriptBridge.h"
//#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>

typedef void (^HybridCallbackBlock)(BOOL isSucc, NSDictionary *nativeResponseData);

@protocol HybridUrlHanlder <NSObject>

/**
 *  处理URL
 *
 *  @param theURL
 *
 *  @return 是否成功处理
 */
- (BOOL)handleDictionAry:(NSDictionary *)dictionary callback:(HybridCallbackBlock)callbackBlock;

/**
 *  可以接受的actionNames列表
 *
 * 每个Item为NSString类型
 */
- (NSArray *)actionNames;

@end

#endif /* HybridUrlHanlder_h */// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com