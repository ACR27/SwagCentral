//
//  SwagViewController.m
//  AmazonSwag
//
//  Created by Rao, Amar on 7/11/13.
//  Copyright (c) 2013 Rao, Amar. All rights reserved.
//

#import "SwagViewController.h"
#import "ProductCell.h"
#import "Swag.h"
#import "constants.h"

@interface SwagViewController ()

@end

@implementation SwagViewController
@synthesize swagSwitch;
@synthesize searchBar;
@synthesize image;
@synthesize usernameLabel;
@synthesize pointsLabel;
@synthesize table;
@synthesize myCart;
@synthesize goToCart;
@synthesize cart_url;

@synthesize mySwag, photoMap, swagHistory;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [table setDataSource:self];
    [table setDelegate:self];
    mySwag = [[NSMutableArray alloc] init];
    myCart = [[NSMutableArray alloc] init];
    swagHistory = [[NSMutableArray alloc] init];
    photoMap = [[NSMutableDictionary alloc] init];
    [swagSwitch addTarget:self
                         action:@selector(pickOne:)
               forControlEvents:UIControlEventValueChanged];
    [self performSelectorInBackground:@selector(getMySwag) withObject:nil];
    [self performSelectorInBackground:@selector(getLikedSwag) withObject:nil];
    [self performSelectorInBackground:@selector(getMyCart) withObject:nil];
    [self performSelectorInBackground:@selector(getUserInfo) withObject:nil];
}


//Action method executes when user touches the button
-(void) pickOne:(id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSLog(@"%d", [segmentedControl selectedSegmentIndex]);
    [goToCart setHidden:YES];
    if([segmentedControl selectedSegmentIndex] == 0) {
        [self performSelectorInBackground:@selector(getMySwag) withObject:nil];
    } else if([segmentedControl selectedSegmentIndex] == 1){
        [self performSelectorInBackground:@selector(getLikedSwag) withObject:nil];
    } else {
        [self performSelectorInBackground:@selector(getMyCart) withObject:nil];
        [goToCart setHidden:NO];
    }

}

- (IBAction)goToCart:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:cart_url]];
}

-(void) viewWillAppear:(BOOL)animated {
    [table reloadData];
    [self performSelectorInBackground:@selector(getMySwag) withObject:nil];
    [self performSelectorInBackground:@selector(getLikedSwag) withObject:nil];
    [self performSelectorInBackground:@selector(getMyCart) withObject:nil];
    [self performSelectorInBackground:@selector(getUserInfo) withObject:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"MEMMMORY WARNING");

    // Dispose of any resources that can be recreated.
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(swagSwitch.selectedSegmentIndex == 0)
        return [mySwag count];
    else if(swagSwitch.selectedSegmentIndex == 1)
        return [swagHistory count];
    else
        return [myCart count];
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCell * cell = [table dequeueReusableCellWithIdentifier:@"product_cell"];
    
    if (cell == nil){
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProductCell" owner:nil options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[ProductCell class]])
            {
                cell = (ProductCell *)currentObject;
                break;
            }
        }
    }
    
    
    Swag * swag;
    if(swagSwitch.selectedSegmentIndex == 0) {
        if([mySwag count] > [indexPath row]) {
            swag = (Swag*)[mySwag objectAtIndex:[indexPath row]];
        } else {
            [table reloadData];
        }
    }
    else if (swagSwitch.selectedSegmentIndex == 1) {
        if([swagHistory count] > [indexPath row]) {
            swag = (Swag*)[swagHistory objectAtIndex:[indexPath row]];
        } else {
            [table reloadData];
        }
    }
    else {
       
        if([myCart count] > [indexPath row]) {
            swag = (Swag*)[myCart objectAtIndex:[indexPath row]];
        }
        else {
            [table reloadData];
        }
        
    }
    
    [cell.goToCart setHidden:YES];
    cell.commentLabel.text = swag.comment;
    UIImage * img = [photoMap objectForKey:swag.photo_url];
    if(img == nil){
        cell.imageView.image = [UIImage imageNamed:@"LoadingTile.png"];
        
            [self loadImage:swag.photo_url atIndex:[indexPath row]];
        
    } else {
        cell.imageView.image = img;
    }

   
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 320;
    
}



// Load the image thumbnails for the table
-(void) loadImage:(NSString*) photo_url atIndex:(NSInteger)row{

    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(q, ^{
        NSURL *url = [NSURL URLWithString:photo_url];
        /* Fetch the image from the server... */
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            /* This is the main thread again, where we set the tableView's image to
             be what we just fetched. */
            [photoMap setValue:img forKey:photo_url];
            [table reloadData];
            //[table reloadRowsAtIndexPaths:objects withRowAnimation:UITableViewRowAnimationNone];
        });
    });
    
}


-(BOOL)getMySwag {
    NSError * error = nil;
    //NSString* user_id = @"1";
    //int page = 0;
    NSString* urlString = [NSString stringWithFormat:@"%@/getMySwag?user_id=%d", BASE_URL, CURRENT_USER];
    NSLog(@"%@",urlString);
    NSURL* url = [NSURL URLWithString:urlString];
    NSData* data = [NSData dataWithContentsOfURL:url
                                         options:0
                                           error:&error];
    
    if (data) {
        mySwag = [[NSMutableArray alloc] init];
        NSString *results = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSError *parsingError = nil;
        NSArray *JSON =
        [NSJSONSerialization JSONObjectWithData: [results dataUsingEncoding:NSUTF8StringEncoding]
                                        options: NSJSONReadingMutableContainers
                                          error: &parsingError];
        [JSON enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary* productDictionary = (NSDictionary*) obj;
            
            Swag * swag = [[Swag alloc] init];
            swag.photo_url = [productDictionary objectForKey:@"PhotoUrl"];
            if ([productDictionary objectForKey:@"Comment"] == nil ||
                [[productDictionary objectForKey:@"Comment"] isKindOfClass:[NSNull class]])
                swag.comment = @"";
            else
                swag.comment = [productDictionary objectForKey:@"Comment"];
            
            swag.asin = [productDictionary objectForKey:@"ASIN"];
            swag.swag_id = [productDictionary objectForKey:@"Id"];
            if(swag.photo_url != nil && ![swag.photo_url isKindOfClass:[NSNull class]]) {
                [mySwag addObject:swag];
            }
            
        }];
        
    }
    
    if (error) {
        NSLog(@"ERROR: %@",[error localizedDescription]);
        
    }   
    [table reloadData];
    
    return NO;
}

