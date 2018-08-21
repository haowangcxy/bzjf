//
//  AppDelegate.m
//  二维码扫描1
//
//  Created by wanghao on 16/7/10.
//  Copyright © 2016年 wanghao. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocial.h"
#import "UMSocialSinaSSOHandler.h"
#import <UMPush/UMessage.h>
#import <UMCommon/UMCommon.h>
#import <UMCommon/UMConfigure.h>
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialConfig.h"
#import "BDSSpeechSynthesizer.h"
//#import "UMSocialSinaSSOHandler.h"

NSString* APP_ID = @"11696984";
NSString* API_KEY = @"UWV1qOrejGfTgHihfDdABfNi";
NSString* SECRET_KEY = @"TSUs6cG1GRtnEneXPTwHggPAmtYdNW1X";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //友盟分享
    [UMSocialData setAppKey:@"57859b6b67e58e2a3e001529"];
    [self configureUmessageWithLauchOptions:launchOptions];
    [self setTTSSdk];
    
//    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskLandscapeLeft];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx7b09ce7a4cf74ce5" appSecret:@"8c50c2c31bd7635f90979775d7b413c3" url:@"http://www.umeng.com/social"];
//    设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:@"1106440575" appKey:@"xbY32kKvwp6pVRwv" url:@"http://www.umeng.com/social"];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"4066133587"
//                                              secret:@"1f38a853203fa06989c578d16212631e"
//                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession, UMShareToWechatTimeline]];
    return YES;
}

- (void)setTTSSdk
{
    [[BDSSpeechSynthesizer sharedInstance] setApiKey:API_KEY withSecretKey:SECRET_KEY];
//    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback error:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [[BDSSpeechSynthesizer sharedInstance] speakSentence:@"陈姣快过来" withError:nil];
    });
}

- (void)configureUmessageWithLauchOptions:(NSDictionary *)launchOption{
    //开发者需要显式的调用此函数，日志系统才能工作
//    [UMCommonLogManager setUpUMCommonLogManager];
//    [UMConfigure setLogEnabled:YES];
    [UMConfigure initWithAppkey:@"5b78d876b27b0a3dd1000479" channel:@"App Store"];
    //    [UMessage registerDeviceToken:[UIDevicet]]
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert;
    [UNUserNotificationCenter currentNotificationCenter].delegate=self;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOption Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        }else
        {
        }
    }];
    NSLog(@"launchOption-------------%@", launchOption);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (launchOption) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUrl" object:launchOption];
//            });
//        }
//    });
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // [JPUSHService handleRemoteNotification:userInfo];
    
    [UMessage setAutoAlert:NO];
    if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
        NSString *notification_setting = [[NSUserDefaults standardUserDefaults] objectForKey:@"notification_setting"];
        if (!notification_setting || [notification_setting integerValue])  {
//            [UMessage didReceiveRemoteNotification:userInfo];
        }
        NSString *player_setting = [[NSUserDefaults standardUserDefaults] objectForKey:@"player_setting"];
        if (!player_setting || [player_setting integerValue]) {
            if ([[BDSSpeechSynthesizer sharedInstance] synthesizerStatus] == BDS_SYNTHESIZER_STATUS_WORKING) {
                return;
            }
            [[BDSSpeechSynthesizer sharedInstance] speakSentence:userInfo[@"text"] withError:nil];
        }
        //    self.userInfo = userInfo;
        //定制自定的的弹出框
        
        
        
        //        completionHandler(UIBackgroundFetchResultNewData);
    }
//    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
//    [self easemobApplication:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    pab.string = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                    stringByReplacingOccurrencesOfString: @">" withString: @""]
                   stringByReplacingOccurrencesOfString: @" " withString: @""];
    //    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [UMessage registerDeviceToken:deviceToken];
    
//    NSMutableString *deviceTokenString1 = [NSMutableString string];
//    const char *bytes = deviceToken.bytes;
//    int iCount = deviceToken.length;
//    for (int i = 0; i < iCount; i++) {
//        [deviceTokenString1 appendFormat:@"%02x", bytes[i]&0x000000FF];
//    }
    
    
//    [[YRUserClient sharedClient] storageDeviceToken:deviceTokenString1];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}

#pragma mark 推送 收到通知

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    // [JPUSHService handleRemoteNotification:userInfo];
//    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    [UMessage setAutoAlert:NO];
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
        NSString *player_setting = [[NSUserDefaults standardUserDefaults] objectForKey:@"player_setting"];
        if (!player_setting || [player_setting integerValue]) {
            if ([[BDSSpeechSynthesizer sharedInstance] synthesizerStatus] == BDS_SYNTHESIZER_STATUS_WORKING) {
                return;
            }
            NSLog(@"%@",userInfo[@"aps"][@"alert"][@"title"]);
            [[BDSSpeechSynthesizer sharedInstance] speakSentence:@"2342342" withError:nil];
        }
//                if([UIApplication sharedApplication].applicationState != UIApplicationStateActive)
//                {
        if (userInfo) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUrl" object:userInfo];
            });
        }
//                }
        //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
        //                                                                message:[NSString stringWithFormat:@"Test On ApplicationStateActive%@", userInfo]
        //                                                               delegate:self
        //                                                      cancelButtonTitle:@"确定"
        //                                                      otherButtonTitles:nil];
        //
        //            [alertView show];
        //        }
        
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    //    NSDictionary *userInfo = notification.request.content.userInfo;
//    [self easemobApplication:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //        //必须加这句代码
        NSString *notification_setting = [[NSUserDefaults standardUserDefaults] objectForKey:@"notification_setting"];
        if (!notification_setting || [notification_setting integerValue])  {
            [UMessage didReceiveRemoteNotification:userInfo];
        }
        NSString *player_setting = [[NSUserDefaults standardUserDefaults] objectForKey:@"player_setting"];
        if (!player_setting || [player_setting integerValue]) {
            if ([[BDSSpeechSynthesizer sharedInstance] synthesizerStatus] == BDS_SYNTHESIZER_STATUS_WORKING) {
                return;
            }
            [[BDSSpeechSynthesizer sharedInstance] speakSentence:userInfo[@"text"]  withError:nil];
        }
//        [UMessage didReceiveRemoteNotification:userInfo];
        //        if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
        //        {
        //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
        //                                                                message:[NSString stringWithFormat:@"Test On ApplicationStateActive%@", userInfo]
        //                                                               delegate:self
        //                                                      cancelButtonTitle:@"确定"
        //                                                      otherButtonTitles:nil];
        //
        //            [alertView show];
        //        }
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

#pragma mark 推送 收到通知

//iOS10新增：处理点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
//        if([UIApplication sharedApplication].applicationState != UIApplicationStateActive)
//        {
            if (userInfo) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadUrl" object:userInfo];
                });
            }
//        }
    }
    
    completionHandler();
}

//// 将得到的deviceToken传给SDK
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//{
//    NSString *deviceT = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
//                          stringByReplacingOccurrencesOfString: @">" withString: @""]
//                         stringByReplacingOccurrencesOfString: @" " withString: @""];
//    NSLog(@"%@",deviceT);
//    //    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
//    [UMessage registerDeviceToken:deviceToken];
//    if (deviceT.length > 0) {
//        [[NSUserDefaults standardUserDefaults] setObject:deviceT forKey:@"deviceToken"];
//    }
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
////        [[EMClient sharedClient] bindDeviceToken:deviceToken];
//    });
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
