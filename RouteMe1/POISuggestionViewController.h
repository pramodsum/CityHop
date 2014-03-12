//
//  POISuggestionViewController.h
//  RouteMe1
//
//  Created by Sumedha Pramod on 3/4/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface POISuggestionViewController : UIViewController

@property (retain) NSString *city;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *filterTextView;

@end
