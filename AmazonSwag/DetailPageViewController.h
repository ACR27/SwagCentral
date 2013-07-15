//
//  DetailPageViewController.h
//  AmazonSwag
//
//  Created by Rao, Amar on 7/11/13.
//  Copyright (c) 2013 Rao, Amar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailPageViewController : UIViewController

@property(nonatomic, retain) IBOutlet UIImageView* productImage;
@property(nonatomic) UIImage* image;

//Swag Info
@property(nonatomic, retain) IBOutlet UIImageView * profileImageView;
@property(nonatomic, retain) IBOutlet UILabel* commentLabel;
@property(nonatomic, retain) IBOutlet UILabel* usernameLabel;

@property(nonatomic, retain) UIImage * profileImage;
@property(nonatomic, retain) NSString* comment;
@property(nonatomic, retain) NSString* username;

@property(nonatomic, retain) NSString* url;

- (IBAction)goToAmazon:(id)sender;




@end
