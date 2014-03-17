//
//  POIObject.m
//  CityHop
//
//  Created by Sumedha Pramod on 3/10/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import "POIObject.h"
#import "SMXMLDocument.h"

@implementation POIObject {
    NSXMLParser *parser;
}

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
@synthesize sortOrder = _sortOrder;
@synthesize twitter = _twitter;
@synthesize phone_number = _phone_number;
@synthesize url = _url;
@synthesize description = _description;
@synthesize selected = _selected;

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
    _rating = [venue objectForKey:@"rating"];
    _sortOrder = @([_likes integerValue] + [_checkins integerValue]);

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

    //Contact
    _twitter = [[venue objectForKey:@"contact"] objectForKey:@"twitter"];
    _phone_number = [[venue objectForKey:@"contact"] objectForKey:@"formattedPhone"];
    _url = [venue objectForKey:@"url"];

    //Description
    [parser setDelegate:self];
    [self getVenueDescription];

    //Not Selected
    _selected = NO;

    return self;
}

- (void) getVenueDescription {
    NSString *name = [_name stringByReplacingOccurrencesOfString:@" " withString:@"+"];

    NSString *wiki_url = [NSString
                          stringWithFormat:@"http://api.geonames.org/wikipediaSearch?q=%@&maxRows=1&username=demo",
                          name];

    NSURL *wikiURL = [NSURL URLWithString:wiki_url];

    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:wikiURL] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {


        if (!error) {
            SMXMLDocument *document = [SMXMLDocument documentWithData:data error:&error];
            SMXMLElement *articles = [document childNamed:@"geonames"];
            for (SMXMLElement *summary in [articles childrenNamed:@"entry"]) {
                _description = [summary attributeNamed:@"summary"] ;
                NSLog(@"%@", _description);
            }

        } else {
            NSLog(@"ERROR: %@", error);
        }
    }];
}

@end
