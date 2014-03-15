//
//  DestinationSearch.m
//  RouteMe1
//
//  Created by Sumedha Pramod on 3/7/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import "DestinationSearch.h"

@implementation DestinationSearch {
    NSMutableArray *cities;
}

- (void) autocompleteCities:(NSString *) searchText {
    cities = [[NSMutableArray alloc] init];

    NSString *kGOOGLEAPIKEY = @"AIzaSyDIsJnliy1sZ04e_vR3rEkvKC-eR07ULX4";
    searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=(cities)&sensor=false&key=%@", searchText, kGOOGLEAPIKEY];

    // NSLog(@"And the url string is: %@", url);

    NSURL *googleRequestURL = [NSURL URLWithString:url];

    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:googleRequestURL] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

        if (!error) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSArray *places = [json objectForKey:@"predictions"];

            for (NSDictionary *place in places) {
                [cities addObject:place];
            }

        } else {
            NSLog(@"ERROR: %@", error);
        }
    }];
}

- (NSArray *) getCities {
    NSLog(@"COUNT: %li", cities.count);
    return cities;
}

@end
