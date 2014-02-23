//
//  CitySearch.h
//  RouteMe1
//
//  Created by Sumedha Pramod on 2/23/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>

@interface CitySearch : NSObject

-(NSArray *) search : (NSString*) searchbarText;
@property (strong, nonatomic) NSMutableArray *result;

@end
