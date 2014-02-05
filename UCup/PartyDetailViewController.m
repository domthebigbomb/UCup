 //
//  PartyDetailViewController.m
//  UCup
//
//  Created by Dominic Ong on 12/28/13.
//  Copyright (c) 2013 DTech. All rights reserved.
//

#import "PartyDetailViewController.h"
#import "Party.h"
#import "LocationHandler.h"

@interface PartyDetailViewController()
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UILabel *numGuestsLabel;
@property (weak, nonatomic) IBOutlet UILabel *privacyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
-(void) configureView;
@end

@implementation PartyDetailViewController{
    BOOL mapLoaded;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    mapLoaded = NO;
    _navigationBar.title = [NSString stringWithFormat:@"%@ Details", _party.partyName];
    [self configureView];
    [[LocationHandler getSharedInstance]setDelegate:self];
    [[LocationHandler getSharedInstance]startUpdating];
    mapView.delegate = self;
    mapView.mapType = MKMapTypeStandard;
    [self loadInternalMap:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    _party = nil;
    mapView = nil;
    [[LocationHandler getSharedInstance] setDelegate:nil];
}
-(void)setParty:(Party *)party{
    if(_party != party){
        _party = party;
        
        [self configureView];
    }
}

-(void) configureView{
    Party *theParty = self.party;
    
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
    }
    if(theParty){
        _locationLabel.text = theParty.location;
        _costLabel.text = theParty.cost;
        _numGuestsLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)theParty.numGuests];
        _privacyLabel.text = theParty.isPrivate ? @"Yes" : @"No";
        _dateLabel.text = theParty.partyTime;
    }
}

-(void)loadInternalMap:(BOOL)isInternal{
    Class mapItemClass = [MKMapItem class];
    if(mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]){
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        NSString *mapString = [NSString stringWithFormat:@"%@",[_locationLabel text]];
        [geocoder geocodeAddressString:mapString completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *geocodedPlacemark = [placemarks objectAtIndex:0];
            MKPlacemark *placemark = [[MKPlacemark alloc]
                                      initWithCoordinate:geocodedPlacemark.location.coordinate
                                      addressDictionary:geocodedPlacemark.addressDictionary];
            
            MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
            [mapItem setName:[_party partyName]];
            
            NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
            
            MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
            
            if(!isInternal){
                [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem] launchOptions:launchOptions];
            }else{
                [mapView addAnnotation: placemark];
            }
        }];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKAnnotationView* annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                       reuseIdentifier:@"MyCustomAnnotation"];
    
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    id <MKAnnotation> annotation = view.annotation;
    CLLocationCoordinate2D coordinate = [annotation coordinate];
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    MKMapItem *mapitem = [[MKMapItem alloc] initWithPlacemark:placemark];
    MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
    mapitem.name = annotation.title;
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
    [MKMapItem openMapsWithItems:@[mapitem,currentLocationMapItem] launchOptions:launchOptions];
}

-(void) didUpdateLocations:(NSArray *)locations{
    if(!mapLoaded){
        CLLocation *center = [[CLLocation alloc] initWithLatitude:[[locations lastObject] coordinate].latitude longitude:[[locations lastObject] coordinate].longitude];
        [mapView setCenterCoordinate:[[locations lastObject] coordinate]];
        NSArray *annotations = [mapView annotations];
        id annotation = [annotations lastObject];
        if([annotation isKindOfClass:[MKUserLocation class]]){
            annotation = [annotations firstObject];
        }
        CLLocation *party = [[CLLocation alloc] initWithLatitude:[annotation coordinate].latitude longitude:[annotation coordinate].longitude];
        CLLocationDistance distance = [party distanceFromLocation:center];
        double regionDist = distance * 3.0;
        if(regionDist != 0){
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([[locations lastObject] coordinate], regionDist, regionDist);
            [mapView setRegion: region];
            [self.view addSubview:mapView];
            mapLoaded = YES;
        }
    }

}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
@end
