//
//  PartyDataController.h
//  UCup
//
//  Created by Dominic Ong on 12/27/13.
//  Copyright (c) 2013 DTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Party;

@interface PartyDataController : NSObject

@property (nonatomic, copy) NSMutableArray *masterPartyList;

-(NSUInteger) countOfList;
-(Party *)objectInListAtIndex:(NSUInteger) theIndex;
-(void) addParty:(Party *) party;
-(void) clearParties;

@end
