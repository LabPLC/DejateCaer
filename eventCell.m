//
//  eventCell.m
//  DejateCaer
//
//  Created by Carlos Castellanos on 12/03/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import "eventCell.h"

@implementation eventCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *selectedView = [[UIView alloc]init];
        selectedView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:255 alpha:0.3];
        
        _nombre=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 250, 70)];
        _nombre.textColor=[UIColor blueColor];
        [_nombre setFont:[UIFont systemFontOfSize:16]];
        _nombre.numberOfLines = 3;
        
        [self   addSubview:_nombre];
        
        _hora=[[UILabel alloc]initWithFrame:CGRectMake(10, 60, 300, 34)];
        _hora.textColor=[UIColor blackColor];
        [_hora setFont:[UIFont systemFontOfSize:10]];
        
        [self   addSubview:_hora];
        
        _distancia=[[UILabel alloc]initWithFrame:CGRectMake(255, 48, 70, 21)];
        _distancia.text=@"300 m";
        [self    addSubview:_distancia];
        
       // cell.selectedBackgroundView =  selectedView;
        self.selectedBackgroundView=selectedView;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
   // self.backgroundColor=[UIColor yellowColor];
    // Configure the view for the selected state
}

@end
