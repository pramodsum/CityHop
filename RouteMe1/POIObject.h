//
//  POIObject.h
//  CityHop
//
//  Created by Sumedha Pramod on 3/10/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POIObject : NSObject

@property (strong, nonatomic) NSString *name;

- (POIObject *) initWithObject:(NSDictionary *) obj;

@end
