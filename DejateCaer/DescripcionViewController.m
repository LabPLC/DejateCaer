//
//  DescripcionViewController.m
//  DejateCaer
//
//  Created by Carlos Castellanos on 13/03/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import "DescripcionViewController.h"
#import "ViewController.h"
#import "MapaViewController.h"
#import <Social/Social.h>
@interface DescripcionViewController ()

@end

@implementation DescripcionViewController
{
    BOOL touch_map;
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
{
    touch_map=FALSE;
    UITapGestureRecognizer* tapRec = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(touchMap)];
    [_mapa addGestureRecognizer:tapRec];
    
    _LocationManager = [[CLLocationManager alloc] init];
    _LocationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    _LocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [_LocationManager startUpdatingLocation];
    
    _nombre.text=[_evento objectForKey:@"nombre"];
    _lugar.text=[_evento objectForKey:@"lugar"];
    _horario.text=[_evento objectForKey:@"hora"];
    _direccion.text=[_evento objectForKey:@"direccion"];
    CLLocationCoordinate2D SCL;
    SCL.latitude = [[_evento objectForKey:@"latitud"] doubleValue];
    SCL.longitude = [[_evento objectForKey:@"longitud"]doubleValue];
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = SCL;
    annotationPoint.title = [_evento objectForKey:@"nombre"];
    annotationPoint.subtitle = [_evento objectForKey:@"direccion"];
    [_mapa addAnnotation:annotationPoint];
    [_mapa setShowsUserLocation:YES];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(SCL, 2000, 2000);
    
    [_mapa setRegion:region animated:YES];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)touchMap{
    MapaViewController *mapa= [[self storyboard] instantiateViewControllerWithIdentifier:@"mapa"];//[[MapaViewController alloc]init];
    mapa.latitud=[_evento objectForKey:@"latitud"];
    mapa.longitud=[_evento objectForKey:@"longitud"];
    mapa.nombre=[_evento objectForKey:@"nombre"];
    mapa.view.backgroundColor=[UIColor whiteColor];
[self.navigationController pushViewController:mapa animated:YES];
}
-(IBAction)regresar:(id)sender
{
    [self dismissModalViewControllerAnimated:NO];
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
        NSString *cuerpo=[NSString stringWithFormat:@"Me gusta el evento:%@ que será en %@ . #DejateCaerApp #DejateCaer #EventosCDMX",[_evento objectForKey:@"nombre"],[_evento objectForKey:@"lugar"]];
        [tweetSheet setInitialText:cuerpo];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}
- (IBAction)postToFacebook:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:[NSString stringWithFormat:@"Me gusta el evento:%@ que será en %@ . #DejateCaerApp #DejateCaer #EventosCDMX",[_evento objectForKey:@"nombre"],[_evento objectForKey:@"lugar"]]];
        [self presentViewController:controller animated:YES completion:Nil];
    }
}
-(IBAction)ruta:(id)sender{
   
}
@end
