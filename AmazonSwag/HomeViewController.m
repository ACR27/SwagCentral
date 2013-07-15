//
//  HomeViewController.m
//  AmazonSwag
//
//  Created by Rao, Amar on 7/11/13.
//  Copyright (c) 2013 Rao, Amar. All rights reserved.
//


#import "HomeViewController.h"

#import <UIKit/UIKit.h>
#import "TouchDownGestureRecognizer.h"
#import "TouchUpGestureRecognizer.h"
#import "DetailPageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Swag.h"
#import "AsyncImageView.h"
//#import "AMZNGetAccessTokenDelegate.h"
//#import "AIMobileLib.h"

@interface HomeViewController ()

#define DEGREES_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define IMAGE_CENTER_X 160
#define IMAGE_CENTER_Y 175
#define BOUNDS 50

@property (nonatomic,retain) NSString* _base_url;
@property (nonatomic,readwrite) int _page;


@end

//////////////////////////////

@implementation HomeViewController

// Images
@synthesize firstImage, secondImage;
@synthesize comment, profileImage, username;
@synthesize loader;

@synthesize _base_url;
@synthesize _page;

// Buttons
@synthesize like, dislike, cart, info;

@synthesize swagArray, photoArray, photoMap, swagIds;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) populateImage: (NSString*) url {
    if([photoMap objectForKey:url] == nil) {
        [self performSelectorInBackground:@selector(addPhotoToMap:) withObject:url];
    }
}


-(void) populateImages {
    for (int i = 0; i < [swagArray count]; i++) {
        Swag* s = [swagArray objectAtIndex:i];
        if([photoMap objectForKey:s.photo_url] == nil) {
            [self performSelectorInBackground:@selector(addPhotoToMap:) withObject:s.photo_url];
        
        }
    }
}

-(void) addPhotoToMap:(NSString*)url {
    if([photoMap objectForKey:url] == nil) {
        UIImage *image = [self imageFromUrl:url];
        NSLog(@"Adding Photo: %@", url);
        [photoMap setValue:image forKey:url];
    }
}

-(void) setTopImage:(NSString*) photo_url{
    UIImage * image = [photoMap objectForKey:photo_url];
    if(image == nil) {
        firstImage.image = [UIImage imageNamed:@"LoadingTile.png"];
        [firstImage setUserInteractionEnabled:NO];
        
        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(q, ^{
            NSURL *url = [NSURL URLWithString:photo_url];
            /* Fetch the image from the server... */
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                /* This is the main thread again, where we set the tableView's image to
                 be what we just fetched. */
                firstImage.image = img;
                [firstImage setUserInteractionEnabled:YES];
                [photoMap setValue:img forKey:photo_url];
            });
        });
    } else {
        firstImage.image = image;
    }
}

-(void) setBottomImage:(NSString*) photo_url{
    UIImage * image = [photoMap objectForKey:photo_url];
    if(image == nil) {
        secondImage.image = [UIImage imageNamed:@"LoadingTile.png"];
        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(q, ^{
            NSURL *url = [NSURL URLWithString:photo_url];
            /* Fetch the image from the server... */
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                /* This is the main thread again, where we set the tableView's image to
                 be what we just fetched. */
                secondImage.image = img;
                [photoMap setValue:img forKey:photo_url];
            });
        });
    } else {
        secondImage.image = image;
    }
}

