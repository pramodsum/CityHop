//
//  DestinationSearchViewController.m
//  RouteMe1
//
//  Created by Sumedha Pramod on 2/24/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import "DestinationSearchViewController.h"

@interface DestinationSearchViewController () <UISearchDisplayDelegate, UISearchBarDelegate>

@end

@implementation DestinationSearchViewController {
    MKLocalSearch *localSearch;
    MKLocalSearchResponse *results;
}

@synthesize searchbar;
@synthesize destinationsMap;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    [self.searchDisplayController setDelegate:self];
    [searchbar setDelegate: self];

    return self;
}

#pragma mark - Search Methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // Cancel any previous searches.
    [localSearch cancel];

    // Perform a new search.
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchText;

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    localSearch = [[MKLocalSearch alloc] initWithRequest:request];

    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){

        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        if ([response.mapItems count] == 0) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Results",nil)
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
            return;
        }

        if (error != nil) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Map Error",nil)
                                        message:[error localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
            return;
        }

        results = response;

        [self.searchDisplayController.searchResultsTableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [results.mapItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *IDENTIFIER = @"SearchResultsCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IDENTIFIER];
    }

    MKMapItem *item = results.mapItems[indexPath.row];

    cell.textLabel.text = item.name;
//    char c = 'A' + indexPath.row;
//    char str[2] = {0, 0};
//    str[0] = c;
//    cell.detailTextLabel.text = [NSString stringWithUTF8String:str];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchDisplayController setActive:NO animated:YES];

    MKMapItem *item = results.mapItems[indexPath.row];
    [destinationsMap addAnnotation:item.placemark];
    [destinationsMap selectAnnotation:item.placemark animated:YES];

    [destinationsMap setCenterCoordinate:item.placemark.location.coordinate animated:YES];

    [destinationsMap setUserTrackingMode:MKUserTrackingModeNone];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
