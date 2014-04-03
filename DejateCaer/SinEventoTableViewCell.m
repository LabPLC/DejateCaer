//
//  SinEventoTableViewCell.m
//  DejateCaer
//
//  Created by Carlos Castellanos on 02/04/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import "SinEventoTableViewCell.h"

@implementation SinEventoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
