//
//  SPArrayExtensions.m
//  UCup
//
//  Created by Dominic Ong on 12/31/13.
//  Copyright (c) 2013 DTech. All rights reserved.
//

#import "SPArrayExtensions.h"

@implementation NSArray (SPArrayExtensions)

+(void)initialize {
    srandom((unsigned int)time(NULL));
}

-(id)randomObject {
	
	if ([self count] == 0)
		return nil;
	
	NSUInteger index = random() % [self count];
	
	if (index <= ([self count] - 1)) {
		return [self objectAtIndex:index];
	} else {
		return nil;
	}
	
}

@end
