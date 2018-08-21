//
//  ScanOneViewController.m
//  二维码扫描1
//
//  Created by wanghao on 16/7/12.
//  Copyright © 2016年 wanghao. All rights reserved.
//

#import "ScanOneViewController.h"
#import "QRViewController.h"
#import "QRView.h"
#import <AVFoundation/AVFoundation.h>
#import "ZBarSDK.h"
#import "QRViewController.h"
#import "UIColor+Hex.h"
#import "Masonry.h"

@interface ScanOneViewController ()
<
ZBarReaderDelegate,
AVCaptureMetadataOutputObjectsDelegate,
UIAlertViewDelegate
>

@property (nonatomic,copy)NSString *urlString;

@property (nonatomic,strong)AVCaptureDevice *device;
@property (nonatomic,strong)AVCaptureDeviceInput *input;
@property (nonatomic,strong)AVCaptureMetadataOutput *output;
@property (nonatomic,strong)AVCaptureSession *session;
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *preview;
@end

@implementation ScanOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initConfig];
}


- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
}
- (void)initConfig {
    // 检查授权
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:mediaType];
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc] init];
    
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    // 条码类型
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResize;
    self.preview.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // kaishi
    [self.session startRunning];
    
    QRView *qrView = [[QRView alloc] init];
    [self.view addSubview:qrView];
    [qrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        //        make.left.equalTo(@0);
        //        make.right.equalTo(@0);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view);
    }];
    
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    
    CGSize size = CGSizeZero;
    if (self.view.frame.size.width > 320) {
        size = CGSizeMake(200, 160);
    } else {
        size = CGSizeMake(200, 160);
    }
    
    qrView.transparentArea = size;
    qrView.backgroundColor = [UIColor clearColor];
    //    qrView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 - 200);
    
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    //    [[UILabel alloc] initWithFrame:CGRectMake(0, qrView.center.y + size.height/2 + 20,
    //                                                                  self.view.frame.size.width, 50)];
    [self.view addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(qrView);
        make.top.equalTo(self.view).offset(self.view.bounds.size.height/2 + size.height/2 + 60 - 200);
    }];
    //    self.money = 200.22;
//    moneyLabel.text = [NSString stringWithFormat:@"￥ %.2f",self.money];
    moneyLabel.text = @"请扫描";
    moneyLabel.textColor = [UIColor whiteColor];
    moneyLabel.font = [UIFont systemFontOfSize:30];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)go2myQRView {
    QRViewController *myQRView = [[QRViewController alloc] init];
    [self.navigationController pushViewController:myQRView animated:YES];
}

#pragma mark -----AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject *metaDataObject = [metadataObjects firstObject];
        
        self.urlString = metaDataObject.stringValue;
        NSLog(@"-----%@",self.urlString);
    }
    self.QRUrlBlock(self.urlString);
    //    [self handelURLString:self.urlString];
}


//https://www.baidu.com
// 处理扫描的字符串
-(void)handelURLString:(NSString *)string
{
    
    NSArray * array = [string componentsSeparatedByString:@"/"];
    if ([string hasPrefix:@"http"]) {
        
        NSLog(@"%@", array);
        if (array.firstObject) {
            // 这里用户根据自己的业务逻辑进行处理 比如判断字符串是否包含某个特定的字符串 然后根据url跳转到响应的界面(如个人详情加好友页面....)
            if ([array[2] isEqualToString:@"www.baidu.com"]) {
                [self.session startRunning];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.baidu.com"]];
            }else{
                UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示"message:[NSString stringWithFormat:@"该链接可能存在风险\n%@",string] delegate:self cancelButtonTitle:@"取消"otherButtonTitles:@"打开链接",nil];
                alertView.tag = 100086;
                alertView.delegate = self;
                self.urlString = string;
                [self.session stopRunning];
                [alertView show];
            }
        }
    }else{
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示"message:[NSString stringWithFormat:@"扫描结果:\n%@",string] delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
        alertView.tag = 100087;
        [self.session stopRunning];
        [alertView show];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSArray *resuluts = [info objectForKey:ZBarReaderControllerResults];
    
    if (resuluts.count > 0) {
        int quality = 0;
        ZBarSymbol *bestResult = nil;
        for (ZBarSymbol *sym in resuluts) {
            int tempQ = sym.quality;
            if (quality < tempQ) {
                quality = tempQ;
                bestResult = sym;
            }
        }
        
        [self presentResult:bestResult];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) presentResult: (ZBarSymbol*)sym {
    if (sym) {
        NSString *tempStr = sym.data;
        if ([sym.data canBeConvertedToEncoding:NSShiftJISStringEncoding]) {
            tempStr = [NSString stringWithCString:[tempStr cStringUsingEncoding:NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }
        NSLog(@"%@",tempStr);
        
        
        [self handelURLString:tempStr];
    }
}


#pragma mark ---alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100086) {
        if (buttonIndex == 1) {
            [self.session startRunning];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.urlString]];
        } else {
            [self.session startRunning];
        }
    }
    
    if (alertView.tag == 100087) {
        if (buttonIndex == 0) {
            [self.session startRunning];
        }
    }
}

@end
