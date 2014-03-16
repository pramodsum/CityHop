//
//  POISuggestionViewController.m
//  RouteMe1
//
//  Created by Sumedha Pramod on 3/12/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import "POISuggestionViewController.h"
#import "POISuggestion.h"

@interface POISuggestionViewController ()

@end

@implementation POISuggestionViewController {
    NSMutableArray *activitySuggestions; // array for populating table
    TripManager *tripManager;
    DestinationObject *destination;
}

@synthesize index = _index;
@synthesize destinations = _destinations;
@synthesize appDelegate = _appDelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self hideSearchBar];
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    tripManager = _appDelegate.tripManager;

    // set destination
    destination = (DestinationObject *)[_destinations objectAtIndex:_index.intValue];

    // initialize data
    if (activitySuggestions == nil) {
        activitySuggestions = [[NSMutableArray alloc] init];
    }

    [self.navigationItem setTitle:[[((DestinationObject *)[_destinations objectAtIndex:_index.intValue]).name componentsSeparatedByString:@","] objectAtIndex:0]];

    if (_index.intValue < [_destinations count]-1) {
        // button for next city

        UIBarButtonItem *nextCityBtn =
        [[UIBarButtonItem alloc]
         initWithTitle:[[((DestinationObject *)[_destinations objectAtIndex:_index.intValue+1]).name componentsSeparatedByString:@","] objectAtIndex:0]
         style:UIBarButtonItemStylePlain
         target:self
         action:@selector(nextCity:)];


        [self.navigationItem setRightBarButtonItem:nextCityBtn];

    }else{
        // button for trip options
    }

    // load venues
    POISuggestion *poiSuggestion = [[POISuggestion alloc] init];
    [poiSuggestion getVenues:destination];
    [self.tableView reloadData];
    NSLog(@"Activity count: %li", [destination activitiesCount]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hideSearchBar{
    CGPoint offset = CGPointMake(0, self.searchBar.frame.size.height);
    self.tableView.contentOffset = offset;
}

- (void) nextCity:(id)sender
{
    [self performSegueWithIdentifier:@"next_city_segue" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (activitySuggestions == nil) {
        return 0;
    }

    return [activitySuggestions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    POISuggestionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[POISuggestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    // Configure the cell...
    if([destination activitiesCount] == 0) {
        [cell.destinationName setText:[(POIObject *)[destination venueAtIndex:indexPath.row] name]];
    }

    return cell;
}

#pragma mark - Navigation


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"next_city_segue"]) {
        POISuggestionViewController *vc = (POISuggestionViewController *)[segue destinationViewController];
        [vc setDestinations:_destinations];
        [vc setIndex:[NSNumber numberWithInt:_index.intValue+1]];
    }
}

@end
