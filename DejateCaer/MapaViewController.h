//
//  MapaViewController.h
//  DejateCaer
//
//  Created by Carlos Castellanos on 14/03/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface MapaViewController : UIViewController  <MKMapViewDelegate>
@property (nonatomic, retain) IBOutlet MKMapView *mapa;

@end
