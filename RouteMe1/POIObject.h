//
//  POIObject.h
//  CityHop
//
//  Created by Sumedha Pramod on 3/10/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POIObject : NSObject <NSXMLParserDelegate>

@property (strong, nonatomic) NSString *venueID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSNumber *distance;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSNumber *sortOrder;
@property (strong, nonatomic) NSNumber *likes;
@property (strong, nonatomic) NSNumber *checkins;
@property (strong, nonatomic) NSNumber *rating;
@property (strong, nonatomic) NSMutableArray *tags;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *twitter;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *phone_number;

@property (strong, nonatomic) NSNumber *selected;

- (POIObject *) initWithObject:(NSDictionary *) obj;

@end
