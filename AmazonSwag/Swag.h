//
//  Swag.h
//  AmazonSwag
//
//  Created by Rao, Amar on 7/12/13.
//  Copyright (c) 2013 Rao, Amar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Swag : NSObject

@property (nonatomic,retain) NSString* comment;
@property (nonatomic,retain) NSString* asin;
@property (nonatomic,retain) NSString* swag_id;
@property (nonatomic,retain) NSString* photo_url;
@property (nonatomic,retain) NSString* user_id;
@property (nonatomic,retain) NSString* username;
@property (nonatomic,retain) NSString* user_photo_url;
@property (nonatomic,retain) NSString* amazon_url;
@property (nonatomic, retain) UIImage* image;

-(UIImage*) getPhoto;




@end
