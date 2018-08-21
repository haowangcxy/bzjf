//
//  ScanViewController.h
//  QRCode
//
//  Created by Apple on 16/5/9.
//  Copyright © 2016年 aladdin-holdings.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanViewController : UIViewController

@property (nonatomic, copy) NSString *webUrlString;
@property (nonatomic, assign) double money;
@property (nonatomic,copy)void (^QRUrlBlock)(NSString *url);

@end
