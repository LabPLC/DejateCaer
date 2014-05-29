//
//  eventCell.m
//  DejateCaer
//  @rockarloz
//  rockarlos@me.com
//  Created by Carlos Castellanos on 12/03/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import "eventCell.h"

@implementation eventCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // self.backgroundColor=[UIColor colorWithRed:(243/255.0) green:(23/255.0) blue:(52/255.0) alpha:1];
        self.backgroundColor=[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
        
        _imagen=[[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 55, 55)];
        _imagen.layer.cornerRadius = 10;
        _imagen.layer.masksToBounds = YES;
        [self addSubview:_imagen];
        
       // [self addSubview:circleView];
        // Initialization code
       
        UIView *selectedView = [[UIView alloc]init];
        selectedView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0 green:0 blue:255 alpha:0.3];
        
        _nombre=[[UILabel alloc]initWithFrame:CGRectMake(80, 5, 230, 70)];
        _nombre.textColor=[UIColor grayColor];
        //[_nombre setFont:[UIFont systemFontOfSize:16]];
        [_nombre setFont:[UIFont fontWithName:@"NIISans" size:15]];
        _nombre.numberOfLines = 3;
        
        [self   addSubview:_nombre];
        
        _hora=[[UILabel alloc]initWithFrame:CGRectMake(80, 60, 300, 34)];
        _hora.textColor=[UIColor redColor];
        //[_hora setFont:[UIFont systemFontOfSize:10]];
        [_hora setFont:[UIFont fontWithName:@"NIISansLight" size:12]];

        [self   addSubview:_hora];
     
        _distancia=[[UILabel alloc]initWithFrame:CGRectMake(270, 60, 70, 34)];
        _distancia.text=@"300 m";
        _distancia.textColor=[UIColor redColor];
        // [_distancia setFont:[UIFont systemFontOfSize:14]];
        [_distancia setFont:[UIFont fontWithName:@"NIISansLight" size:12]];
        [self    addSubview:_distancia];
        
       // cell.selectedBackgroundView =  selectedView;
        self.selectedBackgroundView=selectedView;
       // self.backgroundColor=[UIColor clearColor];
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
