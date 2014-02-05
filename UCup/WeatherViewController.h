//
//  WeatherViewController.h
//  UCup
//
//  Created by Dominic Ong on 1/28/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface WeatherViewController : UIViewController<CLLocationManagerDelegate,UIAlertViewDelegate>{
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) NSString *clientID;
@property (strong, nonatomic) NSString *secretKey;
@property (strong, nonatomic) NSString *appKey;
@end
