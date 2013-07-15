//
//  AMZNAuthorizationDelegate.m
//  AmazonSwag
//
//  Created by Rao, Amar on 7/12/13.
//  Copyright (c) 2013 Rao, Amar. All rights reserved.
//

#import "AMZNAuthorizationDelegate.h"
#import "AMZNGetProfileDelegate.h"
//#import "AIMobileLib.h"
#import "LoginViewController.h"

@implementation AMZNAuthorizationDelegate


- (id)initWithParentController:(LoginViewController*)aViewController {
    parentViewController = aViewController;
    return self;
}

-(void)requestDidFail:(APIError *)errorResponse{
    
}

-(void)requestDidSucceed:(APIResult *)apiResult {
    // Your code after the user authorizes application for
    // requested scopes.
    
    // Load new view controller with user identifying information
    // as the user is now successfully logged in.
    
    
    AMZNGetProfileDelegate* delegate = [[AMZNGetProfileDelegate alloc] initWithParentController:parentViewController];
    //[AIMobileLib getProfile:delegate];
}
@end
