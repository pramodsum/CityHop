//
//  POISuggestionViewController.h
//  RouteMe1
//
//  Created by Sumedha Pramod on 3/12/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface POISuggestionViewController : UITableViewController

@property (retain) NSString *city;
@property (strong, nonatomic) IBOutlet UISearchBar *filterbar;

@end
