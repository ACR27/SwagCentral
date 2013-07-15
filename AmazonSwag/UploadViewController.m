//
//  UploadViewController.m
//  AmazonSwag
//
//  Created by Rao, Amar on 7/11/13.
//  Copyright (c) 2013 Rao, Amar. All rights reserved.
//

#import "UploadViewController.h"
#import "constants.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "SimpleHTTPRequest.h"
#import "AmazonLinkViewController.h"

@interface UploadViewController ()

@end





@implementation UploadViewController
@synthesize imageView;
@synthesize next;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonSystemItemAction target:self action:nil];
    
	// Do any additional setup after loading the view.

}
-(void)viewWillAppear:(BOOL)animated {
    NSLog(@"%d", self.isMovingToParentViewController);
    NSLog(@"%d", self.navigationController.isMovingToParentViewController);
    if (self.isMovingToParentViewController == YES)
    {
        imageView.image = [UIImage imageNamed:@"DefaultTile.png"];
        
        // we're already on the navigation stack
        // another controller must have been popped off
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"next"]) {
        AmazonLinkViewController *controller = (AmazonLinkViewController *)segue.destinationViewController;
        controller.userImage = imageView.image;
    }
    
}




#pragma mark - Camera Shit

- (IBAction) showCameraUI {
    [self startCameraControllerFromViewController: self
                                    usingDelegate: self];
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
       if (
         (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    //cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        cameraUI.mediaTypes =
        [UIImagePickerController availableMediaTypesForSourceType:
         UIImagePickerControllerSourceTypePhotoLibrary];
    }
    else
    {
        cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        cameraUI.mediaTypes =
        [UIImagePickerController availableMediaTypesForSourceType:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = YES;
    
    cameraUI.delegate = delegate;
    
    [controller presentViewController:cameraUI animated:YES completion:^{
        
    }];

    return YES;
}


- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToUse;
    
    // Handle a still image picked from a photo album
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToUse = editedImage;
        } else {
            imageToUse = originalImage;
        }
        // Do something with imageToUse
    }
    
    // Handle a movied picked from a photo album
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo) {
        
        //NSString *moviePath = [[info objectForKey:
                               // UIImagePickerControllerMediaURL] path];
        
        // Do something with the picked movie available at moviePath
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        imageView.image = imageToUse;
        
        
        
        if(imageView.image != nil) {
            [next setEnabled:YES];
        }
    }];
}




@end



