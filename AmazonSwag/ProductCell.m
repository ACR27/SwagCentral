//
//  ProductCell.m
//  AmazonSwag
//
//  Created by Rao, Amar on 7/14/13.
//  Copyright (c) 2013 Rao, Amar. All rights reserved.
//

#import "ProductCell.h"

@implementation ProductCell
@synthesize commentLabel, dateLabel, imageView, goToCart;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
