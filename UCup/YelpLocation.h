//
//  YelpLocation.h
//  UCup
//
//  Created by Dominic Ong on 1/10/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YelpLocation : NSObject

@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *countryCode;
@property (strong, nonatomic) NSString *stateCode;
@property (strong, nonatomic) NSString *postalCode;
@property (strong, nonatomic) NSArray *address;
@property (strong, nonatomic) NSArray *displayAddress;

@end
