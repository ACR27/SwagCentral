//
//  Swag.m
//  AmazonSwag
//
//  Created by Rao, Amar on 7/12/13.
//  Copyright (c) 2013 Rao, Amar. All rights reserved.
//

#import "Swag.h"

@implementation Swag
@synthesize comment;
@synthesize asin;
@synthesize swag_id;
@synthesize photo_url;
@synthesize user_id;
@synthesize username;
@synthesize user_photo_url;
@synthesize image;
@synthesize amazon_url;

- (UIImage*) getPhoto {
    if(image == nil)
    {
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photo_url]]];
    }
    return image;
}

-(BOOL)isEqual:(id)object {
    NSLog(@"CHECKING EQUALITY");
    Swag* other = (Swag*)object;
    return swag_id == other.swag_id;
}






@end
