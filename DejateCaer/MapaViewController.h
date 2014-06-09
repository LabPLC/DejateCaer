//
//  MapaViewController.h
//  DejateCaer
//
//  Created by Carlos Castellanos on 14/03/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface MapaViewController : UIViewController  <MKMapViewDelegate,CLLocationManagerDelegate>
@property (nonatomic, retain) IBOutlet MKMapView *mapa;
@property (nonatomic, retain) NSString *latitud;
@property (nonatomic, retain) NSString *longitud;
@property (nonatomic, retain) NSString *nombre;
-(IBAction)getCurrentLocation:(id)sender;
@property (strong, nonatomic) CLLocationManager *LocationManager;
-(IBAction)regresar:(id)sender;
-(IBAction)openMaps:(id)sender;
@end