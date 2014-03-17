//
//  POIDetailCell.h
//  CityHop
//
//  Created by Sumedha Pramod on 3/17/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POIObject.h"
#import "TripManager.h"

@interface POIDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *phone;
@property (strong, nonatomic) IBOutlet UILabel *rating;
@property (strong, nonatomic) IBOutlet UILabel *url;
@property (strong, nonatomic) IBOutlet UILabel *twitter;
@property (strong, nonatomic) IBOutlet UILabel *tags;

//Parent cell indexPath
@property (strong, nonatomic) NSNumber *destIndexPath;
@property (strong, nonatomic) POIObject *poi;

@property (strong, nonatomic) IBOutlet UITextView *description;

@end
