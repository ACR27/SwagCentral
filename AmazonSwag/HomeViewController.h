//
//  HomeViewController.h
//  AmazonSwag
//
//  Created by Rao, Amar on 7/11/13.
//  Copyright (c) 2013 Rao, Amar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.h"

@interface HomeViewController : UIViewController <UIGestureRecognizerDelegate, UIAlertViewDelegate>

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;


- (IBAction)clickLike:(id) sender;
- (IBAction)clickDislike:(id) sender;
- (IBAction)clickCart:(id) sender;


//Images
@property(nonatomic, retain)IBOutlet UIImageView * firstImage;
@property(nonatomic, retain)IBOutlet UIImageView * secondImage;

//Swag Info
@property(nonatomic, retain) IBOutlet UIImageView * profileImage;
@property(nonatomic, retain) IBOutlet UILabel* comment;
@property(nonatomic, retain) IBOutlet UILabel* username;

//Buttons
@property(nonatomic, retain)IBOutlet UIButton * like;
@property(nonatomic, retain)IBOutlet UIButton * dislike;
@property(nonatomic, retain)IBOutlet UIButton * cart;
@property(nonatomic, retain)IBOutlet UIButton * info;

@property (nonatomic, retain) NSMutableArray * swagArray;
@property (nonatomic, retain) NSMutableArray * swagIds;
@property (nonatomic, retain) NSMutableArray * photoArray;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* loader;
@property (nonatomic, retain) NSDictionary* photoMap;






@end