-(UIImage*) getSwagPhoto:(Swag*) swag {
    UIImage* image = [photoMap objectForKey:swag.photo_url];
    if(image == nil) {
        NSLog(@"fetching image from url :(");
        image = [swag getPhoto];
        
    }
    return image;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.topItem.title = @"AmazonSwag";
   
	
    swagArray = [[NSMutableArray alloc] initWithArray:nil];
    photoArray = [[NSMutableArray alloc] initWithArray:nil];
    swagIds = [[NSMutableArray alloc] initWithArray:nil];
    photoMap = [[NSMutableDictionary alloc] init];
    
    _page = 0;
    // Test hitting data
    _base_url = @"http://patrizio-1.desktop.amazon.com:3000";
    [self showLoadingIcon];
    [self performSelectorInBackground:@selector(getSwagwithPagination:) withObject:nil];
    //[self getSwagwithPagination:0];

        
    
    // Attach gesutre urls
    TouchUpGestureRecognizer *tu = [[TouchUpGestureRecognizer alloc] initWithTarget:self action:@selector(untapped:)];
    [tu setDelegate:self];
    [firstImage addGestureRecognizer:tu];
    
    TouchDownGestureRecognizer *td = [[TouchDownGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [td setDelegate:self];
    [firstImage addGestureRecognizer:td];
}

- (void) viewWillAppear:(BOOL)animated {
    if(swagArray != nil && [swagArray count] < 5)
        [self performSelectorInBackground:@selector(getSwagwithPagination:) withObject:nil];

}

#pragma mark - REquests

-(BOOL)getSwagwithPagination:(int)pagination {
    NSError * error = nil;
    //NSString* user_id = @"1";
    //int page = 0;
    NSString* urlString = [NSString stringWithFormat:@"%@/swags.json?user_id=%d",BASE_URL, CURRENT_USER];
    NSLog(@"%@",urlString);
    NSURL* url = [NSURL URLWithString:urlString];
    NSData* data = [NSData dataWithContentsOfURL:url
                                         options:0
                                           error:&error];
    
    if (data) {
        NSString *results = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSError *parsingError = nil;
        NSArray *JSON =
        [NSJSONSerialization JSONObjectWithData: [results dataUsingEncoding:NSUTF8StringEncoding]
                                        options: NSJSONReadingMutableContainers
                                          error: &parsingError];
        [JSON enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary* swagDictionary = (NSDictionary*) obj;
            
            
            Swag * swagger = [[Swag alloc] init];
            swagger.photo_url = [swagDictionary objectForKey:@"photo_url"];
            swagger.asin = [swagDictionary objectForKey:@"asin"];
            swagger.comment = [swagDictionary objectForKey:@"comment"];
            swagger.swag_id = [swagDictionary objectForKey:@"id"];
            swagger.amazon_url = [swagDictionary objectForKey:@"product_url"];
            NSLog(@"%@", swagger.swag_id);
            if(![swagger.photo_url isKindOfClass:[NSNull class]] &&
               swagger.photo_url != nil &&
               [swagger.photo_url length] > 0 &&
               ![swagIds containsObject:swagger.swag_id]) {
                [swagIds addObject:swagger.swag_id];
                [swagArray addObject:swagger];
                [self performSelectorInBackground:@selector(addPhotoToMap:) withObject:swagger.photo_url];
            }
        }];
        
    }
    
     if (error) {
        NSLog(@"ERROR: %@",[error localizedDescription]);
         
//         UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Network Error"
//                                                           message:@"Unable to connect to the server"
//                                                          delegate:self
//                                                 cancelButtonTitle:@"OK"
//                                                 otherButtonTitles:nil];
//         [message show];
//        // Get dummy data;
//        for(int i = 0; i < 10; i++) {
//            if(i % 2 == 0) {
//                Swag* s1 = [[Swag alloc] init];
//                s1.comment = [NSString stringWithFormat:@"comment:%d", i];
//                s1.photo_url = @"abcd";
//                
//                [swagArray addObject:s1];
//                [photoMap setValue:[UIImage imageNamed:@"swag1.JPG"] forKey:s1.photo_url];
//            } else {
//                Swag* s2 = [[Swag alloc] init];
//                s2.comment = [NSString stringWithFormat:@"other comment:%d", i];
//                s2.photo_url = @"def";
//                
//                [swagArray addObject:s2];
//                [photoMap setValue:[UIImage imageNamed:@"swag2.JPG"] forKey:s2.photo_url];
//                
//            }
//        }
    }
    
    [self refreshSwagList];
    
    return NO;
}








#pragma mark - Passing Data
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@", segue.identifier);
    if([segue.identifier isEqualToString:@"1"]){
        DetailPageViewController *controller = (DetailPageViewController *)segue.destinationViewController;
        if([swagArray count] > 0) {
            Swag * s = [swagArray objectAtIndex:0];
            controller.image = firstImage.image;
            controller.username = s.username;
            controller.comment = s.comment;
            controller.profileImage = [self imageFromUrl:s.user_photo_url];
            controller.url = s.amazon_url;
        }
        //TODO set comment
    }
}




#pragma mark - Guesture Recognizers


- (void)tapped:(id)sender {
    NSLog(@"Press Down");
    // Have image hover add shadow
    firstImage.layer.shadowColor = [UIColor blackColor].CGColor;
    firstImage.layer.shadowOffset = CGSizeMake(0, 3);
    firstImage.layer.shadowOpacity = 1.0;
    firstImage.layer.shadowRadius = 20.0;
}