-(BOOL)getLikedSwag {
    NSError * error = nil;
    //NSString* user_id = @"1";
    //int page = 0;
    NSString* urlString = [NSString stringWithFormat:@"%@/getLikedSwags?user_id=%d", BASE_URL, CURRENT_USER];
    NSLog(@"%@",urlString);
    NSURL* url = [NSURL URLWithString:urlString];
    NSData* data = [NSData dataWithContentsOfURL:url
                                         options:0
                                           error:&error];
    
    if (data) {
        swagHistory = [[NSMutableArray alloc] init];
        NSString *results = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSError *parsingError = nil;
        NSArray *JSON =
        [NSJSONSerialization JSONObjectWithData: [results dataUsingEncoding:NSUTF8StringEncoding]
                                        options: NSJSONReadingMutableContainers
                                          error: &parsingError];
        [JSON enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary* productDictionary = (NSDictionary*) obj;
            
            Swag * swag = [[Swag alloc] init];
            swag.photo_url = [productDictionary objectForKey:@"PhotoUrl"];
            if ([productDictionary objectForKey:@"Comment"] == nil ||
                [[productDictionary objectForKey:@"Comment"] isKindOfClass:[NSNull class]])
                swag.comment = @"";
            else
                swag.comment = [productDictionary objectForKey:@"Comment"];
            
            swag.asin = [productDictionary objectForKey:@"ASIN"];
            swag.swag_id = [productDictionary objectForKey:@"Id"];
            if(swag.photo_url != nil && ![swag.photo_url isKindOfClass:[NSNull class]]) {
                [swagHistory addObject:swag];
            }
            
        }];
        
    }
    
    if (error) {
        NSLog(@"ERROR: %@",[error localizedDescription]);
        
    }
    [table reloadData];
    return NO;
}

-(BOOL)getMyCart {
    NSError * error = nil;
    //NSString* user_id = @"1";
    //int page = 0;
    NSString* urlString = [NSString stringWithFormat:@"%@/getCart?user_id=%d", BASE_URL, CURRENT_USER];
    NSLog(@"%@",urlString);
    NSURL* url = [NSURL URLWithString:urlString];
    NSData* data = [NSData dataWithContentsOfURL:url
                                         options:0
                                           error:&error];
    
    if (data) {
        myCart = [[NSMutableArray alloc] init];
        NSString *results = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSError *parsingError = nil;
        NSMutableDictionary *JSON =
        [NSJSONSerialization JSONObjectWithData: [results dataUsingEncoding:NSUTF8StringEncoding]
                                        options: NSJSONReadingMutableContainers
                                          error: &parsingError];
        cart_url = [JSON objectForKey:@"url"];
        NSArray* items = [JSON objectForKey:@"cart_items"];
        [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary* productDictionary = (NSDictionary*) obj;
            
            Swag * swag = [[Swag alloc] init];
            swag.photo_url = [productDictionary objectForKey:@"PhotoUrl"];
            if ([productDictionary objectForKey:@"Title"] == nil ||
                [[productDictionary objectForKey:@"Title"] isKindOfClass:[NSNull class]])
                swag.comment = @"";
            else
                swag.comment = [productDictionary objectForKey:@"Title"];
            
            swag.asin = [productDictionary objectForKey:@"ASIN"];
            swag.swag_id = [productDictionary objectForKey:@"Id"];
            if(swag.photo_url != nil && ![swag.photo_url isKindOfClass:[NSNull class]]) {
                [myCart addObject:swag];
            }
            
        }];
        
    }
    
    if (error) {
        NSLog(@"ERROR: %@",[error localizedDescription]);
        
    }
    [table reloadData];
    
    
    return NO;
}

-(BOOL)getUserInfo{
    NSError * error = nil;
    //NSString* user_id = @"1";
    //int page = 0;
    NSString* urlString = [NSString stringWithFormat:@"%@/getUserInfo?user_id=%d", BASE_URL, CURRENT_USER];
    NSLog(@"%@",urlString);
    NSURL* url = [NSURL URLWithString:urlString];
    NSData* data = [NSData dataWithContentsOfURL:url
                                         options:0
                                           error:&error];
    
    if (data) {
        swagHistory = [[NSMutableArray alloc] init];
        NSString *results = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSError *parsingError = nil;
        NSArray *JSON =
        [NSJSONSerialization JSONObjectWithData: [results dataUsingEncoding:NSUTF8StringEncoding]
                                        options: NSJSONReadingMutableContainers
                                          error: &parsingError];
        NSDictionary* productDictionary = (NSDictionary*) JSON;
        usernameLabel.text = [productDictionary objectForKey:@"Name"];
        NSNumber* points = (NSNumber*)[productDictionary objectForKey:@"Points"];
        pointsLabel.text = [NSString stringWithFormat:@"%d",[points integerValue]];
        
        
    }
    
    if (error) {
        NSLog(@"ERROR: %@",[error localizedDescription]);
        
    }
    
    
    return NO;
}




@end
