//
//  FoodViewController.m
//  UCup
//
//  Created by Dominic Ong on 1/6/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import "FoodViewController.h"
#import "OAuthConsumer.h"
#import "FoodDataController.h"
#import "Business.h"
#import "FoodDetailViewController.h"
#import "LocationHandler.h"
#import <CoreLocation/CoreLocation.h>
#import <YAJL/YAJL.h>

@implementation FoodViewController{
    NSMutableData *_responseData;
    NSArray *businessData;
    NSDictionary *regionData;
    OAConsumer *consumer;
    OAToken *token ;
    CLLocationDegrees lat;
    CLLocationDegrees lon;
    BOOL locationFound;
}

-(void)awakeFromNib{
    [super awakeFromNib];
}

- (void)tearDown {
    _responseData = nil;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [[LocationHandler getSharedInstance]setDelegate:self];
    consumer = [[OAConsumer alloc] initWithKey:@"VyulooMDz3bBe4QZXFNIaQ" secret:@"r28CBYrMixYLqH1NQC2NkJQ78HU"];
    token = [[OAToken alloc] initWithKey:@"IZu11-rYwtDIfhs0PxT7B2vzTxVLplzX" secret:@"whBvqmxSfXbxGBeCQww-gGzYj3k"];
    _foodController = [[FoodDataController alloc] init];
    locationFound = NO;
    
    [[self refreshControl] addTarget:self action:@selector(refreshBusinesses) forControlEvents:UIControlEventValueChanged];
    
}

-(void)didUpdateToLocation:(CLLocation *)newLocation
              fromLocation:(CLLocation *)oldLocation{
    
    lat = newLocation.coordinate.latitude;
    lon = newLocation.coordinate.longitude;
    if(locationFound == NO && lat != 0){
        locationFound = YES;
        [self refreshBusinesses];
        [[self tableView] reloadData];
    }
}

-(void)refreshBusinesses{
    if(locationFound != NO){
    NSString *urlString = [NSString stringWithFormat:@"http://api.yelp.com/v2/search?term=restaurants&sort=1&ll=%.6f,%.6f",lat,lon];
    NSURL *URL = [NSURL URLWithString:urlString];
    
    id<OASignatureProviding, NSObject> provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
    NSString *realm = nil;
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:URL
                                                                   consumer:consumer
                                                                      token:token
                                                                      realm:realm
                                                          signatureProvider:provider];
    [request prepare];
    [[self refreshControl] beginRefreshing];
    _responseData = [[NSMutableData alloc] init];

    [_foodController clearBusinesses];
    [[self tableView] reloadData];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *respData = nil;

        respData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        [_responseData appendData:respData];
        NSLog(@"Response: %@", response);
        NSLog(@"Error: %@", error);
        id JSON = [_responseData yajl_JSON];

        businessData = [[NSArray alloc]initWithArray: [JSON valueForKey:@"businesses"]];
        regionData = [[NSDictionary alloc] initWithDictionary:[JSON valueForKey:@"region"]];
        
        Business *businessToInsert;
        
        for(NSDictionary *business in businessData){
            businessToInsert = [[Business alloc] initWithProperties:business];
            [_foodController addBusiness:businessToInsert];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self tableView] reloadData];
        });
        NSLog(@"JSON: %@", [JSON yajl_JSONStringWithOptions:YAJLGenOptionsBeautify indentString:@"  "]);
        [[self refreshControl] endRefreshing];
    });
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_foodController countOfList];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = indexPath.row;
    static NSString *CellIdentifier = @"";
    UITableViewCell *cell;
    if(row == 0){
        CellIdentifier = @"Header";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }else{
        row --;
        CellIdentifier = @"BusinessCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        Business *businessAtIndex = [_foodController objectInListAtIndex:   indexPath.row];
        [[cell textLabel] setText: [[businessAtIndex getObject] valueForKey:@"name"]];
        [[cell detailTextLabel] setText:[NSString stringWithFormat:@"Distance: %.2f miles  Rating: %@",[businessAtIndex getDistance],[[businessAtIndex getObject] valueForKey:@"rating"]]];
        [[cell textLabel] setPreferredMaxLayoutWidth:282];
    }
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

-(MKCoordinateSpan)getRegionSpan{
    NSDictionary *spanDict = [regionData valueForKey:@"span"];
    NSNumber *longitude = [spanDict valueForKey:@"longitude_delta"];
    NSNumber *latitude = [spanDict valueForKey:@"latitude_delta"];
    MKCoordinateSpan span = MKCoordinateSpanMake([latitude doubleValue], [longitude doubleValue]);
    return span;
}

-(CLLocationCoordinate2D)getRegionCenter{
    NSDictionary *centerDict = [regionData valueForKey:@"center"];
    NSNumber *longitude = [centerDict valueForKey:@"longitude"];
    NSNumber *latitude = [centerDict valueForKey:@"latitude"];
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake([latitude doubleValue],[longitude doubleValue]);
    return center;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"ShowFoodDetails"]){
        FoodDetailViewController *detailViewController = [segue destinationViewController];
        int row = [self.tableView indexPathForSelectedRow].row;
        detailViewController.business = [_foodController objectInListAtIndex:row];
        
    }
}
@end
