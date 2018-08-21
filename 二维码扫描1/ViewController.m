//
//  ViewController.m
//  QRCode
//
//  Created by Apple on 16/5/9.
//  Copyright © 2016年 aladdin-holdings.com. All rights reserved.
//

#import "ViewController.h"
#import "UMSocial.h"
#import "HyBridBridge.h"
//#import "HybirdAppViewController.h"
#import "HybirdUrlHandler.h"
#import "UIView+Toast.h"
#import "QRViewController.h"
#import "ScanViewController.h"
#import "ScanOneViewController.h"
//#import "LXRHudManager.h"
#import <UMPush/UMessage.h>

@interface ViewController () <UIWebViewDelegate, HybridUrlHanlder>

@property (nonatomic, strong) UIWebView *webView;

@property WebViewJavascriptBridge *bridge;
@property (strong, nonatomic) HyBridBridge *hybridBridge;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
}

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUrl:) name:@"loadUrl" object:@""];
}

- (void)setupViews {
    [WebViewJavascriptBridge enableLogging];
    
//    NSString *fileString = [[NSBundle mainBundle] pathForResource:@"testDemo" ofType:@"html"];
//    NSString *htmlString = [NSString stringWithContentsOfFile:fileString encoding:NSUTF8StringEncoding error:nil];
//    [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:fileString]];

    NSURL *url = [NSURL URLWithString:@"https://www.beizijinfu.com/app/login.htm"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
//    [self.webView];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.hybridBridge registerHybridUrlHanlder:self andBridge:self.bridge];
    [_bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
    
}

#pragma mark - Getters & Setters

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [self.view addSubview:_webView];
         _webView.delegate = self;
        [_webView.scrollView setBounces:NO];
    }
    return _webView;
}

- (HyBridBridge *)hybridBridge {
    if (!_hybridBridge) {
        _hybridBridge = [[HyBridBridge alloc] init];
    }
    return _hybridBridge;
}

- (NSArray *)actionNames {
    return @[@"pay" ,@"txm", @"share", @"loginSuccess", @"savePref", @"getPref"];
}

- (BOOL)handleDictionAry:(NSDictionary *)dictionary callback:(HybridCallbackBlock)callbackBlock {
    NSString *actionTag = dictionary[@"actionName"];
    NSLog(@"%@%@",dictionary[@"money"],dictionary[@"url"]);
    if ([actionTag isEqualToString:@"pay"]) {
        [self nativePushPayViewControllerWithOrderID:[dictionary[@"money"] doubleValue] Callback:callbackBlock andUrlString:dictionary[@"url"]];
        return YES;
    } else  if ([actionTag isEqualToString:@"txm"]) {
        [self nativePushTXMViewControllerWithOrderID:[dictionary[@"money"] integerValue] Callback:callbackBlock];
        return YES;
    } else  if ([actionTag isEqualToString:@"loginSuccess"]) {
        [self nativePushloginSuccessViewControllerWithUserId:dictionary[@"userId"] Callback:callbackBlock];
        return YES;
    } else  if ([actionTag isEqualToString:@"savePref"]) {
        [self nativesavePrefWithDic:dictionary Callback:callbackBlock];
        return YES;
    } else  if ([actionTag isEqualToString:@"getPref"]) {
        [self nativegetPrefWithDic:dictionary Callback:callbackBlock];
        return YES;
    }
    return NO;
}

- (void)nativegetPrefWithDic:(NSDictionary *)dict Callback:(HybridCallbackBlock)callbackBlock
{
    if (dict[@"value"] && dict[@"key"]) {
        [[NSUserDefaults standardUserDefaults] setObject:dict[@"value"] forKey:dict[@"key"]];
    }
}

- (void)nativesavePrefWithDic:(NSDictionary *)dict Callback:(HybridCallbackBlock)callbackBlock
{
    if (dict[@"key"] && [[NSUserDefaults standardUserDefaults] objectForKey:dict[@"key"]]) {
        if (callbackBlock) {
            callbackBlock(YES, @{@"value" : [[NSUserDefaults standardUserDefaults] objectForKey:dict[@"key"]]});
        }
    }
}

- (void)nativePushloginSuccessViewControllerWithUserId:(NSString *)userId Callback:(HybridCallbackBlock)callbackBlock
{
    //绑定别名
    if (userId) {
        [UMessage addAlias:userId type:@"user_account" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        }];
    }
}

- (void)nativePushTXMViewControllerWithOrderID:(NSInteger)money Callback:(HybridCallbackBlock)callbackBlock{
    ScanOneViewController * payVC = [[ScanOneViewController alloc]init];
    payVC.QRUrlBlock = ^(NSString *urlString){
        NSLog(@"%@",urlString);
        [self.navigationController popViewControllerAnimated:YES];
        callbackBlock(YES,@{@"code": @(10000),@"message" : urlString});
    };
    
    [self.navigationController pushViewController:payVC animated:YES];
}

- (void)nativePushShareViewControllerWithDic:(NSDictionary *)Dic Callback:(HybridCallbackBlock)callbackBlock{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:Dic[@"imgUrl"]]]];
        [UMSocialData defaultData].extConfig.title = Dic[@"title"];
        [UMSocialData defaultData].extConfig.qqData.url = Dic[@"url"];
    [UMSocialData defaultData].extConfig.qzoneData.url = Dic[@"url"];
//    [UMSocialData defaultData].extConfig.smsData.url = ;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = Dic[@"url"];
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = Dic[@"url"];
    
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"57859b6b67e58e2a3e001529"
                                          shareText:Dic[@"content"]
                                         shareImage:image
                                    shareToSnsNames:@[UMShareToWechatSession, UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone,UMShareToSms]
                                           delegate:self];
//    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
//                                        @"http://www.baidu.com/img/bdlogo.gif"];
//    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:@"分享内嵌文字" image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
//        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
//            NSLog(@"分享成功！");
//        }
//    }];
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

- (void)nativePushPayViewControllerWithOrderID:(double)money Callback:(HybridCallbackBlock)callbackBlock andUrlString:(NSString *)urlString
{
    ScanViewController * payVC = [[ScanViewController alloc]init];
    payVC.webUrlString = urlString;
    payVC.money = money;
    payVC.QRUrlBlock = ^(NSString *urlString){
        NSLog(@"%@",urlString);
        [self.navigationController popViewControllerAnimated:YES];
        callbackBlock(YES,@{@"code": @(10000),@"message" : urlString});
//        if (isPaySucc){
//            callbackBlock(YES,@{ @"code": @(10000), @"message" : @"支付成功"});
//        }else{
//            callbackBlock(YES,@{ @"code": @(10001), @"message" : @"支付失败" });
//        }
    };
    [self.navigationController pushViewController:payVC animated:YES];
}

- (void)loadUrl:(NSNotification *)noti
{
    NSDictionary *userInfo = noti.object;
    if ([userInfo isKindOfClass:[NSDictionary class]] && userInfo[@"url"]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:userInfo[@"url"]]]];
    }
}

@end
