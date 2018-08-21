//
//  LXRHudManager.m
//  LingXiRead
//
//  Created by quanwen on 16/4/17.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import "LXRHudManager.h"
#import "MBProgressHUD.h"

#define KeyWindow [UIApplication sharedApplication].keyWindow

@implementation LXRHudManager

#pragma mark - 在view上展示转圈等待

+ (void)showHudLoading:(UIView *)view
{
    [MBProgressHUD showHUDAddedTo:view offset:140 animated:YES];
}

+ (void)hideHudLoading:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

+ (MBProgressHUD *)getLoadingViewAfterShow:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view offset:140 animated:YES];
    return hud;
}

#pragma mark - 在window上展示转圈等待

+ (void)showHudLoadingOnWindow
{
    [self showHudLoading:KeyWindow];
}

+ (void)hideHudLoadingOnWindow
{
    [self hideHudLoading:KeyWindow];
}

+ (MBProgressHUD *)getLoadingViewAfterShowOnWindow
{
    MBProgressHUD *hud = [self getLoadingViewAfterShow:KeyWindow];
    return hud;
}

#pragma mark - 展示toast

+ (void)showCenterHudText:(NSString*)title message:(NSString*)message showTime:(NSTimeInterval)showTime view:(UIView *)view;
{
    if(showTime <= 0)
    {
        return;
    }
    
    MBProgressHUD* hud = [[MBProgressHUD alloc]init];
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    hud.label.text = title;
    hud.detailsLabel.text = message;
    hud.mode = MBProgressHUDModeText;
    [view addSubview:hud];
    hud.center = view.center;
    [hud showAnimated:YES];
    
    if(showTime > 120)
    {
        showTime = 120;
    }
    [hud hideAnimated:YES afterDelay:showTime];
}

+ (void)showCenterHudTextOnWindow:(NSString*)title message:(NSString*)message showTime:(NSTimeInterval)showTime
{
    [self showCenterHudText:title message:message showTime:showTime view:KeyWindow];
}

+ (void)showCenterHudTextNoTitle:(NSString*)message showTime:(NSTimeInterval)showTime view:(UIView *)view
{
    [self showCenterHudText:nil message:message showTime:showTime view:view];
}

+ (void)showCenterHudTextNoTitleOnWindow:(NSString*)message showTime:(NSTimeInterval)showTime
{
    [self showCenterHudTextOnWindow:nil message:message showTime:showTime];
}


@end
