//
//  RutaViewController.h
//  DejateCaer
//
//  Created by Carlos Castellanos on 20/03/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface RutaViewController : UIViewController <MKMapViewDelegate ,UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *LocationManager;
@property (nonatomic, retain) IBOutlet MKMapView *mapa;
@property (nonatomic, retain) NSString *latitud_origen;
@property (nonatomic, retain) NSString *longitud_origen;
@property (nonatomic, retain) NSString *latitud_destino;
@property (nonatomic, retain) NSString *longitud_destino;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@end
