//
//  TripManager.m
//  RouteMe1
//
//  Created by Adam Oxner on 2/15/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import "TripManager.h"

@implementation TripManager{
    NSMutableArray *destinations;
    long destIDCounter;
}

- (long) getDestIDCounter{
    if (destIDCounter == NULL) {
        destIDCounter = 0;
    }
    
    return destIDCounter++;
}

- (NSNumber *) addDestinationWithString:(NSString *)name{
    if (destinations == nil) {
        destinations = [[NSMutableArray alloc] init];
    }
    
    DestinationObject *d = [[DestinationObject alloc] init];
    [d setName:[name capitalizedString]];
    [d setDestID:[NSNumber numberWithLong:[self getDestIDCounter]]];
    [destinations addObject:d];
    
    return [d destID];
}

- (NSNumber *) addDestination:(DestinationObject *)destination{
    if (destinations == nil) {
        destinations = [[NSMutableArray alloc] init];
    }
    
    [destination setDestID:[NSNumber numberWithLong:[self getDestIDCounter]]];
    [destinations addObject:destination];
    
    return [destination destID];
}

- (void) removeDestination:(DestinationObject *)destination{
    
    if ([destination destID] != nil){
        [self removeDestinationByID:destination.destID];
    }
    
}

- (void) removeDestinationByID:(NSNumber *)destinationID{
    
    for (DestinationObject *d in destinations) {
        if (d.destID == destinationID) {
            [destinations removeObject:d];
            break;
        }
    }
    
}

// returns array of  destinations
- (NSArray *) getDestinations{
    return destinations;
}

- (NSArray *) getOptimalPath{
    
    return destinations;
}

@end
