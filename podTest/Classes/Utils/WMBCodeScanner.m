//
//  WMBCodeScanner.m
//  waimaibiz
//
//  Created by jianghaowen on 2017/1/17.
//  Copyright © 2017年 meituan. All rights reserved.
//

#import "WMBCodeScanner.h"
#import <AVFoundation/AVFoundation.h>
#import "WMBScanCoverView.h"
#import <TKAlertCenter.h>

@interface WMBCodeScanner () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) AVCaptureDeviceInput *deviceInput;
@property (nonatomic) AVCaptureMetadataOutput *output;
@property (nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic) dispatch_queue_t queue;

@property (nonatomic) BOOL hasResult; // 防止重复识别

@end

@implementation WMBCodeScanner

- (instancetype)initWithCoverView:(WMBScanCoverView *)coverView
{
    self = [super init];
    if (self) {
        self.coverView = coverView;
        self.queue = dispatch_queue_create("scanrunning", NULL);
    }
    return self;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)startScanning
{
    [self startScanning:NULL];
}

- (void)startScanning:(void (^)())completion
{
    self.hasResult = NO;
    
    [self.previewLayer removeFromSuperlayer];
    self.coverView.lineViewHidden = NO;
    self.coverView.highlightView.frame = CGRectZero;
    @weakify(self);
    dispatch_async(self.queue, ^{
        @strongify(self);
        [self.captureSession startRunning];
        dispatch_async(dispatch_get_main_queue(), ^{
            @wmb_safe_block(completion);
            [self.coverView.superview.layer insertSublayer:self.previewLayer below:self.coverView.layer];
        });
    });
}

- (void)stopScanning
{
    if (self.captureSession.isRunning) {
        self.coverView.lineViewHidden = YES;
        self.coverView.highlightView.frame = CGRectZero;
        dispatch_async(self.queue, ^{
            [self.captureSession stopRunning];
        });
    }
}

- (void)checkCameraAndAuthorityWithCompletionHandler:(void (^)(BOOL granted))handler
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                             completionHandler:^(BOOL granted) {
                                 if (!granted) {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         if (handler) {
                                             handler(granted);
                                         }
                                     });
                                 }
                             }];
}

- (BOOL)setupSession
{
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([captureDevice respondsToSelector:@selector(setVideoZoomFactor:)]) {
        [captureDevice lockForConfiguration:nil];
        AVCaptureDeviceFormat *format = captureDevice.activeFormat;
        captureDevice.videoZoomFactor = MIN(2.0, format.videoMaxZoomFactor);
        [captureDevice unlockForConfiguration];
    }
    if ([captureDevice respondsToSelector:@selector(isSmoothAutoFocusSupported)] &&
        captureDevice.isSmoothAutoFocusSupported) {
        if ([self backCameraAvailable]) { // Hack for iPod Touch without backend camera
            [captureDevice lockForConfiguration:nil];
            captureDevice.smoothAutoFocusEnabled = YES;
            [captureDevice unlockForConfiguration];
        }
    }
    
    NSError *error = nil;
    AVCaptureDeviceInput *deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if (error || !deviceInput) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"设备初始化失败"];
        return NO;
    }
    self.deviceInput = deviceInput;
    if ([self.captureSession canAddInput:deviceInput]) {
        [self.captureSession addInput:deviceInput];
    }
    
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    if ([self.captureSession canAddOutput:self.output]) {
        [self.captureSession addOutput:self.output];
    }
    
    // Use unavailable metadata object types, receivers will raise an NSException
    NSMutableArray *availableMetadataObjectTypes = [self.output.availableMetadataObjectTypes mutableCopy];
    [availableMetadataObjectTypes removeObject:AVMetadataObjectTypeFace];
    self.output.metadataObjectTypes = availableMetadataObjectTypes;
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    self.previewLayer.frame = self.coverView.frame;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;    
    self.output.rectOfInterest = [self.previewLayer metadataOutputRectOfInterestForRect:self.coverView.cropRect];
    
    return YES;
}

- (BOOL)backCameraAvailable
{
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for (AVCaptureDevice *device in videoDevices) {
        if (device.position == AVCaptureDevicePositionBack) {
            return YES;
        }
    }
    
    return NO;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    if (!self.hasResult && metadataObjects.count > 0) {
        // Find and use the first object
        __block AVMetadataMachineReadableCodeObject *metadataObject = nil;
        [metadataObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            metadataObject = (AVMetadataMachineReadableCodeObject *)obj;
            if (metadataObject && metadataObject.stringValue.length > 0) {
                *stop = YES;
                self.hasResult = YES;
                [self stopScanning];
            }
        }];
        
        if (metadataObject && metadataObject.stringValue.length > 0) {
            AVMetadataMachineReadableCodeObject *barCodeObject = (AVMetadataMachineReadableCodeObject *)[self.previewLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadataObject];
            highlightViewRect = barCodeObject.bounds;
            if (self.didCaptureString) {
                self.didCaptureString(metadataObject.stringValue);
            }
        }
    }
    
    self.coverView.highlightView.frame = highlightViewRect;
}

@end
