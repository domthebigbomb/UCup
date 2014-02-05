//
//  LocationHandler.h
//  Map
//
//  Created by Dominic Ong on 10/22/13.
//  Copyright (c) 2013 Dominic Ong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationHandlerDelegate <NSObject>

@required
// depreceated
//-(void) didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*)oldLocation;
-(void)didUpdateLocations:(NSArray *)locations;
@end

@interface LocationHandler : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}
@property(nonatomic,strong) id<LocationHandlerDelegate> delegate;

+(id)getSharedInstance;
-(void)startUpdating;
-(void)stopUpdating;

@end