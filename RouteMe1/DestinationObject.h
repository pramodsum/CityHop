//
//  DestinationObject.h
//  RouteMe1
//
//  Created by Adam Oxner on 2/15/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "POIObject.h"

@interface DestinationObject : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSNumber *destID;
@property (nonatomic, strong) NSMutableArray *activities;

- (void) addVenue:(POIObject *) venue;

@end
