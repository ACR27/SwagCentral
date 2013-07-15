//
//  AMZNGetProfileDelegate.h
//  AmazonSwag
//
//  Created by Rao, Amar on 7/12/13.
//  Copyright (c) 2013 Rao, Amar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AIAuthenticationDelegate.h"
#import "LoginViewController.h"


@interface AMZNGetProfileDelegate : NSObject<AIAuthenticationDelegate> {
    LoginViewController* parentViewController;
}

- (id)initWithParentController: (LoginViewController*)aViewController;

@end
