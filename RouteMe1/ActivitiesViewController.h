//
//  ActivitiesViewController.h
//  RouteMe1
//
//  Created by Adam Oxner on 3/2/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DestinationObject.h"

@interface ActivitiesViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSArray *destinations;
@property NSInteger *index;

@end
