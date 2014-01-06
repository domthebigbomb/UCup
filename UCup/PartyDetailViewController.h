//
//  PartyDetailViewController.h
//  UCup
//
//  Created by Dominic Ong on 12/28/13.
//  Copyright (c) 2013 DTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@class Party;

@interface PartyDetailViewController : UITableViewController<MKMapViewDelegate>{
    IBOutlet MKMapView *mapView;
}

@property (strong, nonatomic) Party *party;


@end
