//
//  POIObject.m
//  CityHop
//
//  Created by Sumedha Pramod on 3/10/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import "POIObject.h"

@implementation POIObject

@synthesize venueID = _venueID;
@synthesize name = _name;
@synthesize address = _address;
@synthesize distance = _distance;
@synthesize photos = _photos;
@synthesize imageURL = _imageURL;

- (POIObject *) initWithObject:(NSDictionary *) obj {
    _name = [[obj objectForKey:@"venue"] objectForKey:@"name"];
    _name = [_name stringByReplacingOccurrencesOfString:@"+" withString:@" "];

    //Not parsed properly... fixing now
    NSDictionary *loc = [[obj objectForKey:@"venue"] objectForKey:@"location"];
    _distance = [loc objectForKey:@"distance"];

    if([loc objectForKey:@"address"]){
        _address = [NSString stringWithFormat:@"%@, %@", [loc objectForKey:@"address"], [loc objectForKey:@"city"]];
    }
    else {
        _address = [NSString stringWithFormat:@"%@", [loc objectForKey:@"city"]];
    }

//    NSLog(@"%@, %@, %@", _name, _address, _distance);

    //Images
    _venueID = [[obj objectForKey:@"venue"] objectForKey:@"id"];
    [self fetchImage];

    return self;
}

- (void) fetchImage {
    NSString *FSclient_id = @"SCKLV2BWBLU5WABPVMCBX2V5N44H14FDWXNKIWQVXFKSLCAX",
    *FSclient_secret_key = @"SEQHGWOACYF13UDEZDFHF1QHH2RFOBEHMHE0TTHJ0L2ZTKNV";
    NSString *url = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@/photos?client_id=%@&client_secret=%@&v=20130815", _venueID, FSclient_id, FSclient_secret_key];

    NSURL *foursquareRequestURL = [NSURL URLWithString:url];

    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:foursquareRequestURL] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

        if (!error) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSDictionary *photo = [[[[json objectForKey:@"response"] objectForKey:@"photos"] objectForKey:@"items"] firstObject];
//            NSLog(@"PHOTO: %@", photo);
            _imageURL = [NSString stringWithFormat:@"%@320x100%@", [photo objectForKey:@"prefix"], [photo objectForKey:@"suffix"]];
//            NSLog(@"imageURL: %@", _imageURL);

        } else {
            NSLog(@"ERROR: %@", error);
        };
    }];
}

@end
