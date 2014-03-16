//
//  POIObject.h
//  CityHop
//
//  Created by Sumedha Pramod on 3/10/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POIObject : NSObject

@property (strong, nonatomic) NSString *venueID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSNumber *distance;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) NSString *imageURL;

- (POIObject *) initWithObject:(NSDictionary *) obj;

@end
