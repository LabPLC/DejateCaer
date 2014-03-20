//
//  DescripcionViewController.h
//  DejateCaer
//
//  Created by Carlos Castellanos on 13/03/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface DescripcionViewController : UIViewController <MKMapViewDelegate>
@property (nonatomic,retain) NSMutableDictionary *evento;
@property (strong, nonatomic) IBOutlet UILabel *nombre;
@property (strong, nonatomic) IBOutlet UILabel *lugar;
@property (strong, nonatomic) IBOutlet UILabel *horario;
@property (weak, nonatomic) IBOutlet UILabel *direccion;
@property (nonatomic, retain) IBOutlet MKMapView *mapa;
-(IBAction)regresar:(id)sender;
-(IBAction)twittear:(id)sender;
@end
