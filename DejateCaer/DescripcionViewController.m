//
//  DescripcionViewController.m
//  DejateCaer
//  @rockarloz
//  rockarlos@me.com
//  Created by Carlos Castellanos on 13/03/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import "Mipin.h"
#import "DescripcionViewController.h"
#import "ViewController.h"
#import <Social/Social.h>
@interface DescripcionViewController ()

@end

@implementation DescripcionViewController
{

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{   [_mapa setDelegate:self];

    

    
    _LocationManager = [[CLLocationManager alloc] init];
    _LocationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    _LocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [_LocationManager startUpdatingLocation];
    
    [_btnEventos.titleLabel setFont:[UIFont fontWithName:@"NIISansLight" size:19]];
   // [_btnEventos.titleLabel setFont:[UIFont systemFontOfSize:10]];
    _nombre.text=[_evento objectForKey:@"nombre"];
     [_nombre setFont:[UIFont fontWithName:@"NIISans-Bold" size:18]];
    _lugar.text=[_evento objectForKey:@"lugar"];
    [_lugar setFont:[UIFont fontWithName:@"NIISans" size:17]];
    
    _horario.text=[_evento objectForKey:@"hora"];
         [_horario setFont:[UIFont fontWithName:@"NIISans" size:17]];
    _direccion.text=[_evento objectForKey:@"direccion"];
         [_direccion setFont:[UIFont fontWithName:@"NIISansLight" size:15]];
    CLLocationCoordinate2D SCL;
    SCL.latitude = [[_evento objectForKey:@"latitud"] doubleValue];
    SCL.longitude = [[_evento objectForKey:@"longitud"]doubleValue];
    
    
    CGFloat newLat = [[_evento objectForKey:@"latitud"] doubleValue];
    CGFloat newLon = [[_evento objectForKey:@"longitud"]doubleValue];
    
    CLLocationCoordinate2D newCoord = {newLat, newLon};
    
    Mipin *annotationPoint = [[Mipin alloc] initWithTitle:[_evento objectForKey:@"nombre"] subtitle:[_evento objectForKey:@"direccion"] andCoordinate:newCoord tipo:@"" evento:0 lugar:[_evento objectForKey:@"lugar"] hora:[_evento objectForKey:@"hora"]];
    
    [_mapa addAnnotation:annotationPoint];
    
  /*  MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = SCL;
    annotationPoint.title = [_evento objectForKey:@"nombre"];
    annotationPoint.subtitle = [_evento objectForKey:@"direccion"];
    [_mapa addAnnotation:annotationPoint];*/
    
    [_mapa setShowsUserLocation:YES];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newCoord, 2000, 2000);
    [_mapa setRegion:region animated:YES];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(IBAction)regresar:(id)sender
{
   // [self dismissModalViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)twittear:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        NSString *cuerpo=[NSString stringWithFormat:@"Me gusta el evento:%@  @EventarioCDMX #EventarioApp",[_evento objectForKey:@"nombre"]];
        [tweetSheet setInitialText:cuerpo];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    
    else{
    
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Mensaje" message:@"No tiene una cuenta de Twitter configurada. Configurala en Ajustes -> Twitter -> Añadir Cuenta" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        [alert show];
    
    }
}
- (IBAction)postToFacebook:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:[NSString stringWithFormat:@"Me gusta el evento:%@. #EventarioApp  #EventarioCDMX",[_evento objectForKey:@"nombre"]]];
        [self presentViewController:controller animated:YES completion:Nil];
    }
    
    else{
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Mensaje" message:@"No tiene una cuenta de Facebook configurada. Configurala en Ajustes -> Facebook -> Añadir Cuenta" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        [alert show];
        
    }
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
