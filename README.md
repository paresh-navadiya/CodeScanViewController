# CodeScanViewController
It scans Barcode and QRCode using AVFoundation. It also provides scanned image.

## How to use it?

1) Add files in your project :

    PNScanViewController.h and PNScanViewController.m

2) import file

    #import "PNScanViewController.h" 

3)  Create PNScanViewController's instance 

    PNScanViewController *objPNScanViewController = [[PNScanViewController alloc]init];
    objPNScanViewController.delegate = self;
    [self presentViewController:objPNScanViewController animated:YES completion:nil];

4) Add **delegate** methods

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

5) Can make necessary **changes** for **UI** in **createUI** method in **PNScanViewController.m**
 
    Hide TopBarView 
    Change TopBarView's background
    Change title label's text color or font
    Change image of back button as you like


Permission is granted to copy, distribute and/or modify this document
under the terms of the GNU Free Documentation License, Version 1.3 or
any later version published by the Free Software Foundation; with no
Invariant Sections, with no Front-Cover Texts, and with no Back-Cover
Texts.  A copy of the license is included in the "GNU Free
Documentation License" file as part of this distribution.

   

