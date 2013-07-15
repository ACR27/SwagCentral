//
//  AMZNGetProfileDelegate.m
//  AmazonSwag
//
//  Created by Rao, Amar on 7/12/13.
//  Copyright (c) 2013 Rao, Amar. All rights reserved.
//

#import "AMZNGetProfileDelegate.h"

@implementation AMZNGetProfileDelegate

- (id)initWithParentController:(LoginViewController*)aViewController {
    if(self = [super init]) {
        parentViewController = aViewController;
    }
    
    return self;
}

-(void)requestDidFail:(APIError *)errorResponse {
    
}

-(void)requestDidSucceed:(APIResult *)apiResult {
    // Get profile request succeded. Unpack the profile information
    // and pass it to the parent view controller
    
    NSString* name = [(NSDictionary*)apiResult objectForKey:@"name"];
    NSString* email = [(NSDictionary*)apiResult objectForKey:@"email"];
    NSString* user_id = [(NSDictionary*)apiResult objectForKey:@"user_id"];
    NSString* postal_code = [(NSDictionary*)apiResult objectForKey:@"postal_code"];
    
    // Pass data to view controller
}

@end
