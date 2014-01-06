//
//  Party.m
//  UCup
//
//  Created by Dominic Ong on 12/27/13.
//  Copyright (c) 2013 DTech. All rights reserved.
//

#import "Party.h"

@implementation Party{
    NSMutableDictionary *objectProperties;
}

-(id) initWithName:(NSString *)partyName location:(NSString *)location cost:(NSString *)cost partyTime:(NSString *) partyTime numberOfGuestsAllowed:(NSUInteger) numGuestsAllowed isPublic:(BOOL)isPrivate{
    self = [super init];
    if(self){
        objectProperties = [[NSMutableDictionary alloc] init];
        _partyName = partyName;
        [objectProperties setValue:_partyName forKey:@"Party Name"];
        _location = location;
        [objectProperties setValue:_location forKey:@"Location"];
        _cost = cost;
        [objectProperties setValue:_cost forKey:@"Cost"];
        
        /*
         Not supported currently
        _dateCreated = dateCreated;
        [objectProperties setValue:[dateCreated description] forKey:@"Date Created"];
        _timeUpdated = timeUpdated;
        [objectProperties setValue:[timeUpdated description] forKey:@"Time Updated"];
         */
        
        _partyTime = partyTime;
        [objectProperties setValue:_partyTime forKey:@"Time Of Party"];
        _numGuests = numGuestsAllowed;
        [objectProperties setValue: [NSString stringWithFormat:@"%d", _numGuests ] forKey: @"Num Guests"];
        if(_numGuests > 0){
            _guestsAllowed = YES;
            [objectProperties setValue:@"Yes" forKey:@"Guests Allowed"];
        }else{
            _guestsAllowed = NO;
            [objectProperties setValue:@"No" forKey:@"Guests Allowed"];
        }
        _privateRoom = isPrivate;
        [objectProperties setValue:[NSString stringWithFormat:@"%s", isPrivate ? "Yes":"No"] forKey:@"Room Is Private"];
        return self;
    }
    return nil;
    
}

-(NSDictionary *) getObject{
    return objectProperties;
}

@end
