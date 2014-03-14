//
//  POISuggestion.m
//  CityHop
//
//  Created by Sumedha Pramod on 3/13/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import "POISuggestion.h"
#import "AppDelegate.h"

@implementation POISuggestion {
    AppDelegate *appDelegate;
}

- (POISuggestion *) init {
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return self;
}

- (void) getVenues:(NSString *) city {
    city = [city stringByReplacingOccurrencesOfString:@" " withString:@"+"];

    NSString *FSclient_id = @"SCKLV2BWBLU5WABPVMCBX2V5N44H14FDWXNKIWQVXFKSLCAX",
             *FSclient_secret_key = @"SEQHGWOACYF13UDEZDFHF1QHH2RFOBEHMHE0TTHJ0L2ZTKNV";
    NSString *url = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?client_id=%@&client_secret=%@&v=20130815&near=%@&section=sights&sortByDistance=1", FSclient_id, FSclient_secret_key, city];

    NSLog(@"And the url string is: %@", url);

    NSURL *foursquareRequestURL = [NSURL URLWithString:url];

    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:foursquareRequestURL] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

        if (!error) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSArray *venues = [json objectForKey:@"groups"];

            for (NSDictionary *venue in venues) {
                NSLog(@"Venue: %@", venue);
                [appDelegate.tripManager addVenueToDestinationFromAPI:venue :city];
            }

        } else {
            NSLog(@"ERROR: %@", error);
        }
    }];
}

@end
