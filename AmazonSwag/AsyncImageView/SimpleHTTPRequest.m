//
//  SimpleHTTPRequest.m
//  SimpleHTTPRequest
//
//  Created by Nicolas Goles on 10/12/11.
//  Modified by Semenyuk Dmitriy on 10/26/12.
//  Licensed under the MIT license
//

#import "SimpleHTTPRequest.h"

@implementation SimpleHTTPRequest

/** Creates a multipart HTTP POST request.
 *  @param url is the target URL for the POST/PUT/DELETE/PATCH request
 *  @param dictionary is a key/value dictionary with the DATA of the multipart post.
 *  
 *  Should be constructed like:
 *      NSArray *keys = [[NSArray alloc] initWithObjects:@"login", @"password", nil];
 *      NSArray *objects = [[NSArray alloc] initWithObjects:@"TheLoginName", @"ThePassword!", nil];    
 *      NSDictionary *dictionary = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
 */
+ (NSMutableURLRequest *) multipartRequestWithURL:(NSURL *)url andMethod:(NSString *)HTTPMethod andDataDictionary:(NSDictionary *) dictionary
{
    // Create POST request
    NSMutableURLRequest *mutipartPostRequest = [NSMutableURLRequest requestWithURL:url];
    [mutipartPostRequest setHTTPMethod:HTTPMethod];
    
    // Add HTTP header info
    // Note: POST boundaries are described here: http://www.vivtek.com/rfc1867.html
    // and here http://www.w3.org/TR/html4/interact/forms.html
    
    NSDate *dt = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    int timestamp = [dt timeIntervalSince1970];
    
    NSString *HTTPRequestBodyBoundary = [NSString stringWithFormat:@"BOUNDARY-%d-%@", timestamp, [[NSProcessInfo processInfo] globallyUniqueString]]; // You could calculate a better boundary here.
    [mutipartPostRequest addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", HTTPRequestBodyBoundary] forHTTPHeaderField:@"Content-Type"];
    
    // Add HTTP Body
    NSMutableData *HTTPRequestBody = [NSMutableData data];
    [HTTPRequestBody appendData:[[NSString stringWithFormat:@"--%@\r\n",HTTPRequestBodyBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Add Key/Values to the Body
    NSEnumerator *enumerator = [dictionary keyEnumerator];
    NSString *key;
    
    NSMutableArray *HTTPRequestBodyParts = [NSMutableArray array];
    
    // Collecting HTTP Request body parts
    while ((key = [enumerator nextObject])) {
        NSMutableData *someData = [[NSMutableData alloc] init];
        [someData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [someData appendData:[[NSString stringWithFormat:@"%@", [dictionary objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [HTTPRequestBodyParts addObject:someData];
//        if (key != nil) {
//            [POSTBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", HTTPRequestBodyBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        }
    }
    
    NSMutableData *resultingData = [NSMutableData data];
    NSUInteger count = [HTTPRequestBodyParts count];
    [HTTPRequestBodyParts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [resultingData appendData:obj];
        if (idx != count - 1) {
            [resultingData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", HTTPRequestBodyBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }];
    
    [HTTPRequestBody appendData:resultingData];

    
    // Add the closing -- to the POST Form
    [HTTPRequestBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", HTTPRequestBodyBoundary] dataUsingEncoding:NSUTF8StringEncoding]]; 
    
    NSLog(@"HTTP Request Body:\n %@ \n(the EOF)", [NSString stringWithUTF8String:[HTTPRequestBody bytes]]);
    
    // Add the body to the mutipartPostRequest & return
    [mutipartPostRequest setHTTPBody:HTTPRequestBody];
    return mutipartPostRequest;
}

/** Creates a form-urlencoded HTTP POST/PUT/DELETE/PATCH request.
 *  @param url is the target URL for the request
 *  @param dictionary is a key/value dictionary with the DATA of the multipart post.
 *  
 *  Should be constructed like:
 *      NSArray *keys = [[NSArray alloc] initWithObjects:@"login", @"password", nil];
 *      NSArray *objects = [[NSArray alloc] initWithObjects:@"TheLoginName", @"ThePassword!", nil];    
 *      NSDictionary *dictionary = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
 */
+ (NSMutableURLRequest *) urlencodedRequestWithURL:(NSURL *)url andMethod:(NSString *)HTTPMethod andDataDictionary:(NSDictionary *) dictionary
{
    //  Create POST request
    NSMutableURLRequest *urlencodedPostRequest = [NSMutableURLRequest requestWithURL:url];
    [urlencodedPostRequest setHTTPMethod:HTTPMethod];
    
    //  Add HTTP header info
    [urlencodedPostRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //  Add POST body
    NSMutableData *POSTBody = [NSMutableData data];
    
    //  Add k/v to the body
    NSArray *keyArray =  [dictionary allKeys];
    for (int i = 0; i < [keyArray count]; ++i) {        
        // Core Foundation function used to transform @ ==> %40 , etc
        NSString *escapedString = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, 
                                                                                                (__bridge CFStringRef)([dictionary objectForKey:[keyArray objectAtIndex:i]]),
                                                                                                NULL, 
                                                                                                (CFStringRef)@"!*'();:@&=+$,/?%#[]", 
                                                                                                kCFStringEncodingUTF8);
        
        [POSTBody appendData:[[NSString stringWithFormat:@"%@=%@", [keyArray objectAtIndex:i], escapedString] dataUsingEncoding:NSUTF8StringEncoding]];
        
        if (i < ([keyArray count] - 1)) {
            [POSTBody appendData:[[NSString stringWithFormat:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    [urlencodedPostRequest setHTTPBody:POSTBody];
    return urlencodedPostRequest;
}

@end
