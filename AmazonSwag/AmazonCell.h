//
//  AmazonCell.h
//  AmazonSwag
//
//  Created by Rao, Amar on 7/12/13.
//  Copyright (c) 2013 Rao, Amar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AmazonCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UIImageView *productImage;
@property (nonatomic,retain) IBOutlet UILabel *nameLabel;
@property (nonatomic,retain) IBOutlet UILabel *descriptionLabel;

@property (nonatomic,retain) NSString* asin;

-(void)setThumbnailImage:(UIImage *)image;
@end