- (void)untapped:(id)sender {
    
    // Undo shadow
    firstImage.layer.shadowColor = [UIColor clearColor].CGColor;
        
    // If the image was liked
    if(firstImage.center.x > self.view.bounds.size.width - BOUNDS) {
        NSLog(@"Like");
        [self performSelectorInBackground:@selector(postLike:) withObject:((Swag*)[swagArray objectAtIndex:0]).swag_id];
        UIImageView * newImageView = [[UIImageView alloc] initWithFrame:firstImage.frame];
        newImageView.image = firstImage.image;
        newImageView.transform = firstImage.transform;
        newImageView.bounds = firstImage.bounds;
        [self.view addSubview:newImageView];
        [firstImage setHidden:YES];
        
        [UIView animateWithDuration:0.5f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^(void) {
                             [newImageView setCenter:CGPointMake(900, IMAGE_CENTER_Y)];
                             CGAffineTransform rotationTransform = CGAffineTransformIdentity;
                             rotationTransform = CGAffineTransformRotate(rotationTransform, DEGREES_RADIANS(80));
                             newImageView.transform = rotationTransform;
                         }
                         completion:NULL];
        
        
        
        [self swapImages];
        [firstImage setBounds:CGRectMake(0, 0, firstImage.bounds.size.width, firstImage.bounds.size.height)];
        [firstImage setCenter:CGPointMake(IMAGE_CENTER_X, IMAGE_CENTER_Y)];
        [firstImage setHidden:NO];

    }
    
    
    // If the image was disliked
    else if(firstImage.center.x < BOUNDS) {
        NSLog(@"Dislike");
        [self performSelectorInBackground:@selector(postDisike:) withObject:((Swag*)[swagArray objectAtIndex:0]).swag_id];
        UIImageView * newImageView = [[UIImageView alloc] initWithFrame:firstImage.frame];
        newImageView.image = firstImage.image;
        newImageView.transform = firstImage.transform;
        [self.view addSubview:newImageView];
        newImageView.bounds = firstImage.bounds;
        [firstImage setHidden:YES];
        
        [UIView animateWithDuration:0.5f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^(void) {
                             [newImageView setCenter:CGPointMake(-900, IMAGE_CENTER_Y)];
                             CGAffineTransform rotationTransform = CGAffineTransformIdentity;
                             rotationTransform = CGAffineTransformRotate(rotationTransform, DEGREES_RADIANS(-80));
                             newImageView.transform = rotationTransform;
                         }
                         completion:NULL];
        
        
        
        [self swapImages];
        [firstImage setBounds:CGRectMake(0, 0, firstImage.bounds.size.width, firstImage.bounds.size.height)];
        [firstImage setCenter:CGPointMake(IMAGE_CENTER_X, IMAGE_CENTER_Y)];
        [firstImage setHidden:NO];

    }
    
    // If image was added to the cart
    else if(firstImage.center.y < BOUNDS)
    {
        NSLog(@"ADDDDDD TOOOOOO CAAAAAARRRTTTTTTT");
        [self performSelectorInBackground:@selector(postCart:) withObject:((Swag*)[swagArray objectAtIndex:0]).swag_id];
        UIImageView * newImageView = [[UIImageView alloc] initWithFrame:firstImage.frame];
        newImageView.image = firstImage.image;
        newImageView.transform = firstImage.transform;
        newImageView.bounds = firstImage.bounds;
        [self.view addSubview:newImageView];
        [firstImage setHidden:YES];
        
        [UIView animateWithDuration:0.5f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^(void) {
                             [newImageView setCenter:CGPointMake(IMAGE_CENTER_X, -500)];
                         }
                         completion:NULL];
        
        
        [self swapImages];
        [firstImage setBounds:CGRectMake(0, 0, firstImage.bounds.size.width, firstImage.bounds.size.height)];
        [firstImage setCenter:CGPointMake(IMAGE_CENTER_X, IMAGE_CENTER_Y)];
        [firstImage setHidden:NO];

    }
    
    // IMage was released, go back to center
    else {
        
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn
                         animations:^(void) {
                             [firstImage setBounds:CGRectMake(0, 0, firstImage.bounds.size.width, firstImage.bounds.size.height)];
                            [firstImage setCenter:CGPointMake(IMAGE_CENTER_X, IMAGE_CENTER_Y)];
                         }
                         completion:NULL];
        
        
    }
    firstImage.transform = CGAffineTransformIdentity;

    // Un-Highlight all the buttons
    [like setHighlighted:false];
    [dislike setHighlighted:false];
    [cart setHighlighted:false];
}

#pragma mark - like requests

