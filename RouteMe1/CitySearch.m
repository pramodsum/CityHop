//
//  CitySearch.m
//  RouteMe1
//
//  Created by Sumedha Pramod on 2/23/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import "CitySearch.h"

@implementation CitySearch

@synthesize result;

-(NSArray *) search : (NSString*) searchbarText {
    NSMutableArray *cities = [[NSMutableArray alloc] init];
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchbarText;

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];

    //Parses MKLocalSearch response
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){

        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        //Filter out businesses from result
        NSPredicate *noBusiness = [NSPredicate predicateWithFormat:@"business.uID == 0"];
        result = [response.mapItems mutableCopy];
        [result filterUsingPredicate:noBusiness];


        //Map error
        if (error != nil) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Map Error",nil)
                                        message:[error localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
            return;
        }

        //No search results
        if ([response.mapItems count] == 0) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Results",nil)
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
            return;
        }
    }];

    for(MKMapItem *city in result) {
        [cities addObject:city.name];
    }

    //Returns list of city names based on current searchbarText
    return cities;
}

@end
