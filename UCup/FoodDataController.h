//
//  FoodDataController.h
//  UCup
//
//  Created by Dominic Ong on 1/10/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Business;

@interface FoodDataController : NSObject

@property (copy,nonatomic) NSMutableArray *masterFoodList;

-(NSUInteger) countOfList;
-(Business *)objectInListAtIndex:(NSUInteger) theIndex;
-(void) addBusiness:(Business *) business;
-(void) clearBusinesses;

@end
