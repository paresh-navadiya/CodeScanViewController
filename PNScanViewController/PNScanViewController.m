//
//  PNScanViewController.m
//  
//
//  Created by Paresh Navadiya on 30.06.15.
//  Copyright (c) 2015 ECWIT. All rights reserved.
//

#import "PNScanViewController.h"

@interface PNScanViewController ()
{
    //UIView *topBarView;
    //UILabel *lblTitle;
    UIView *containerView;
}

@property (strong, nonatomic) AVCaptureDevice* device;
@property (strong, nonatomic) AVCaptureDeviceInput* input;
@property (strong, nonatomic) AVCaptureMetadataOutput* output;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) AVCaptureSession* session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer* preview;
@end

@implementation PNScanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    
}

- (void) viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createBarUI];
    
    if([self isCameraAvailable]) {
        [self setupScanner];
    }
    else
    {
        [self setupNoCameraView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)evt
{
    if(self.touchToFocusEnabled) {
        UITouch *touch=[touches anyObject];
        CGPoint pt= [touch locationInView:self.view];
        [self focus:pt];
    }
}

#pragma mark -
#pragma mark NoCamAvailable

- (void) setupNoCameraView;
{
    UILabel *labelNoCam = [[UILabel alloc] init];//WithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 30)];
    labelNoCam.text = @"No Camera available";
    labelNoCam.textColor = [UIColor whiteColor];
    [self.view addSubview:labelNoCam];
    [labelNoCam sizeToFit];
    labelNoCam.center = self.view.center;
}

- (NSUInteger)supportedInterfaceOrientations;
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate;
{
    return NO;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;
{
    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
        AVCaptureConnection *con = self.preview.connection;
        con.videoOrientation = AVCaptureVideoOrientationPortrait;
    } else if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown)
    {
        AVCaptureConnection *con = self.preview.connection;
        con.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
    }
}

#pragma mark -
#pragma mark - AVFoundationSetup

- (void) setupScanner;
{
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];

    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPreset640x480];
    
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.session addOutput:self.output];
    [self.session addInput:self.input];
    
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    // Prepare an output for snapshotting
    self.stillImageOutput = [AVCaptureStillImageOutput new];
    [self.session addOutput:self.stillImageOutput];
    self.stillImageOutput.outputSettings = @{AVVideoCodecKey: AVVideoCodecJPEG};
    
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [containerView.layer insertSublayer:self.preview atIndex:0];
    
    [self.session startRunning];
}

#pragma mark -
#pragma mark - UI Methods

-(void)createBarUI
{
    //get rect
    CGRect windowRect = [UIScreen mainScreen].bounds;

    //create topBarView
    UIView *topBarView = [[UIView alloc]initWithFrame:CGRectMake(0,0,windowRect.size.width,64.0)];
    topBarView.backgroundColor = [UIColor blueColor];
    
    //create title label
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,20,windowRect.size.width,44.0f)];
    [lblTitle setFont:[UIFont boldSystemFontOfSize:18.0]];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.text = @"Badge Scanner";
    [topBarView addSubview:lblTitle];
    
    //create back button
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(0, 20, 44, 44)];
    [btnBack setImage:[UIImage imageNamed:@"zbar-back"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(btnBackAction:) forControlEvents:UIControlEventTouchUpInside];
    [topBarView addSubview:btnBack];
    
    //add topBarView to main view
    [self.view addSubview:topBarView];
    
    //create containerView
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0,64.0,windowRect.size.width,windowRect.size.height-64.0)];
    containerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:containerView];
}

#pragma mark -
#pragma mark Action Methods
-(IBAction)btnBackAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Helper Methods

- (BOOL) isCameraAvailable;
{
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    return [videoDevices count] > 0;
}

- (void)startScanning;
{
    [self.session startRunning];

}

- (void) stopScanning;
{
    [self.session stopRunning];
}

- (void) setTorch:(BOOL) aStatus;
{
  	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
		[device lockForConfiguration:nil];
		if ( [device hasTorch] ) {
			if ( aStatus ) {
				[device setTorchMode:AVCaptureTorchModeOn];
			} else {
				[device setTorchMode:AVCaptureTorchModeOff];
			}
		}
		[device unlockForConfiguration];
}

- (void) focus:(CGPoint) aPoint;
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if([device isFocusPointOfInterestSupported] &&
       [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        double screenWidth = screenRect.size.width;
        double screenHeight = screenRect.size.height;
        double focus_x = aPoint.x/screenWidth;
        double focus_y = aPoint.y/screenHeight;
        if([device lockForConfiguration:nil]) {
            if([self.delegate respondsToSelector:@selector(scanViewController:didTapToFocusOnPoint:)]) {
                [self.delegate scanViewController:self didTapToFocusOnPoint:aPoint];
            }
            [device setFocusPointOfInterest:CGPointMake(focus_x,focus_y)];
            [device setFocusMode:AVCaptureFocusModeAutoFocus];
            if ([device isExposureModeSupported:AVCaptureExposureModeAutoExpose]){
                [device setExposureMode:AVCaptureExposureModeAutoExpose];
            }
            [device unlockForConfiguration];
        }
    }
}

#pragma mark -
#pragma mark AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    __block UIImage *scannedImg = nil;
    // Take an image of the face and pass to CoreImage for detection
    AVCaptureConnection *stillConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if(error) {
            NSLog(@"There was a problem");
            return;
        }
        
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
        scannedImg = [UIImage imageWithData:jpegData];
        NSLog(@"scannedImg : %@",scannedImg);
    }];
    
    
    [self stopScanning];
    
    for(AVMetadataObject *current in metadataObjects)
    {
        if([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            if([self.delegate respondsToSelector:@selector(scanViewController:didSuccessfullyScan:andImage:)])
            {
                NSString *scannedValue = [((AVMetadataMachineReadableCodeObject *) current) stringValue];
                [self.delegate scanViewController:self didSuccessfullyScan:scannedValue andImage:scannedImg];
            }
        }
    }
}

@end
