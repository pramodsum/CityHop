//
//  DestinationObject.h
//  RouteMe1
//
//  Created by Sumedha Pramod on 2/27/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "POIObject.h"

@interface DestinationObject : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSNumber *destID;
@property (nonatomic, strong) NSMutableArray *selected_activities;

- (DestinationObject *) initObject:(NSDictionary *) place;
- (void) addVenue:(POIObject *) venue;
- (POIObject *) venueAtIndex:(NSInteger) index;
- (void) selectVenue:(POIObject *) venue;
- (void) sortVenues;

// returns array of activities
- (NSArray *) getActivities;
- (NSInteger) activitiesCount;
- (NSArray *) getSelectedActivities;
- (NSInteger) SelectedActivitiesCount;

@end
