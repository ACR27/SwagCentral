//
//  AmazonLinkViewController.h
//  AmazonSwag
//
//  Created by Rao, Amar on 7/12/13.
//  Copyright (c) 2013 Rao, Amar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AmazonProduct.h"

@interface AmazonLinkViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UISearchBarDelegate, NSURLConnectionDelegate>

@property (nonatomic, retain) IBOutlet UITableView * table;
@property (nonatomic, retain) IBOutlet UITextView * comment;
@property (nonatomic, retain) IBOutlet UISearchBar * search;
@property (nonatomic, retain) IBOutlet UIView * popup;
@property (nonatomic, retain) IBOutlet UIButton * finishButton;

- (IBAction)showPopup:(id)sender;
- (IBAction)hidePopup:(id)sender;
- (IBAction)post:(id)sender;

@property (nonatomic, retain) NSMutableArray * productArray;
@property (nonatomic, retain) NSMutableDictionary * photoMap;

@property (nonatomic, retain) UIImage * userImage;

@property (nonatomic, retain) AmazonProduct* amazon_product;



@end
