//
//  Mipin.m
//  LugaresCDMX
//
//  Created by Carlos Castellanos on 23/01/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import "Mipin.h"


@implementation Mipin
// Hacemos synthesize
@synthesize title, subtitle, coordinate,tipo;

// Implementamos el método de inicialización del objeto.
- (id)initWithTitle:(NSString *)aTitle subtitle:(NSString*)aSubtitle andCoordinate:(CLLocationCoordinate2D)coord tipo:(NSString*)atipo
{
	self = [super init];
	title = aTitle;
    subtitle = aSubtitle;
	coordinate = coord;
    tipo=atipo;
	return self;
}

@end
