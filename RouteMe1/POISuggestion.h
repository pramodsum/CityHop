//
//  POISuggestion.h
//  CityHop
//
//  Created by Sumedha Pramod on 3/13/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface POISuggestion : NSObject

- (void) getVenues:(DestinationObject*) destination;
- (void) getVenuesWithCity:(NSString *) city;

@end
