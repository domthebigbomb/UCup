//
//  PartyDetailViewController.m
//  UCup
//
//  Created by Dominic Ong on 12/28/13.
//  Copyright (c) 2013 DTech. All rights reserved.
//

#import "PartyDetailViewController.h"
#import "Party.h"
#import <MapKit/MapKit.h>

@interface PartyDetailViewController()
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UILabel *numGuestsLabel;
@property (weak, nonatomic) IBOutlet UILabel *privacyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
-(void) configureView;
@end

@implementation PartyDetailViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    _navigationBar.title = [NSString stringWithFormat:@"%@ Details", _party.partyName];
    [self configureView];
    //[[LocationHandler getSharedInstance]setDelegate:self];
    //[[LocationHandler getSharedInstance]startUpdating];
    mapView.delegate = self;
    mapView.mapType = MKMapTypeStandard;
    [self.view addSubview:mapView];
    
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

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
@end
