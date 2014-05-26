//
//  MapaViewController.m
//  DejateCaer
//
//  Created by Carlos Castellanos on 14/03/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//
#import "Mipin.h"
#import "MapaViewController.h"

@interface MapaViewController ()

@end

@implementation MapaViewController
{
 CLLocationCoordinate2D SCL;}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
    _mapa.delegate=self;
    //[_mapa addGestureRecognizer:tapRec];
    
    SCL.latitude = [_latitud doubleValue];
    SCL.longitude = [_longitud doubleValue];
    
  
    
    CLLocationCoordinate2D newCoord = {SCL.latitude, SCL.longitude};
    Mipin *annotationPoint = [[Mipin alloc] initWithTitle:_nombre subtitle:nil andCoordinate:newCoord tipo:@"" evento:0 lugar:nil hora:nil];
    
    [_mapa addAnnotation:annotationPoint];

    
   /* MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = SCL;
    annotationPoint.title = _nombre;
    // annotationPoint.subtitle = [lugar objectForKey:@"direccion"];
    [_mapa addAnnotation:annotationPoint];*/
    [_mapa setShowsUserLocation:YES];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(SCL, 2000, 2000);
    
    [_mapa setRegion:region animated:YES];
    //[self getCurrentLocation:nil];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(IBAction)regresar:(id)sender
{
    // [self dismissModalViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(IBAction)openMaps:(id)sender{
    MKPlacemark *sourcePlacemark = [[MKPlacemark alloc] initWithCoordinate:SCL addressDictionary:nil];
    NSLog(@"coordiante : locationIniziale %f", sourcePlacemark.coordinate.latitude);
    MKMapItem *carPosition = [[MKMapItem alloc] initWithPlacemark:sourcePlacemark];
    MKMapItem *actualPosition = [MKMapItem mapItemForCurrentLocation];
    NSLog(@"coordiante : source %f, ActualPosition %f", carPosition.placemark.coordinate.latitude ,actualPosition.placemark.coordinate.latitude);
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = actualPosition;
    request.destination = carPosition;
    request.requestsAlternateRoutes = YES;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error : %@", error);
        }
        else {
            [self showDirections:response]; //response is provided by the CompletionHandler
        }
    }];
   /* MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:SCL addressDictionary:nil];
    MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];
    item.name = @"ReignDesign Office";
    [item openInMapsWithLaunchOptions:nil];*/
}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.strokeColor = [UIColor blueColor];
        return routeRenderer;
    }
    else return nil;
}
- (void)showDirections:(MKDirectionsResponse *)response
{
    int i=0;
    for (MKRoute *route in response.routes) {
        if (i<1) {
         [_mapa addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
            i++;
        }
        
    }
}
-(IBAction)getCurrentLocation:(id)sender
{
    [self viewDidLoad];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id<MKAnnotation>) annotation {
    
    /* if ([annotation isKindOfClass:[CalloutAnnotation class]]) {
     return nil;
     // NSLog(@"fue letrerito");
     }
     else{*/
    Mipin  *anotacion1 = (Mipin*)annotation;
    
    
    // Comprobamos si se trata de la anotación correspondiente al usuario.
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    MKAnnotationView *aView = [[MKAnnotationView alloc] initWithAnnotation:anotacion1 reuseIdentifier:@"pinView"];
    
    
    aView.canShowCallout = YES;
    aView.enabled = YES;
    aView.centerOffset = CGPointMake(0, -20);
    aView.tag=anotacion1.id_event;
    aView.draggable = YES;
    UIImage *imagen;
    
    imagen = [UIImage imageNamed:@"pin2.png"];
    
    
    aView.image = imagen;
    
    CGRect frame = aView.frame;
    frame.size.width = 30;
    frame.size.height = 40;
    aView.frame = frame;
    
    
    
    
    return aView;
    
}


@end