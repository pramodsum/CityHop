//
//  TripManager.m
//  RouteMe1
//
//  Created by Adam Oxner on 2/15/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import "TripManager.h"
#import "RouteOptimizer.h"

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
    
    NSLog(@"Adding %@", name);
    
    DestinationObject *d = [[DestinationObject alloc] init];
    [d setName:name];
    [d setDestID: [[NSNumber alloc] initWithLong:[self getDestIDCounter]]]; // [NSNumber numberWithLong:[self getDestIDCounter]]];
    [destinations addObject:d];
    
    return [[d destID] copy];
}

- (NSNumber *) addDestination:(DestinationObject *)destination{
    if (destinations == nil) {
        destinations = [[NSMutableArray alloc] init];
    }
    
    [destination setDestID:[NSNumber numberWithLong:[self getDestIDCounter]]];
    [destinations addObject:destination];
    
    return [[destination destID] copy];
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

- (BOOL) destinationAlreadySelected:(NSString *) name {
    for (DestinationObject *d in destinations) {
        if (d.name == name) {
            return YES;
        }
    }
    NSLog(@"Destination isn't already in itinerary found.");
    return NO;
}

// returns array of  destinations
- (NSArray *) getDestinations{
    return destinations;
}

- (NSArray *) getOptimalPath{
    RouteOptimizer *ro = [[RouteOptimizer alloc] init];
    [ro setInputRoute:destinations];
    NSMutableArray *temp = (NSMutableArray *)[ro optimizedRoute];
    
    NSDate *d = [NSDate date];
    while (temp == nil || temp.count == 0) {
        // wait :(
        
        if ([d timeIntervalSinceNow] < -10.0f) {
            // timeout
            NSLog(@"ERROR: could not optimize path- timeout.");
            return destinations;
        }
    }
    
    destinations = temp;
    return destinations;
}

- (NSInteger) destinationCount {
    return destinations.count;
}

// POI RELATED
- (void) addVenueToDestinationFromAPI:(NSDictionary *)venue :(NSString *)destination {
    
    destination = [destination stringByReplacingOccurrencesOfString:@"+" withString:@" "];

    for (DestinationObject *d in destinations) {
        if ([d.name isEqual:destination]) {
            
            POIObject *poi = [[POIObject alloc] initWithObject:venue];
            [d addVenue:poi];
            
            return;
        }
    }
    NSLog(@"Error: Venue has not been added to %@.", destination);
    return;
}

- (void) addVenueToDestination:(POIObject *)venue :(DestinationObject *)destination {
    NSInteger index = [destinations indexOfObject:destination];

    if(index == NSNotFound) {
        NSLog(@"Error: Venue has not been added to Destination."); 
        return;
    }

    POIObject *poi = [[POIObject alloc] init];
    [destinations[index] addVenue:poi];
}

- (void) addVenueToDestinationWithString:(POIObject *)venue :(NSString *)destination {

    destination = [destination stringByReplacingOccurrencesOfString:@"+" withString:@" "];

    for (int i = 0; i < destinations.count; i++) {
        if ([[destinations objectAtIndex:i] objectForKey:@"name"] == destination) {
            POIObject *poi = [[POIObject alloc] init];
            [[destinations objectAtIndex:i] addVenue:poi];
            return;
        }
    }
    NSLog(@"Error: Venue has not been added to Destination.");
    return;
}

- (void) selectVenueinDestination:(POIObject *) poi :(DestinationObject *) destination {
    NSInteger index = [destinations indexOfObject:destination];

    if(index == NSNotFound) {
        NSLog(@"Error: Venue has not been added to Destination.");
        return;
    }
    
    [destinations[index] selectVenue:poi];
}

- (void) sortVenues:(NSString *) destination {

    destination = [destination stringByReplacingOccurrencesOfString:@"+" withString:@" "];

    for (int i = 0; i < destinations.count; i++) {
        if ([[destinations objectAtIndex:i] objectForKey:@"name"] == destination) {
            [[destinations objectAtIndex:i] sortVenues];
            return;
        }
    }
    NSLog(@"Error: Destination not found.");
    return;
}

- (void) addVenueToDestinationByID:(POIObject *)venue :(NSNumber *)destinationID {
    for (DestinationObject *d in destinations) {
        if (d.destID == destinationID) {
            POIObject *poi = [[POIObject alloc] init];
            [d addVenue:poi];
            break;
        }
    }}

@end
