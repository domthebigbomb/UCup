//
//  FoodViewController.m
//  UCup
//
//  Created by Dominic Ong on 1/6/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import "FoodViewController.h"

@implementation FoodViewController{
    NSMutableData *_responseData;
}

- (void)tearDown {
    _responseData = nil;
}

-(void)viewDidLoad{
    NSURL *URL = [NSURL URLWithString:@"http://api.yelp.com/v2/search?term=restaurants&ll=38.990061,-76.936031"];

    /*
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:@"VyulooMDz3bBe4QZXFNIaQ" secret:@"r28CBYrMixYLqH1NQC2NkJQ78HU"];
    OAToken *token = [[OAToken alloc] initWithKey:@"IZu11-rYwtDIfhs0PxT7B2vzTxVLplzX" secret:@"whBvqmxSfXbxGBeCQww-gGzYj3k"];
    id<OASignatureProviding, NSObject> provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
    NSString *realm = nil;
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:URL
                                                                   consumer:consumer
                                                                      token:token
                                                                      realm:realm
                                                          signatureProvider:provider];
    [request prepare];
    
    _responseData = [[NSMutableData alloc] init];
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:URL];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
     */
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [_responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error: %@, %@", [error localizedDescription], [error localizedFailureReason]);
}
@end
