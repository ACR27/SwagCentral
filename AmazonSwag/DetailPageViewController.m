//
//  DetailPageViewController.m
//  AmazonSwag
//
//  Created by Rao, Amar on 7/11/13.
//  Copyright (c) 2013 Rao, Amar. All rights reserved.
//

#import "DetailPageViewController.h"

@interface DetailPageViewController ()

@end

@implementation DetailPageViewController

@synthesize comment, profileImage, username;
@synthesize commentLabel, profileImageView, usernameLabel;
@synthesize productImage;
@synthesize image;
@synthesize url;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonSystemItemAction target:self action:nil];
        
        
    }
    return self;
}


- (IBAction)goToAmazon:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonSystemItemAction target:self action:nil];
    
    productImage.image = image;
    usernameLabel.text = username;
    commentLabel.text = comment;
    profileImageView.image = profileImage;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
