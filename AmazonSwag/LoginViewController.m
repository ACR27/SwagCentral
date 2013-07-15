//
//  LoginViewController.m
//  AmazonSwag
//
//  Created by Rao, Amar on 7/12/13.
//  Copyright (c) 2013 Rao, Amar. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


-(IBAction)loginButtonClicked: (id) sender {
    NSLog(@"Login Button Clicked");
    // Make authorize call to SDK to get secure access token for the user.
    
    // While making the first call you can specify the minimum basic
    // scopes needed.
    
    // Requesting both scopes for the current user.
    NSArray *requestScopes = [NSArray arrayWithObjects:@"profile", @"postal_code", nil];
    
    
    [self performSegueWithIdentifier:@"login" sender:self];
    //AMZNAuthorizationDelegate* delegate = [AMZNAuthorizationDelegate alloc];
    //[AIMobileLib authorizeUserForScopes:requestScopes delegate:delegate];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
