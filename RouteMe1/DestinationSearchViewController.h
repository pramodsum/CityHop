//
//  DestinationSearchViewController.h
//  RouteMe1
//
//  Created by Sumedha Pramod on 2/24/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import "CitySearch.h"
#import <UIKit/UIKit.h>

@interface DestinationSearchViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISearchBar *searchbar;
@property (strong, nonatomic) IBOutlet MKMapView *destinationsMap;

@end
