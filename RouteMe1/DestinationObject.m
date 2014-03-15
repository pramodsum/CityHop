//
//  DestinationObject.m
//  RouteMe1
//
//  Created by Sumedha Pramod on 2/27/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import "DestinationObject.h"

@implementation DestinationObject {
    NSMutableArray *activities;
}

@synthesize name = _name;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize destID = _destID;
//@synthesize activities = _activities;

- (DestinationObject *) initObject:(NSDictionary *) place {
    _description = [place objectForKey:@"description"];
    _name = [[[place objectForKey:@"terms"] objectAtIndex:0] objectForKey:@"value"];
    return self;
}

- (void) addVenue:(POIObject *) venue {
    if (activities == nil) {
        activities = [[NSMutableArray alloc] init];
    }

    [activities addObject:venue];
}

- (NSInteger) activitiesCount {
    return activities.count;
}

- (POIObject *) venueAtIndex:(NSInteger) index {
    return [activities objectAtIndex:index];
}

@end