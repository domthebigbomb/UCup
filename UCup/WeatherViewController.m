//
//  WeatherViewController.m
//  UCup
//
//  Created by Dominic Ong on 1/28/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import "WeatherViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationHandler.h"
#import <YAJL/YAJL.h>
#import <QuartzCore/QuartzCore.h>
@interface WeatherViewController ()
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *realFeelLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UIImageView *weatherbugLogo;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property UIAlertView *alertMsg;

@end

@implementation WeatherViewController{
    NSMutableData *hourlyResponseData;
    NSMutableData *currentResponseData;
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
    [_realFeelLabel setAlpha: 0];
    [_weatherImage setAlpha: 0];
    [_weatherbugLogo setAlpha: 0];
    
    [[LocationHandler getSharedInstance] setDelegate:self];
    [[LocationHandler getSharedInstance] startUpdating];
    
    _clientID = @"anJbxEAY6UybzfK2fLWek";
    _secretKey = @"NgQpiLANOTDM3cMuZiQBjjsPJ7iuECywwGhb7xJH";
    _appKey = @"as5v68q6z4brszucn3db2hpq";
    locationFound = NO;
    [self checkLocationEnabled];
    
}

-(void)checkLocationEnabled{
    if(![CLLocationManager locationServicesEnabled]){
        _alertMsg = [[UIAlertView alloc] initWithTitle:@"Oh no!" message:@"Please enable location services in your settings." delegate:nil cancelButtonTitle:@"Will do!" otherButtonTitles: nil];
        [_alertMsg show];
        //[self performSelector:@selector(checkLocationEnabled)];
    }
}

-(void)didUpdateLocations:(NSArray *)locations{
    lat = [[locations lastObject] coordinate].latitude;
    lon = [[locations lastObject] coordinate].longitude;
    if(lat != 0){
        [[LocationHandler getSharedInstance] stopUpdating];
        [self refreshWeather];
    }
}

-(void)refreshWeather{
        NSString *forecastUrlString = [NSString stringWithFormat:@"http://i.wxbug.net/REST/Direct/GetForecastHourly.ashx?la=%f&lo=%f&ht=t&ht=i&ht=d&api_key=%@",lat,lon,_appKey];
        NSString *currentForecastUrlString = [NSString stringWithFormat:@"http://i.wxbug.net/REST/Direct/GetObs.ashx?la=%f&lo=%f&&ic=1&api_key=%@",lat,lon,_appKey];
        NSURL *currentForecastUrl = [NSURL URLWithString:currentForecastUrlString];
        NSURL *forecastURL = [NSURL URLWithString:forecastUrlString];
        currentResponseData = [[NSMutableData alloc] init];
        hourlyResponseData = [[NSMutableData alloc] init];
        NSURLRequest *currentRequest = [NSURLRequest requestWithURL:currentForecastUrl];
        NSURLRequest *hourlyRequest = [NSURLRequest requestWithURL:forecastURL];
        
        [NSURLConnection sendAsynchronousRequest:currentRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            [currentResponseData appendData:data];
            NSLog(@"Current Response: %@", response);
            NSLog(@"Current Error: %@", connectionError);
            id JSON = [currentResponseData yajl_JSON];
            currentForecast = [[NSArray alloc]initWithObjects:[JSON objectForKey:@"temperature"],[JSON objectForKey:@"feelsLike"],nil];
            NSString *iconURLString = [NSString stringWithFormat:@"http://img.weather.weatherbug.com/forecast/icons/localized/250x210/en/trans/%@.png",[JSON objectForKey:@"icon"]];
            
            UIImage *iconImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:iconURLString]]];
            [_temperatureLabel setText:[NSString stringWithFormat:@"%@",[JSON objectForKey:@"temperature"]]];
            [_tempDescriptionLabel setText:[NSString stringWithFormat:@"%@",[JSON objectForKey:@"desc"]]];
            [_realFeelLabel setText:[NSString stringWithFormat:@"Feels like: %@",[JSON objectForKey:@"feelsLike"]]];
            [_weatherImage setImage:iconImage];
            [_activityIndicator stopAnimating];

            [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [_tempHeaderLabel setAlpha:.75];
                [_temperatureLabel setAlpha:.75];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    [_tempHeaderLabel setAlpha: 1];
                    [_temperatureLabel setAlpha:1];
                    [_tempDescriptionLabel setAlpha:.75];
                    [_realFeelLabel setAlpha:.75];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        [_tempDescriptionLabel setAlpha:1];
                        [_realFeelLabel setAlpha:1];
                        [_weatherImage setAlpha:1];
                    } completion:^(BOOL finished) {
                    }];
                }];
            }];
            
            NSLog(@"Current Weather JSON: %@", [JSON yajl_JSONStringWithOptions:YAJLGenOptionsBeautify indentString:@"  "]);
        }];
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [_weatherbugLogo setAlpha:1];
        } completion:^(BOOL finished) {
        }];
    
    /* Currently disabled due to weatherbug api limitations
        [NSURLConnection sendAsynchronousRequest:(NSURLRequest *) hourlyRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            [hourlyResponseData appendData:data];
            NSLog(@"Hourly Response: %@", response);
            NSLog(@"Hourly Error: %@", connectionError);
            id JSON = [[hourlyResponseData yajl_JSON] objectForKey:@"forecastHourlyList"];
            //hourlyForecast = [[NSArray alloc] initWithObjects:<#(id), ...#>, nil]
            NSLog(@"Hourly Weather JSON: %@", [JSON yajl_JSONStringWithOptions:YAJLGenOptionsBeautify indentString:@"  "]);
            // To be finished...
        }];
     
    */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
