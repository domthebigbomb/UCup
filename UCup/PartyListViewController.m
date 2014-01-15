//
//  PartyListViewController.m
//  UCup
//
//  Created by Dominic Ong on 12/28/13.
//  Copyright (c) 2013 DTech. All rights reserved.
//

#import "PartyListViewController.h"
#import "PartyDataController.h"
#import "Party.h"
#import "PartyDetailViewController.h"
#import <Firebase/Firebase.h>

@implementation PartyListViewController{
    NSString *partyListUrl;
    Firebase *partyListSession;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.dataController = [[PartyDataController alloc] init];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [partyListSession removeAllObservers];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    partyListUrl = @"https://ucup-party-list.firebaseio.com/";
    
    partyListSession = [[Firebase alloc] initWithUrl:partyListUrl];
    
    [partyListSession observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        [_dataController clearParties];
        [[self tableView] reloadData];
        NSArray *partyList = (NSArray *)snapshot.value;
        Party *partyToInsert;
        for(NSString *partyName in partyList){
            NSDictionary *party= [partyList valueForKey: partyName];
            partyToInsert = [[Party alloc]initWithName:[party objectForKey:@"Party Name"] location:[party objectForKey:@"Location"] cost:[party objectForKey:@"Cost"] partyTime:[party objectForKey:@"Time Of Party"] numberOfGuestsAllowed:[[party objectForKey:@"Num Guests"] integerValue] isPublic:[[party objectForKey:@"Room Is Private"] boolValue]];
            [_dataController addParty:partyToInsert];
        }
        [[self tableView] reloadData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataController countOfList];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"PartyListingCell";
    static NSDateFormatter *formatter = nil;
    if(formatter == nil){
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:
         NSDateFormatterMediumStyle];
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Party *partyAtIndex = [_dataController objectInListAtIndex:indexPath.row];
    
    [[cell textLabel] setText: partyAtIndex.partyName];
    [[cell detailTextLabel] setText:[NSString stringWithFormat:@"Location: %@  Cost: %@",partyAtIndex.location, partyAtIndex.cost]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowPartyDetails"]) {
        PartyDetailViewController *detailViewController = [segue destinationViewController];
        int row = [self.tableView indexPathForSelectedRow].row;
        detailViewController.party = [_dataController objectInListAtIndex:row];
    }
}



@end
