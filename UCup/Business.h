//
//  Business.h
//  UCup
//
//  Created by Dominic Ong on 1/10/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@class YelpLocation;

@interface Business : NSObject

-(id)initWithProperties:(NSDictionary *)properties;

@property (strong, nonatomic) NSArray *businessProperties;
@property (strong, nonatomic) NSString *displayPhone;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSString *ratingImageUrlLarge;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *menuProvider;
@property (strong, nonatomic) NSString *isClaimed;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *ratingImageUrl;
@property (strong, nonatomic) NSString *isClosed;
@property (strong, nonatomic) NSString *mobileUrl;
@property (strong, nonatomic) NSString *ratingImageUrlSmall;
@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *snippetImageUrl;
@property (strong, nonatomic) NSString *snippetText;
@property (strong, nonatomic) YelpLocation *location;

@property long menuDateUpdated;
@property long reviewCount;
@property double distance;
@property double rating;

@property (strong, nonatomic) NSArray *categories;

-(NSString *)getName;
-(NSString *)getImageUrl;
-(NSString *)getRatingUrlWithSize:(NSString *)size;
-(NSString *)getPhone;
-(NSString *)getStreet;
-(NSString *)getCityStateZip;
-(double)getDistance;
//-(MKCoordinateSpan)getRegionSpan;
//-(CLLocationCoordinate2D)getRegionCenter;
-(NSDictionary *)getObject;
@end
