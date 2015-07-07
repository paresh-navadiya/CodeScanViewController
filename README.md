# CodeScanViewController
It scans Barcode and QRCode using AVFoundation

How to use it?

1) Add  PNScanViewController.h and PNScanViewController.m file in your project

2) #import "PNScanViewController.h" 

3)  Create PNScanViewController's instance 

    PNScanViewController *objPNScanViewController = [[PNScanViewController alloc]init];
    objPNScanViewController.delegate = self;
    [self presentViewController:objPNScanViewController animated:YES completion:nil];

4) Add delegate methods

    - (void) scanViewController:(PNScanViewController *) aCtler didTapToFocusOnPoint:(CGPoint) aPoint
    {
       NSLog(@"didTapToFocusOnPoint : %@",NSStringFromCGPoint(aPoint));
    }
    
    - (void) scanViewController:(PNScanViewController *) aCtler didSuccessfullyScan:(NSString *) aScannedValue andImage:(UIImage *)scannedImage;
    {
       //set values in UILabel and image in UIImageView
       scannedDisplayTextView.text = aScannedValue;
       scannerDisplayImgView.image = scannedImage;
    
       [aCtler dismissViewControllerAnimated:YES completion:nil];
    }
   

