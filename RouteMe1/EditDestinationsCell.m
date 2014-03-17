//
//  EditDestinationsCell.m
//  RouteMe1
//
//  Created by Adam Oxner on 2/23/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import "EditDestinationsCell.h"

@implementation EditDestinationsCell

@synthesize destID = _destID;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
