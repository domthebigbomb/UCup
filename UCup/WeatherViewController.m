//
//  WeatherViewController.m
//  UCup
//
//  Created by Dominic Ong on 1/28/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import "WeatherViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <YAJL/YAJL.h>
#import <QuartzCore/QuartzCore.h>
@interface WeatherViewController ()
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempHeaderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UIImageView *weatherbugLogo;

@end

@implementation WeatherViewController{
    NSMutableData *_responseData;
    NSArray *hourlyForecast;
    NSArray *currentForecast;
    CLLocationDegrees lat;
    CLLocationDegrees lon;
    BOOL locationFound;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_tempHeaderLabel setAlpha: 0];
    [_tempDescriptionLabel setAlpha: 0];
    [_temperatureLabel setAlpha: 0];
    [_weatherImage setAlpha: 0];
    [_weatherbugLogo setAlpha: 0];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    _clientID = @"anJbxEAY6UybzfK2fLWek";
    _secretKey = @"NgQpiLANOTDM3cMuZiQBjjsPJ7iuECywwGhb7xJH";
    _appKey = @"as5v68q6z4brszucn3db2hpq";
    locationFound = NO;

}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    lat = [[locations lastObject] coordinate].latitude;
    lon = [[locations lastObject] coordinate].longitude;
    if(locationFound == NO && lat != 0){
        locationFound = YES;
        [self refreshWeather];
        [manager stopUpdatingLocation];
    }
}

-(void)refreshWeather{
    if(locationFound != NO){
        NSString *forecastUrlString = [NSString stringWithFormat:@"http://i.wxbug.net/REST/Direct/GetForecastHourly.ashx?la=%f&lo=%f&ht=t&ht=i&ht=d&api_key=%@",lat,lon,_appKey];
        NSString *currentForecastUrlString = [NSString stringWithFormat:@"http://i.wxbug.net/REST/Direct/GetObs.ashx?la=%f&lo=%f&&ic=1&api_key=%@",lat,lon,_appKey];
        NSURL *currentForecastUrl = [NSURL URLWithString:currentForecastUrlString];
        NSURL *forecastURL = [NSURL URLWithString:forecastUrlString];
        _responseData = [[NSMutableData alloc] init];
        
        NSURLRequest *forecastRequest = [NSURLRequest requestWithURL:currentForecastUrl];
        
        [NSURLConnection sendAsynchronousRequest:forecastRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            [_responseData appendData:data];
            NSLog(@"Response: %@", response);
            NSLog(@"Error: %@", connectionError);
            id JSON = [_responseData yajl_JSON];
            currentForecast = [[NSArray alloc]initWithObjects:[JSON objectForKey:@"temperature"],[JSON objectForKey:@"feelsLike"],nil];
            NSString *iconURLString = [NSString stringWithFormat:@"http://img.weather.weatherbug.com/forecast/icons/localized/250x210/en/trans/%@.png",[JSON objectForKey:@"icon"]];
            
            UIImage *iconImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:iconURLString]]];
            [_temperatureLabel setText:[NSString stringWithFormat:@"%@",[JSON objectForKey:@"temperature"]]];
            [_tempDescriptionLabel setText:[NSString stringWithFormat:@"%@",[JSON objectForKey:@"desc"]]];
            [_weatherImage setImage:iconImage];
            
            [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [_tempHeaderLabel setAlpha:.75];
                [_temperatureLabel setAlpha:.75];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    [_tempHeaderLabel setAlpha: 1];
                    [_temperatureLabel setAlpha:1];
                    [_tempDescriptionLabel setAlpha:.75];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        [_tempDescriptionLabel setAlpha:1];
                        [_weatherImage setAlpha:1];
                    } completion:^(BOOL finished) {
                    }];
                }];
            }];
            
            NSLog(@"JSON: %@", [JSON yajl_JSONStringWithOptions:YAJLGenOptionsBeautify indentString:@"  "]);
        }];
        [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [_weatherbugLogo setAlpha:1];
        } completion:^(BOOL finished) {
        }];
        /*
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURLResponse *response = nil;
            NSError *error = nil;
            NSData *respData = nil;
            NSURLRequest *forecastRequest = [NSURLRequest requestWithURL:currentForecastUrl];
            respData = [NSURLConnection sendSynchronousRequest:forecastRequest returningResponse:&response error:&error];
            [_responseData appendData:respData];
            NSLog(@"Response: %@", response);
            NSLog(@"Error: %@", error);
            id JSON = [_responseData yajl_JSON];
            currentForecast = [[NSArray alloc]initWithObjects:[JSON objectForKey:@"temperature"],[JSON objectForKey:@"feelsLike"],nil];
            NSString *iconURLString = [NSString stringWithFormat:@"http://img.weather.weatherbug.com/forecast/icons/localized/250x210/en/trans/%@.png",[JSON objectForKey:@"icon"]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *iconImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:iconURLString]]];
                [_temperatureLabel setText:[NSString stringWithFormat:@"%@",[JSON objectForKey:@"temperature"]]];
                [_tempDescriptionLabel setText:[NSString stringWithFormat:@"%@",[JSON objectForKey:@"desc"]]];
                [_weatherImage setImage:iconImage];
                
                [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    [_tempHeaderLabel setAlpha:.75];
                    [_temperatureLabel setAlpha:.75];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        [_tempHeaderLabel setAlpha: 1];
                        [_temperatureLabel setAlpha:1];
                        [_tempDescriptionLabel setAlpha:.75];
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            [_tempDescriptionLabel setAlpha:1];
                            [_weatherImage setAlpha:1];
                        } completion:^(BOOL finished) {
                        }];
                    }];
                }];
            });
            
            
            NSLog(@"JSON: %@", [JSON yajl_JSONStringWithOptions:YAJLGenOptionsBeautify indentString:@"  "]);
        });
         */
        
        // Hourly forecast to be implemented later
        /*
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURLResponse *response = nil;
            NSError *error = nil;
            NSData *respData = nil;
            
            NSURLRequest *forecastRequest = [NSURLRequest requestWithURL:forecastURL];
            respData = [NSURLConnection sendSynchronousRequest:forecastRequest returningResponse:&response error:&error];
            [_responseData appendData:respData];
            NSLog(@"Response: %@", response);
            NSLog(@"Error: %@", error);
            id JSON = [_responseData yajl_JSON];
            hourlyForecast = [[NSArray alloc]initWithArray:[JSON objectForKey:@"forecastHourlyList"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                //[[self tableView] reloadData];
            });
            NSLog(@"JSON: %@", [JSON yajl_JSONStringWithOptions:YAJLGenOptionsBeautify indentString:@"  "]);
            NSLocale *currentLocale = [NSLocale currentLocale];
            NSDate *currentTime = [NSDate date];
            
            //[[self refreshControl] endRefreshing];
        });
        */
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