-(BOOL)postLike:(NSString*) swag_id{
    NSLog(@"fajwfoiaewoifjiowaejfojweofjaweofj");
    NSError * error = nil;
    //NSString* user_id = @"1";
    //int page = 0;
    NSString* urlString = [NSString stringWithFormat:@"%@/postLike?user_id=%d&swag_id=%@", BASE_URL, CURRENT_USER,swag_id];
    NSLog(@"%@",urlString);
    NSURL* url = [NSURL URLWithString:urlString];
    NSData* data = [NSData dataWithContentsOfURL:url
                                         options:0
                                           error:&error];
    
    if (data) {
        NSString *results = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
    }
    
    return NO;
}

-(BOOL)postCart:(NSString*) swag_id{
    NSError * error = nil;
    //NSString* user_id = @"1";
    //int page = 0;
    NSString* urlString = [NSString stringWithFormat:@"%@/postCart?user_id=%d&swag_id=%@", BASE_URL, CURRENT_USER,swag_id];
    NSLog(@"%@",urlString);
    NSURL* url = [NSURL URLWithString:urlString];
    NSData* data = [NSData dataWithContentsOfURL:url
                                         options:0
                                           error:&error];
    
    if (data) {
        
    }
    
    return NO;
}

-(BOOL)postDisike:(NSString*) swag_id{
    NSLog(@"fajwfoiaewoifjiowaejfojweofjaweofj");
    NSError * error = nil;
    //NSString* user_id = @"1";
    //int page = 0;
    NSString* urlString = [NSString stringWithFormat:@"%@/postDislike?user_id=%d&swag_id=%@", BASE_URL, CURRENT_USER,swag_id];
    NSLog(@"%@",urlString);
    NSURL* url = [NSURL URLWithString:urlString];
    NSData* data = [NSData dataWithContentsOfURL:url
                                         options:0
                                           error:&error];
    
    if (data) {
        NSString *results = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
    }
    
    return NO;
}


- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:self.view];

    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
     [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    
    
    // Swiping to the right (Rotate Image)
    if(translation.x > 0) {
        if (firstImage.center.x > IMAGE_CENTER_X) {
            CGAffineTransform rotationTransform = CGAffineTransformIdentity;
            rotationTransform = CGAffineTransformRotate(rotationTransform, DEGREES_RADIANS(10));
            firstImage.transform = rotationTransform;
        }
        
    }
      
    // Swiping to the left (Rotate Image)
    else if(translation.x < 0) {
        if(firstImage.center.x < IMAGE_CENTER_X) {
            CGAffineTransform rt = CGAffineTransformIdentity;
            rt = CGAffineTransformRotate(rt, DEGREES_RADIANS(-10));
            firstImage.transform = rt;
        }
    }
    
    
    
    // If in LIKE territory
    if(firstImage.center.x > self.view.bounds.size.width - BOUNDS) { 
        [like setHighlighted:true];
        [dislike setHighlighted:false];
        [cart setHighlighted:false];
    }
    // If in DISLIKE territory
    else if(firstImage.center.x < BOUNDS) {
        [dislike setHighlighted:true];
        [like setHighlighted:false];
        [cart setHighlighted:false];
    }
    // If in CART territory
    else if(firstImage.center.y < BOUNDS)
    {
        [cart setHighlighted:true];
        [dislike setHighlighted:false];
        [like setHighlighted:false];
    }
    
    else {
        [like setHighlighted:false];
        [dislike setHighlighted:false];
        [cart setHighlighted:false];
    }
    
   
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (IBAction) clickCart:(id)sender {
    NSLog(@"Cart");
    
    if(!firstImage.userInteractionEnabled) {
        return;
    }
    [self performSelectorInBackground:@selector(postCart:) withObject:((Swag*)[swagArray objectAtIndex:0]).swag_id];
    UIImageView * newImageView = [[UIImageView alloc] initWithFrame:firstImage.frame];
    newImageView.image = firstImage.image;
    [self.view addSubview:newImageView];
    [self swapImages];
    
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void) {
                         [newImageView setCenter:CGPointMake(IMAGE_CENTER_X, -400)];
                     }
                     completion:NULL];
}
- (IBAction) clickLike:(id)sender {
    NSLog(@"LIKE");
    
    if(!firstImage.userInteractionEnabled) {
        return;
    }
    [self performSelectorInBackground:@selector(postLike:) withObject:((Swag*)[swagArray objectAtIndex:0]).swag_id];
    UIImageView * newImageView = [[UIImageView alloc] initWithFrame:firstImage.frame];
    newImageView.image = firstImage.image;
    [self.view addSubview:newImageView];
    [self swapImages];
    
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void) {
                         [newImageView setCenter:CGPointMake(900, IMAGE_CENTER_Y)];
                         CGAffineTransform rotationTransform = CGAffineTransformIdentity;
                         rotationTransform = CGAffineTransformRotate(rotationTransform, DEGREES_RADIANS(80));
                         newImageView.transform = rotationTransform;
                     }
                     completion:NULL];
}
- (IBAction) clickDislike:(id)sender {
    NSLog(@"DISLIKE");
    
    if(!firstImage.userInteractionEnabled) {
        return;
    }
    [self performSelectorInBackground:@selector(postDisike:) withObject:((Swag*)[swagArray objectAtIndex:0]).swag_id];
    UIImageView * newImageView = [[UIImageView alloc] initWithFrame:firstImage.frame];
    newImageView.image = firstImage.image;
    [self.view addSubview:newImageView];
    [self swapImages];
    
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void) {
                         [newImageView setCenter:CGPointMake(-900, IMAGE_CENTER_Y)];
                         CGAffineTransform rotationTransform = CGAffineTransformIdentity;
                         rotationTransform = CGAffineTransformRotate(rotationTransform, DEGREES_RADIANS(-80));
                         newImageView.transform = rotationTransform;
                     }
                     completion:NULL];


}

