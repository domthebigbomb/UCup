//
//  FoodDetailViewController.m
//  UCup
//
//  Created by Dominic Ong on 1/12/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import "FoodDetailViewController.h"
#import "LocationHandler.h"
#import "Business.h"
@interface FoodDetailViewController()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIImageView *businessImage;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityStateZipLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
- (IBAction)openDirections:(UIButton *)sender;

@end

@implementation FoodDetailViewController{
    CLLocationDegrees lat;
    CLLocationDegrees lon;
    BOOL mapLoaded;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [[LocationHandler getSharedInstance]setDelegate:self];
    mapLoaded = NO;
    [_phoneButton setTitle:[_business getPhone]forState:UIControlStateNormal];
    UIImage *businessPic = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_business getImageUrl]]]];
    UIImage *ratingImg = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_business getRatingUrlWithSize:@"large"]]]];
    [_businessImage setImage:businessPic];
    [_ratingImage setImage:ratingImg];
    [_distanceLabel setText:[NSString stringWithFormat:@"Distance: %.2f miles",[_business getDistance]]];
    [_nameLabel setText:[_business getName]];
    [_streetLabel setText:[_business getStreet]];
    [_cityStateZipLabel setText:[_business getCityStateZip]];
    [self loadInternalMap:YES];
    _mapView.delegate = self;
}

-(void)loadInternalMap:(BOOL)isInternal{
    Class mapItemClass = [MKMapItem class];
    if(mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]){
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        NSString *mapString = [NSString stringWithFormat:@"%@ , %@",[_business getStreet],[_business getCityStateZip]];
        [geocoder geocodeAddressString:mapString completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *geocodedPlacemark = [placemarks objectAtIndex:0];
            MKPlacemark *placemark = [[MKPlacemark alloc]
                                      initWithCoordinate:geocodedPlacemark.location.coordinate
                                      addressDictionary:geocodedPlacemark.addressDictionary];

            MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
            [mapItem setName:[_business getName]];
            [mapItem setPhoneNumber:[_business getPhone]];
            
            NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
            
            MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
            
            if(!isInternal){
                [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem] launchOptions:launchOptions];
            }else{
                [_mapView addAnnotation: placemark];
            }
        }];
        
    }

}

-(void) didUpdateLocations:(NSArray *)locations{
    if(!mapLoaded){
        CLLocationCoordinate2D center = [[locations lastObject] coordinate];
        //Convert miles back into meters
        NSUInteger dist = 3*[_business getDistance] / .000621371;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, dist, dist);
        [_mapView setRegion:region];
        mapLoaded = YES;
    }
}

- (IBAction)phoneButton:(UIButton *)sender {
    UIDevice *device = [UIDevice currentDevice];
    if([[device model] isEqualToString:@"iPhone"]){
        NSString *phoneNum = [NSString stringWithFormat:@"tel:%@",[_phoneButton currentTitle]];
        phoneNum = [phoneNum stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
        NSURL *phoneUrl = [NSURL URLWithString:phoneNum];
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
}
- (IBAction)openDirections:(UIButton *)sender {
    [self loadInternalMap:NO];
    }
@end
