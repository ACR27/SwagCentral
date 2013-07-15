//
//  UploadViewController.h
//  AmazonSwag
//
//  Created by Rao, Amar on 7/11/13.
//  Copyright (c) 2013 Rao, Amar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSURLConnectionDelegate>

@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@property (nonatomic, retain) IBOutlet UIButton* next;


- (IBAction) showCameraUI;


@end

