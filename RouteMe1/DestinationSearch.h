//
//  DestinationSearch.h
//  RouteMe1
//
//  Created by Sumedha Pramod on 3/7/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DestinationSearch : NSObject

- (void) autocompleteCities:(NSString *) searchText;
- (NSArray *) getCities;

@end
