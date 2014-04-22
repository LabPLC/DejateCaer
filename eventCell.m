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
        self.backgroundColor=[UIColor colorWithRed:(243/255.0) green:(23/255.0) blue:(52/255.0) alpha:1];
        UIView * circleView = [[UIView alloc] initWithFrame:CGRectMake(245,10,70,70)];
        circleView.alpha = 0.5;
        circleView.layer.cornerRadius = 20;
        circleView.backgroundColor = [UIColor redColor];
       // [self addSubview:circleView];
        // Initialization code
        UIView *selectedView = [[UIView alloc]init];
        selectedView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0 green:0 blue:255 alpha:0.3];
        
        _nombre=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 235, 70)];
        _nombre.textColor=[UIColor whiteColor];
        //[_nombre setFont:[UIFont systemFontOfSize:16]];
        [_nombre setFont:[UIFont fontWithName:@"NIISans-Bold" size:16]];
        _nombre.numberOfLines = 3;
        
        [self   addSubview:_nombre];
        
        _hora=[[UILabel alloc]initWithFrame:CGRectMake(10, 60, 300, 34)];
        _hora.textColor=[UIColor whiteColor];
        //[_hora setFont:[UIFont systemFontOfSize:10]];
        [_hora setFont:[UIFont fontWithName:@"NIISansLight" size:10]];

        [self   addSubview:_hora];
        
       // _distancia=[[UILabel alloc]initWithFrame:CGRectMake(10, circleView.frame.size.height/2-10, 70, 21)];
          _distancia=[[UILabel alloc]initWithFrame:CGRectMake(255, 30, 70, 21)];
        _distancia.text=@"300 m";
        _distancia.textColor=[UIColor whiteColor];
        // [_distancia setFont:[UIFont systemFontOfSize:14]];
        [_distancia setFont:[UIFont fontWithName:@"NIISansLight" size:13]];
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
