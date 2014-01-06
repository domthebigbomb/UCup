//
//  Party.h
//  UCup
//
//  Created by Dominic Ong on 12/27/13.
//  Copyright (c) 2013 DTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Party : NSObject

@property (strong, nonatomic) NSString *partyName;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *cost;
@property (strong, nonatomic) NSString *partyTime;
@property (strong, nonatomic) NSDate *dateCreated;
@property (strong, nonatomic) NSDate *timeUpdated;
@property (nonatomic, getter = areGuestsAllowed) BOOL guestsAllowed;
@property NSUInteger numGuests;
@property (nonatomic, getter =  isPrivate) BOOL privateRoom;

-(id) initWithName: (NSString *) partyName location:(NSString *) location
              cost:(NSString *) cost partyTime:(NSString *) partyTime numberOfGuestsAllowed:(NSUInteger) numGuestsAllowed
          isPublic:(BOOL) isPrivate;

-(NSArray *) getObject;

@end
