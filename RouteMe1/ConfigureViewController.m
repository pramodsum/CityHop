//
//  ConfigureViewController.m
//  RouteMe1
//
//  Created by Adam Oxner on 2/15/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import "ConfigureViewController.h"
#import "AppDelegate.h"
#import "DestinationsTableViewController.h"
#import "POISuggestionViewController.h"

@interface ConfigureViewController ()

@end

@implementation ConfigureViewController{
    AppDelegate *appDelegate;
    DestinationsTableViewController *childController;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonSelected:)];
    [self.navigationItem setRightBarButtonItem:doneBtn];
    
    
}

- (void)doneButtonSelected:(id)sender{
    
    if ([appDelegate.tripManager getDestinations] != nil && [[appDelegate.tripManager getDestinations] count] > 0) {
        [self performSegueWithIdentifier:@"select_activities_segue" sender:self];
    }else{
        [[UIAlertView alloc]
            initWithTitle:@"Umm where are you going" message:@"Please enter at least one destination" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil].show;
    }
    
}

- (IBAction)addDestination:(id)sender {
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Add Destination" message:@"Please enter a destination." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        // Code for Cancel button
        // nil
    }
    if (buttonIndex == 1)
    {
        // Code for OK button
        // add to destinations
        
        NSLog(@"Adding %@" , [alertView textFieldAtIndex:0].text);
        NSNumber *iid = [appDelegate.tripManager addDestinationWithString:[alertView textFieldAtIndex:0].text];
        NSLog(@"%lu", (unsigned long)[[appDelegate.tripManager getDestinations] count]);
        [childController.tableView reloadData];
        
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"destination_container"]) {
        childController = (DestinationsTableViewController *) [segue destinationViewController];
    }else if ([segueName isEqualToString:@"select_activities_segue"]){
        POISuggestionViewController *vc = (POISuggestionViewController *) [segue destinationViewController];
        [vc setDestinations:[appDelegate.tripManager getDestinations]];
        [vc setIndex:[NSNumber numberWithInt:0]];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
