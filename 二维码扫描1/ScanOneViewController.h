//
//  ScanOneViewController.h
//  二维码扫描1
//
//  Created by wanghao on 16/7/12.
//  Copyright © 2016年 wanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanOneViewController : UIViewController

@property (nonatomic,copy)void (^QRUrlBlock)(NSString *url);

@end
