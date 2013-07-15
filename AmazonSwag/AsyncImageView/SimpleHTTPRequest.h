//
//  SimpleHTTPRequest.h
//  SimpleHTTPRequest
//
//  Created by Nicolas Goles on 10/12/11.
//  Modified by Semenyuk Dmitriy on 10/26/12.
//  Licensed under the MIT license
//

#import <Foundation/Foundation.h>

@interface SimpleHTTPRequest : NSObject

// TODO: sending files

+ (NSMutableURLRequest *) multipartRequestWithURL:(NSURL *)url andMethod:(NSString *)HTTPMethod andDataDictionary:(NSDictionary *) dictionary;
+ (NSMutableURLRequest *) urlencodedRequestWithURL:(NSURL *)url andMethod:(NSString *)HTTPMethod andDataDictionary:(NSDictionary *) dictionary;

@end
