//
//  DescripcionViewController.h
//  DejateCaer
//  @rockarloz
//  rockarlos@me.com
//  Created by Carlos Castellanos on 13/03/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface DescripcionViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate>
@property (nonatomic,retain) NSMutableDictionary *evento;
@property (strong, nonatomic) CLLocationManager *LocationManager;
@property (weak, nonatomic) IBOutlet UILabel *nombre;

@property (weak, nonatomic) IBOutlet UILabel *categoria;

@property (weak, nonatomic) IBOutlet UILabel *horario;
@property (weak, nonatomic) IBOutlet UILabel *fecha;

@property (weak, nonatomic) IBOutlet UIImageView *imagen;


@property (weak, nonatomic) IBOutlet UILabel *contacto;
@property (weak, nonatomic) IBOutlet UILabel *sitio;
@property (weak, nonatomic) IBOutlet UILabel *precio;

@property (weak, nonatomic) IBOutlet UILabel *direccion;
@property (weak, nonatomic) IBOutlet UILabel *lugar;

@property (weak, nonatomic) IBOutlet UIView *vistaaux1;

@property (weak, nonatomic) IBOutlet UIView *vistaaux2;
@property (weak, nonatomic) IBOutlet UIView *vistaaux3;


@property (weak, nonatomic) IBOutlet UILabel *descripcion;

@property (weak, nonatomic) IBOutlet MKMapView *mapa;


@property (weak, nonatomic) IBOutlet UIButton *btnPrecio;

@property (weak, nonatomic) IBOutlet UIButton *btnEventos;

@property (weak, nonatomic) IBOutlet UIButton *btnResena;

@property (weak, nonatomic) IBOutlet UIButton *btnContacto;

@property (weak, nonatomic) IBOutlet UIButton *btnWeb;

-(IBAction)resena:(id)sender;
-(IBAction)web:(id)sender;
-(IBAction)contacto:(id)sender;
-(IBAction)precio:(id)sender;

-(IBAction)regresar:(id)sender;
-(IBAction)twittear:(id)sender;
- (IBAction)postToFacebook:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
