//
//  PNScanViewController.h
//  
//
//  Created by Paresh Navadiya on 30.06.15.
//  Copyright (c) 2015 ECWIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol PNScanViewControllerDelegate;

@interface PNScanViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, weak) id<PNScanViewControllerDelegate> delegate;

@property (assign, nonatomic) BOOL touchToFocusEnabled;

- (BOOL) isCameraAvailable;
- (void) startScanning;
- (void) stopScanning;
- (void) setTorch:(BOOL) aStatus;

@end

@protocol PNScanViewControllerDelegate <NSObject>

@optional

- (void) scanViewController:(PNScanViewController *) scanController didTapToFocusOnPoint:(CGPoint) aPoint;
- (void) scanViewController:(PNScanViewController *) scanController didSuccessfullyScan:(NSString *) aScannedValue andImage:(UIImage *)scannedImage;

@end