# CodeScanViewController
It scans Barcode and QRCode using AVFoundation

How to use it?

1) Add files in your project :

    PNScanViewController.h and PNScanViewController.m

2) import file

    #import "PNScanViewController.h" 

3)  Create PNScanViewController's instance 

    PNScanViewController *objPNScanViewController = [[PNScanViewController alloc]init];
    objPNScanViewController.delegate = self;
    [self presentViewController:objPNScanViewController animated:YES completion:nil];

4) Add delegate methods

    - (void) scanViewController:(PNScanViewController *) scanController didTapToFocusOnPoint:(CGPoint) aPoint
    {
       NSLog(@"didTapToFocusOnPoint : %@",NSStringFromCGPoint(aPoint));
    }
    
    - (void) scanViewController:(PNScanViewController *) scanController didSuccessfullyScan:(NSString *) aScannedValue andImage:(UIImage *)scannedImage;
    {
       //set values in UILabel and image in UIImageView
       scannedDisplayTextView.text = aScannedValue;
       scannerDisplayImgView.image = scannedImage;
    
       [scanController dismissViewControllerAnimated:YES completion:nil];
    }

5) Can make necessary changes for UI in createBarUI method in PNScanViewController.m
 
   Hide TopBarView 
   Change TopBarView background
   Change title label's text color, font'
   Change back image as you like
   

