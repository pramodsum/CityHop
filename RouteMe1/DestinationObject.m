//
//  DestinationObject.m
//  RouteMe1
//
//  Created by Adam Oxner on 2/15/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import "DestinationObject.h"

@implementation DestinationObject

@synthesize name = _name;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize destID = _destID;
@synthesize activities = _activities;

- (void) addVenue:(POIObject *) venue {
    if (_activities == nil) {
        _activities = [[NSMutableArray alloc] init];
    }

    [_activities addObject:venue];
}

@end