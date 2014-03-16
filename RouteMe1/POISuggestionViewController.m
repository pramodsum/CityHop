//
//  POISuggestionViewController.m
//  RouteMe1
//
//  Created by Sumedha Pramod on 3/12/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import "POISuggestionViewController.h"
#import "POISuggestion.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface POISuggestionViewController ()

@end

@implementation POISuggestionViewController {
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

    // init destination
    destination = (DestinationObject *)[_destinations objectAtIndex:_index.intValue];


    [self.navigationItem setTitle:destination.name];

    [self.navigationItem setTitle:[[((DestinationObject *)[_destinations objectAtIndex:_index.intValue]).name componentsSeparatedByString:@","] objectAtIndex:0]];

    self.tableView.scrollEnabled = YES;

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
        // button for itinerary
        
        UIBarButtonItem *itineraryBtn = [[UIBarButtonItem alloc]
                                         initWithTitle:@"Done"
                                         style:UIBarButtonItemStyleDone
                                         target:self
                                         action:@selector(segueToItinerary)];
        [self.navigationItem setRightBarButtonItem:itineraryBtn];
    }
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

- (void)segueToItinerary {
    [self performSegueWithIdentifier:@"itinerary_segue" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [destination activitiesCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"POICell";

    POISuggestionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[POISuggestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    POIObject *poi = (POIObject *)[destination venueAtIndex:indexPath.row];
    [cell.activityName setText:[poi name]];
    [cell.activityAddress setText:[poi address]];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell.activityImage setImageWithURL:[NSURL URLWithString:[poi imageURL]]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryNone) {
        [[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else{
        [[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
    }
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
