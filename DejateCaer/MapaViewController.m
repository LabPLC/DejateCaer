//
//  MapaViewController.m
//  DejateCaer
//
//  Created by Carlos Castellanos on 14/03/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import "MapaViewController.h"

@interface MapaViewController ()

@end

@implementation MapaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
     //[_mapa addGestureRecognizer:tapRec];
    CLLocationCoordinate2D SCL;
    SCL.latitude = [_latitud doubleValue];
    SCL.longitude = [_longitud doubleValue];
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = SCL;
    annotationPoint.title = _nombre;
   // annotationPoint.subtitle = [lugar objectForKey:@"direccion"];
    [_mapa addAnnotation:annotationPoint];
     [_mapa setShowsUserLocation:YES];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(SCL, 2000, 2000);
    
    [_mapa setRegion:region animated:YES];
    //[self getCurrentLocation:nil];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
