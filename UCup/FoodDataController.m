//
//  FoodDataController.m
//  UCup
//
//  Created by Dominic Ong on 1/10/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import "FoodDataController.h"

@interface FoodDataController()

-(void)initializeDefaultDataList;

@end

@implementation FoodDataController

-(void)initializeDefaultDataList{
    NSMutableArray *businessList = [[NSMutableArray alloc] init];
    _masterFoodList = businessList;
}

-(void)setBusinessList:(NSMutableArray *)newList{
    if(_masterFoodList != newList){
        _masterFoodList = [newList mutableCopy];
    }
}

-(Business *)objectInListAtIndex:(NSUInteger)theIndex{
    return [_masterFoodList objectAtIndex:theIndex];
}

-(void)addBusiness:(Business *)business{
    [_masterFoodList addObject:business];
}

-(void)clearBusinesses{
    [_masterFoodList removeAllObjects];
}

-(NSUInteger)countOfList{
    return [_masterFoodList count];
}

-(id)init{
    if(self = [super init]){
        [self initializeDefaultDataList];
        return self;
    }
    return nil;
}

@end
