//
//  ProductCell.h
//  AmazonSwag
//
//  Created by Rao, Amar on 7/14/13.
//  Copyright (c) 2013 Rao, Amar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@property (nonatomic, retain) IBOutlet UILabel* dateLabel;
@property (nonatomic, retain) IBOutlet UILabel* commentLabel;
@property (nonatomic, retain) IBOutlet UIButton* goToCart;

@end
