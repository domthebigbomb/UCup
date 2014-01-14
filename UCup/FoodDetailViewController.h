//
//  FoodDetailViewController.h
//  UCup
//
//  Created by Dominic Ong on 1/12/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@class Business;

@interface FoodDetailViewController : UIViewController<MKMapViewDelegate>
- (IBAction)phoneButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) Business *business;
@end
