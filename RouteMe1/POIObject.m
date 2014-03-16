//
//  POIObject.m
//  CityHop
//
//  Created by Sumedha Pramod on 3/10/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import "POIObject.h"

@implementation POIObject

@synthesize name = _name;
@synthesize address = _address;
@synthesize distance = _distance;
@synthesize photos = _photos;

- (POIObject *) initWithObject:(NSDictionary *) obj {
    _name = [[obj objectForKey:@"venue"] objectForKey:@"name"];
    _name = [_name stringByReplacingOccurrencesOfString:@"+" withString:@" "];

    //Not parsed properly... fixing now
    NSDictionary *loc = [obj objectForKey:@"location"];
    _distance = [loc objectForKey:@"distance"];
    _address = [_address stringByAppendingFormat:@"%@ %@, %@, %@", [loc objectForKey:@"address"], [loc objectForKey:@"city"], [loc objectForKey:@"state"], [loc objectForKey:@"country"]];

    //Images

//    NSLog(@"%@, %@, %@", _name, _address, _distance);

    return self;
}

@end
