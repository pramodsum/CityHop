//
//  DestinationSearchViewController.h
//  RouteMe1
//
//  Created by Sumedha Pramod on 2/27/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DestinationSearchViewController : UITableViewController <UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchbar;

@end
