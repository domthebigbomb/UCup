//
//  PartyDataController.m
//  UCup
//
//  Created by Dominic Ong on 12/27/13.
//  Copyright (c) 2013 DTech. All rights reserved.
//

#import "PartyDataController.h"
#import "Party.h"

@interface PartyDataController()

-(void) initializeDefaultDataList;

@end

@implementation PartyDataController

-(void) initializeDefaultDataList{
    NSMutableArray *partyList = [[NSMutableArray alloc] init];
    _masterPartyList = partyList;
}

-(void)setMasterPartyList:(NSMutableArray *) newList{
    if(_masterPartyList != newList){
        _masterPartyList = [newList mutableCopy];
    }
}

-(Party *)objectInListAtIndex:(NSUInteger)theIndex{
    return [_masterPartyList objectAtIndex:theIndex];
}

-(void)addParty:(Party *)party{
    [_masterPartyList addObject:party];
}

-(NSUInteger)countOfList{
    return [_masterPartyList count];
}

-(id)init{
    if(self = [super init]){
        [self initializeDefaultDataList];
        return self;
    }
    return nil;
}

@end
