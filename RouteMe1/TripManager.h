//
//  TripManager.h
//  RouteMe1
//
//  Created by Adam Oxner on 2/15/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DestinationObject.h"

@interface TripManager : NSObject



- (NSNumber *) addDestination:(DestinationObject *)destination;
- (NSNumber *) addDestinationWithString:(NSString *)destination;
- (void) removeDestination:(DestinationObject *)destination;
- (void) removeDestinationByID:(NSNumber *)destinationID;

// returns array of destinations
- (NSArray *) getDestinations;
- (NSArray *) getOptimalPath;

//POI related 



@end
