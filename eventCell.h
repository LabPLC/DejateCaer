//
//  eventCell.h
//  DejateCaer
//
//  Created by Carlos Castellanos on 12/03/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eventCell : UITableViewCell
@property (nonatomic,retain) IBOutlet UILabel *nombre;
@property (nonatomic,retain) IBOutlet UILabel *hora;
@property (nonatomic,retain) IBOutlet UILabel *distancia;
@end
