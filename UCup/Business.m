//
//  Business.m
//  UCup
//
//  Created by Dominic Ong on 1/10/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import "Business.h"

@implementation Business{
    NSMutableDictionary *objectProperties;
}

-(id)init{
    return [super init];
}

-(id)initWithProperties:(NSDictionary *)properties{
    objectProperties = [properties copy];
    return self;
}

-(NSDictionary *)getObject{
    return objectProperties;
}

-(NSString *)getName{
    return [objectProperties valueForKey:@"name"];
}

-(NSString *)getImageUrl{
    return [objectProperties valueForKey:@"image_url"];
}

-(NSString *)getRatingUrlWithSize:(NSString *)size{
    if([size isEqualToString:@"large"]){
        // 166x30
        return [objectProperties valueForKey: @"rating_img_url_large"];
    }else if([size isEqualToString:@"small"]){
        // 50x10
        return [objectProperties valueForKey: @"rating_img_url_small"];
    }else{
        // 84x17
        return [objectProperties valueForKey:@"rating_img_url"];
    }
}

-(NSString *)getPhone{
    NSString *phoneNum = [objectProperties valueForKey:@"display_phone"];
    //format to look like a regular number
    //phoneNum = [NSString stringWithFormat:@"(%@)-"]
    return phoneNum;
}

-(NSString *)getStreet{
    NSDictionary *location = [objectProperties valueForKey:@"location"];
    NSArray *displayAddress = [location valueForKey:@"display_address"];
    NSString *addressString = [NSString stringWithFormat:@"%@",[displayAddress firstObject]];
    return addressString;
}

-(NSString *)getCityStateZip{
    NSDictionary *location = [objectProperties valueForKey:@"location"];
    NSArray *displayAddress = [location valueForKey:@"display_address"];
    NSString *cityStateZip = [NSString stringWithFormat:@"%@",[displayAddress lastObject]];
    return cityStateZip;
}

-(double)getDistance{
    NSNumber *Distance = [objectProperties valueForKey:@"distance"];
    double meterToMiles = .000621371;
    double numericalDistance = [Distance doubleValue];
    numericalDistance *= meterToMiles;
    return numericalDistance;
}

@end
