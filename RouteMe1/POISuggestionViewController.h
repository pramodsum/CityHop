//
//  POISuggestionViewController.h
//  RouteMe1
//
//  Created by Sumedha Pramod on 3/12/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DestinationObject.h"
#import "ActivityObject.h"

@interface POISuggestionViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSString *city;

@property (strong, nonatomic) NSArray *destinations;
@property (strong, nonatomic) NSNumber *index;

@end
