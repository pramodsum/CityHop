//
//  RouteOptimizer.h
//  CityHop
//
//  Created by Adam Oxner on 3/15/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RouteOptimizer : NSObject

@property (strong, nonatomic) NSArray *inputRoute;

- (NSArray *)optimizedRoute;

@end
