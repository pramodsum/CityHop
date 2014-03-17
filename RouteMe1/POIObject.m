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
@synthesize imageURL = _imageURL;
@synthesize rating = _rating;
@synthesize likes = _likes;
@synthesize checkins = _checkins;
@synthesize tags = _tags;
@synthesize price = _price;

- (POIObject *) initWithObject:(NSDictionary *) obj {
    NSDictionary *venue = [obj objectForKey:@"venue"];
    _name = [[venue objectForKey:@"name"]
             stringByReplacingOccurrencesOfString:@"+" withString:@" "];

    //Address
    NSDictionary *loc = [venue objectForKey:@"location"];
    _distance = [loc objectForKey:@"distance"];

    if([loc objectForKey:@"address"]){
        _address = [NSString stringWithFormat:@"%@, %@",
                    [loc objectForKey:@"address"],
                    [loc objectForKey:@"city"]];
    }
    else {
        _address = [NSString stringWithFormat:@"%@", [loc objectForKey:@"city"]];
    }

    //Images
    _venueID = [venue objectForKey:@"id"];
    NSDictionary *photo = [[[[[venue
                               objectForKey:@"photos"]
                              objectForKey:@"groups"] firstObject]
                            objectForKey:@"items"] firstObject];
    _imageURL = [NSString stringWithFormat:@"%@320x100%@",
                 [photo objectForKey:@"prefix"],
                 [photo objectForKey:@"suffix"]];

    //Rating
    _likes = [[venue objectForKey:@"likes"] objectForKey:@"count"];
    _checkins = [[venue objectForKey:@"stats"] objectForKey:@"checkinsCount"];
    _rating = @([_likes integerValue] + [_checkins integerValue]);

    //Tags
    NSArray *categories = [venue objectForKey:@"categories"];
    _tags = [[NSMutableArray alloc] init];
    for(NSDictionary *tag in categories) {
        [_tags addObject:[tag objectForKey:@"name"]];
        [_tags addObject:[tag objectForKey:@"shortName"]];
        [_tags addObject:[tag objectForKey:@"pluralName"]];
    }

    //Price
    _price = [venue objectForKey:@"price"];

    return self;
}

@end