// Swaps the first and second Image
-(void) swapImages {
    NSLog(@"SWAG COUNT: %d", [swagArray count]);
    NSMutableArray* swagCopy = [[NSMutableArray alloc] initWithArray:swagArray];
    if(swagArray == nil || [swagArray count] == 0) {
        [self showLoadingIcon];
    } else if ([swagArray count] == 1) {
        [self showLoadingIcon];
        [swagArray removeObjectAtIndex:0];
    }
    else if([swagArray count] == 2) {
        Swag* swag = [swagCopy objectAtIndex:1];

        [self setTopImage:swag.photo_url];;//[photoArray objectAtIndex:1];
        comment.text = swag.comment;
        
        secondImage.image = nil;
        [loader startAnimating];
        
        [swagArray removeObjectAtIndex:0];
        //[photoArray removeObjectAtIndex:0];
    } else if ([swagArray count] >= 3){ // 3+ items
        Swag* swag1 = [swagCopy objectAtIndex:1];
        Swag* swag2 = [swagCopy objectAtIndex:2];
        
        [self setTopImage:swag1.photo_url];
        comment.text = swag1.comment;
        
        [self setBottomImage:swag2.photo_url];
        
        [swagArray removeObjectAtIndex:0];
        //[photoArray removeObjectAtIndex:0];
    }
    
    // When halfway through fetch more images. 
    if([swagArray count] <= 5) {
        [self performSelectorInBackground:@selector(getSwagwithPagination:) withObject:nil];
    }
    [self antiAliasImages];
}

- (UIImage *)transparentBorderImage:(UIImage *)image
{
    CGSize size = image.size;
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(1, 1, size.width - 2, size.height - 2)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void) showLoadingIcon {
    firstImage.image = nil;
    secondImage.image = nil;
    comment.text = @"Loading";
    [loader startAnimating];
    [firstImage setUserInteractionEnabled:NO];
}

- (void) refreshSwagList  {
    if([swagArray count] > 0) {
        Swag *swag = [swagArray objectAtIndex:0];
        [self setTopImage:swag.photo_url];//[photoArray objectAtIndex:0];
        [firstImage setUserInteractionEnabled:YES];
        comment.text = swag.comment;
        if([swagArray count] > 2) {
            Swag *swag2 = [swagArray objectAtIndex:1];
            [self setBottomImage:swag2.photo_url];
            [loader stopAnimating];
        } else {
            [loader startAnimating];
            secondImage.image = nil;
        }
    }
    
    [self antiAliasImages];
}


- (UIImage*) imageFromUrl:(NSString*)url {
    NSLog(@"url: %@", url);
    if(url == nil) {
        return nil;
    } else {
        return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    }
}

- (void) antiAliasImages{
    //Anti Alias the images
    firstImage.image = [self transparentBorderImage:firstImage.image];
    secondImage.image = [self transparentBorderImage:secondImage.image];
}


#pragma mark - Amazon login shit

//- (void)checkIsUserSignedIn {
//    AMZNGetAccessTokenDelegate* delegate = [[[AMZNGetAccessTokenDelegate alloc] initWithParentController:self] autorelease];
//    [AIMobileLib getAccessTokenForScopes:[NSArray arrayWithObject:@"profile"] withOverrideParams:nil delegate:delegate];
//}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
