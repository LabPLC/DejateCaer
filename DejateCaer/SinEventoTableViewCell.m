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
        UIView *selectedView = [[UIView alloc]init];
        selectedView.backgroundColor = [UIColor clearColor];
        _nombre=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 250, 70)];
        _nombre.textColor=[UIColor blueColor];
        [_nombre setFont:[UIFont systemFontOfSize:16]];
        _nombre.numberOfLines = 3;
        
        [self   addSubview:_nombre];
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
