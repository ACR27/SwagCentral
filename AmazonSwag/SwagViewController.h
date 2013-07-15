//
//  SwagViewController.h
//  AmazonSwag
//
//  Created by Rao, Amar on 7/11/13.
//  Copyright (c) 2013 Rao, Amar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwagViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate>

@property (nonatomic, retain) IBOutlet UISegmentedControl* swagSwitch;
@property (nonatomic, retain) IBOutlet UISearchBar* searchBar;
@property (nonatomic, retain) IBOutlet UIImageView* image;
@property (nonatomic, retain) IBOutlet UILabel* usernameLabel;
@property (nonatomic, retain) IBOutlet UILabel* pointsLabel;

@property (nonatomic, retain) IBOutlet UITableView* table;

@property (nonatomic, retain) IBOutlet NSMutableArray* mySwag;
@property (nonatomic, retain) IBOutlet NSMutableArray* swagHistory;
@property (nonatomic, retain) IBOutlet NSMutableArray* myCart;
@property (nonatomic, retain) IBOutlet NSMutableDictionary* photoMap;
@property (nonatomic, retain) NSString* cart_url;
@property (nonatomic, retain) IBOutlet UIButton * goToCart;

-(IBAction)goToCart:(id)sender;


@end
