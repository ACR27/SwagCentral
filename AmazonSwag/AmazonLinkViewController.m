//
//  AmazonLinkViewController.m
//  AmazonSwag
//
//  Created by Rao, Amar on 7/12/13.
//  Copyright (c) 2013 Rao, Amar. All rights reserved.
//

#import "AmazonLinkViewController.h"
#import "AmazonCell.h"
#import "AmazonProduct.h"
#import "constants.h"

@interface AmazonLinkViewController ()
@property (nonatomic,retain) NSString* asin;
@property (nonatomic,retain) NSString* imageId;


@end

@implementation AmazonLinkViewController

@synthesize table;
@synthesize comment;
@synthesize popup;
@synthesize search;
@synthesize finishButton;
@synthesize productArray;
@synthesize photoMap;
@synthesize amazon_product;

@synthesize userImage;
@synthesize imageId;
@synthesize asin;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated {
    
    
    if(userImage != nil) {
        [self uploadImage:userImage];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    photoMap = [[NSMutableDictionary alloc] init];
    productArray = [[NSMutableArray alloc] initWithObjects: nil];
    
    self.navigationItem.leftBarButtonItem.title = @"Back";
    self.navigationController.navigationBar.backItem.title = @"Back";
    self.navigationController.navigationBar.topItem.leftBarButtonItem.title
    = @"Back";
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view delegate methods;
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [productArray count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AmazonCell * cell = [table dequeueReusableCellWithIdentifier:@"amzn_prod"];

    if (cell == nil){
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AmazonCell" owner:nil options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[AmazonCell class]])
            {
                cell = (AmazonCell *)currentObject;
                break;
            }
        }
    }
    AmazonProduct * product = (AmazonProduct*)[productArray objectAtIndex:[indexPath row]];
    cell.nameLabel.text = product.name;
    cell.descriptionLabel.text = product.asin; // TODO Change to description
    cell.asin = product.asin;
    [cell.imageView setClipsToBounds:YES];
    UIImage * image = [photoMap objectForKey:product.thumbnail];
    if(image == nil){
        cell.imageView.image = [UIImage imageNamed:@"LoadingTile.png"];
        [self loadImage:product.thumbnail atIndex:indexPath];
    }
    else {
        cell.imageView.image = image;
    }
        
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AmazonCell* cell = (AmazonCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    amazon_product = [productArray objectAtIndex:[indexPath row]];
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    asin = cell.asin;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    [cell setSelected:YES];
    [finishButton setEnabled:YES];
    [search  resignFirstResponder];
    
    return indexPath;
}

#pragma mark - IBAction Methods

- (IBAction)showPopup:(id)sender {
    [popup setHidden:false];
    
    AmazonProduct * product = [productArray objectAtIndex:[[table indexPathForSelectedRow] row]];
    [table setUserInteractionEnabled:NO];

    asin = product.asin;

}

- (IBAction)hidePopup:(id)sender {
    [popup setHidden:true];
    [table setUserInteractionEnabled:YES];
}

- (IBAction)post:(id)sender {
    // asin
    // swag_id
    // comment
    
    if(asin != nil){
        [self createSwag];
        asin = nil;
        comment.text = @"";
        imageId = nil;
        photoMap = [[NSMutableDictionary alloc] init];
        productArray = [[NSMutableArray alloc] init];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    else {
        NSLog(@"ERRRROROROROOROROR: NO ASIN!!!!!");
    }
    
    
    NSLog(@"Post To Facebook");
}

-(BOOL)createSwag {
    NSError * error = nil;
    //NSString* user_id = @"1";
    //int page = 0;
    NSString* imageUrl = [NSString stringWithFormat:@"%@/images/%@/serve", BASE_URL, imageId];
    
    imageUrl = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* urlString = [NSString stringWithFormat:@"%@/postSwag?asin=%@&comment=%@&photo_url=%@&user_id=%d&product_url=%@",BASE_URL, asin, [comment.text stringByReplacingOccurrencesOfString:@" " withString:@"+"], imageUrl, CURRENT_USER, amazon_product.amazon_url];
    
    // DOCUMENTED BUGGGGGG   +'s now wont send
    NSLog(@"%@",urlString);
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    //[request setHTTPMethod:@"POST"];
    
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
//    NSData* data = [NSData dataWithContentsOfURL:url
//                                         options:0
//                                           error:&error];
//    
    if (data) {
        NSString *results = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Created Swag: %@", results);
    }
    
    if (error) {
        NSLog(@"ERROR: %@",[error localizedDescription]);
     
    }
    
    
    return YES;
}


#pragma mark - input delegate methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [searchBar resignFirstResponder];
    
    [self performSelectorInBackground:@selector(searchForProduct:) withObject:searchBar.text];
}

- (void) getProducts: (NSString*) searchBarText {
    
    NSString* searchText = [searchBarText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString* url = [NSString stringWithFormat:@"%@/productSearch?keywords=%@",BASE_URL, searchText];
    NSLog(@"FUCKKKK %@",url);
    //TODO get the products from the server and parse them and put them into the products array
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


-(BOOL)searchForProduct:(NSString*)searchString {
    NSError * error = nil;
    //NSString* user_id = @"1";
    //int page = 0;
    NSString* searchText = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString* urlString = [NSString stringWithFormat:@"%@/productSearch?keywords=%@", BASE_URL, searchText];
    NSLog(@"%@",urlString);
    NSURL* url = [NSURL URLWithString:urlString];
    NSData* data = [NSData dataWithContentsOfURL:url
                                         options:0
                                           error:&error];
    
    if (data) {
        productArray = [[NSMutableArray alloc] init];
        NSString *results = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSError *parsingError = nil;
        NSArray *JSON =
        [NSJSONSerialization JSONObjectWithData: [results dataUsingEncoding:NSUTF8StringEncoding]
                                        options: NSJSONReadingMutableContainers
                                          error: &parsingError];
        [JSON enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary* productDictionary = (NSDictionary*) obj;

            AmazonProduct * product = [[AmazonProduct alloc] init];
            product.asin = [productDictionary objectForKey:@"ASIN"];
            product.name = [productDictionary objectForKey:@"Title"];
            product.thumbnail = [productDictionary objectForKey:@"Image"];
            product.amazon_url = [productDictionary objectForKey:@"Url"];
            product.title = [productDictionary objectForKey:@"Title"];
            [productArray addObject:product];

        }];
        
    }
    
    if (error) {
        NSLog(@"ERROR: %@",[error localizedDescription]);

    }
    
    [finishButton setEnabled:NO];
    [table reloadData];
    
    return NO;
}

// Load the image thumbnails for the table
-(void) loadImage:(NSString*) photo_url atIndex:(NSIndexPath*)indexPath{
    if(photo_url == nil)
        return;
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
            NSArray * objects = [[NSArray alloc] initWithObjects:indexPath, nil];
            if([table numberOfRowsInSection:0])
                [table reloadRowsAtIndexPaths:objects withRowAnimation:UITableViewRowAnimationNone];
        });
    });

}



#pragma mark - Methods To upload the image

-(BOOL)uploadImage:(UIImage*)image {
    //NSString* user_id = @"1";
    //int page = 0;
    
    NSString* urlString = [NSString stringWithFormat:@"%@/images", BASE_URL];
    
    
    NSLog(@"%@",urlString);
    NSURL* requestUrl = [NSURL URLWithString:urlString];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    
    
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add image data
    NSData *imageData = UIImageJPEGRepresentation(image, 0.0);
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image[data]\";filename=\"image.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    
    // set URL
    [request setURL:requestUrl];
    NSURLResponse * response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: nil];
    
    
    NSString *results = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"ImageId: %@", results);
    imageId = results;
    
    return NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSLog(@"FUUUUUUUCKKKK UUUUU, %@", response);
    
    // cast the response to NSHTTPURLResponse so we can look for 404 etc
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    if ([httpResponse statusCode] >= 400) {
        // do error handling here
        
        NSLog(@"remote url returned error %d %@",[httpResponse statusCode],[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
    } else {
        // start recieving data
        
        
    }
}


-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    NSLog(@"Getting Data");
    NSLog(@"%@", data);
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"SOMETHING IS HAPPENING");
    NSLog(@"%@", [error localizedDescription]);
}



@end
