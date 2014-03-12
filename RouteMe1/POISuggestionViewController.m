//
//  POISuggestionViewController.m
//  RouteMe1
//
//  Created by Sumedha Pramod on 3/4/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import "POISuggestionViewController.h"

@interface POISuggestionViewController ()

@end

@implementation POISuggestionViewController

@synthesize city, titleLabel;

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
    if(city) {
        [titleLabel setText: [NSString stringWithFormat:@"Activities for %@", city]];
    }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
