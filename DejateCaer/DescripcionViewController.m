//
//  DescripcionViewController.m
//  DejateCaer
//
//  Created by Carlos Castellanos on 13/03/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import "DescripcionViewController.h"
#import "ViewController.h"
@interface DescripcionViewController ()

@end

@implementation DescripcionViewController

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
-(IBAction)regresar:(id)sender
{
    ViewController *inicio;//=[[DescripcionViewController alloc]init];
    
    inicio = [[self storyboard] instantiateViewControllerWithIdentifier:@"inicio"];
   
    inicio.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:inicio animated:YES completion:NULL];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
