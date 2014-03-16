//
//  POISuggestionCell.h
//  RouteMe1
//
//  Created by Sumedha Pramod on 3/12/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface POISuggestionCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *activityName;
@property (strong, nonatomic) IBOutlet UILabel *activityAddress;
@property (strong, nonatomic) IBOutlet UILabel *activityRating;
@property (strong, nonatomic) IBOutlet UIImageView *activityImage;

@end
