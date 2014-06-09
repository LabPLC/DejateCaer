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
#import "AppDelegate.h"
#import "MapaViewController.h"
#import "ResenaViewController.h"
@interface DescripcionViewController ()

@end

@implementation DescripcionViewController
{
  //  MKMapView *mapa;
    AppDelegate *delegate;
    UIView *reseña;
    UIView *preciov;
    UIView *contactov;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) tapped
{
    [self.view endEditing:YES];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad

{
    _mapa.scrollEnabled=NO;
    if ([[_evento objectForKey:@"precio"] isEqualToString:@"No disponible"]) {
        [ _btnPrecio setImage:[UIImage imageNamed:@"dinero0.png"] forState:UIControlStateNormal];
        _btnPrecio.enabled=FALSE;
    }
    if ([[_evento objectForKey:@"contacto"] isEqualToString:@"No disponible"]) {
         [ _btnContacto setImage:[UIImage imageNamed:@"telefono0.png"] forState:UIControlStateNormal];
        _btnContacto.enabled=FALSE;
    }
    if ([[_evento objectForKey:@"pagina"] isEqualToString:@"No disponible"]) {
        [ _btnWeb setImage:[UIImage imageNamed:@"web0.png"] forState:UIControlStateNormal];
        _btnWeb.enabled=FALSE;
    }
    UITapGestureRecognizer* tapRec = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(touchMap)];
    [_mapa addGestureRecognizer:tapRec];
   /* _vistaaux1.layer.cornerRadius = 5;
    _vistaaux1.layer.masksToBounds = YES;
    _vistaaux2.layer.cornerRadius = 5;
    _vistaaux2.layer.masksToBounds = YES;
    _vistaaux3.layer.cornerRadius = 5;
    _vistaaux3.layer.masksToBounds = YES;*/
    //declaramos un variable que nos servira como delegado
    delegate= (AppDelegate *) [[UIApplication sharedApplication] delegate];
    _imagen.image=[delegate.cacheImagenes objectForKey:[_evento objectForKey:@"imagen"]];
    _imagen.layer.cornerRadius = 30;
    _imagen.layer.masksToBounds = YES;
    _descripcion.text=[_evento objectForKey:@"descripcion"];
    
    //[_descripcion sizeToFit];
    //_descripcion.textAlignment = NSTextAlignmentCenter;
    
   // mapa=[[MKMapView alloc]initWithFrame:CGRectMake(0, 300, 300, 141)];
    //[_vistaaux2 addSubview:mapa];
    
    [_mapa setDelegate:self];

    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self     action:@selector(tapped)];
    tapScroll.cancelsTouchesInView = NO;
    [_scrollView addGestureRecognizer:tapScroll];
   

    
    [_scrollView setScrollEnabled:YES];
    [_scrollView setContentSize:CGSizeMake(320, 430)];
    
    _LocationManager = [[CLLocationManager alloc] init];
    _LocationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    _LocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [_LocationManager startUpdatingLocation];
    
    [_btnEventos.titleLabel setFont:[UIFont fontWithName:@"NIISansLight" size:19]];
   // [_btnEventos.titleLabel setFont:[UIFont systemFontOfSize:10]];
    
    _nombre.text=[_evento objectForKey:@"nombre"];
    [_nombre setFont:[UIFont fontWithName:@"NIISans-Bold" size:15]];
    [_nombre sizeToFit];
    
   
    _img_cat.image=[UIImage imageNamed:[_evento objectForKey:@"categoria"]];//[UIImage imageNamed:[NSString stringWithFormat:@("%@.png"),[_evento objectForKey:@"categoria"]]];
   // _categoria.frame=CGRectMake(36, _nombre.frame.size.height+8, 111, 22);
    _categoria.text=[_evento objectForKey:@"categoria"];
    [_categoria setFont:[UIFont fontWithName:@"NIISans" size:14]];
    
    _lugar.text=[_evento objectForKey:@"lugar"];
    [_lugar setFont:[UIFont fontWithName:@"NIISans" size:14]];
    
    NSString *horas= [[_evento objectForKey:@"hora_inicio"]
                                     stringByReplacingOccurrencesOfString:@"2000-01-01T" withString:@""];
    
    NSString *horasfin= [[_evento objectForKey:@"hora_fin"]
                      stringByReplacingOccurrencesOfString:@"2000-01-01T" withString:@""];
    
   horasfin=[ horasfin stringByReplacingOccurrencesOfString:@":00Z" withString:@""];
    horas=[ horas stringByReplacingOccurrencesOfString:@":00Z" withString:@""];
    
    _horario.text=[NSString stringWithFormat:@("%@ - %@"),horas,horasfin];

    //_horario.text=[_evento objectForKey:@"hora_inicio"];
    [_horario setFont:[UIFont fontWithName:@"NIISans" size:12]];
    [_fecha setFont:[UIFont fontWithName:@"NIISans" size:12]];
    NSArray* f1 = [[_evento objectForKey:@"fecha_inicio"] componentsSeparatedByString: @"-"];
    NSString* nf1 = [NSString stringWithFormat:@("%@/%@/%@"),[f1 objectAtIndex: 2],[f1 objectAtIndex: 1],[f1 objectAtIndex: 0]];
    NSArray* f2 = [[_evento objectForKey:@"fecha_fin"] componentsSeparatedByString: @"-"];
    NSString* nf2 = [NSString stringWithFormat:@("%@/%@/%@"),[f2 objectAtIndex: 2],[f2 objectAtIndex: 1],[f2 objectAtIndex: 0]];
    
    _fecha.text=[NSString stringWithFormat:@("%@ - %@"),nf1,nf2];
    
    _direccion.text=[_evento objectForKey:@"direccion"];
         [_direccion setFont:[UIFont fontWithName:@"NIISansLight" size:12]];
    
    _precio.text=[_evento objectForKey:@"precio"];
    [_precio setFont:[UIFont fontWithName:@"NIISans" size:17]];
    
    _contacto.text=[_evento objectForKey:@"contacto"];
    [_contacto setFont:[UIFont fontWithName:@"NIISans" size:17]];
    
    _sitio.text=[_evento objectForKey:@"pagina"];
    [_sitio setFont:[UIFont fontWithName:@"NIISans" size:17]];
    
    
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
        NSString *cuerpo=[NSString stringWithFormat:@"Me gusta el evento:%@  @EventarioCDMX #EventarioApp %@",[_evento objectForKey:@"nombre"],[_evento objectForKey:@"url"]];
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
        
        [controller setInitialText:[NSString stringWithFormat:@"Me gusta el evento:%@. #EventarioApp  #EventarioCDMX %@",[_evento objectForKey:@"nombre"],[_evento objectForKey:@"url"]]];
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

-(void)touchMap{
    
    MapaViewController *mapa;
     if ([delegate.alto intValue] < 568)
     {
     mapa = [[self storyboard] instantiateViewControllerWithIdentifier:@"mapa2"];
     
     }
     
     else
     {
    
    mapa = [[self storyboard] instantiateViewControllerWithIdentifier:@"mapa"];
    
     }
    
    //mapa= [[self storyboard] instantiateViewControllerWithIdentifier:@"mapa"];//[[MapaViewController alloc]init];
    mapa.latitud=[_evento objectForKey:@"latitud"];
    mapa.longitud=[_evento objectForKey:@"longitud"];
    mapa.nombre=[_evento objectForKey:@"nombre"];
    
    [self presentViewController:mapa animated:YES completion:NULL];
}
-(IBAction)resena:(id)sender
{
    reseña=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    reseña.backgroundColor=[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3];
    
    UIView *alerta=[[UIView alloc]initWithFrame:CGRectMake(22, 130, 276, 250)];
    alerta.backgroundColor=[UIColor whiteColor];
    alerta.alpha=0.98;
    alerta.layer.cornerRadius = 5;
    alerta.layer.masksToBounds = YES;
    
    UILabel *desc=[[UILabel alloc]initWithFrame:CGRectMake(alerta.frame.size.width/2-50, 10, 200, 50)];
    //desc.tintColor=[UIColor redColor];
    //desc.textColor=[UIColor redColor];
    desc.text=@"Descripción";
    desc.font=[UIFont fontWithName:@"NIISans-Bold" size:18];
    [alerta addSubview:desc];
    
    UITextView *texto=[[UITextView alloc]initWithFrame:CGRectMake(14, 60, 252, 150)];
    texto.editable=NO;
    [texto setFont:[UIFont fontWithName:@"NIISans" size:13]];
    //[texto setTextAlignment:NSTextAlignmentJustified];
    texto.backgroundColor=[UIColor clearColor];
    texto.text=[_evento objectForKey:@"descripcion"];
    [alerta addSubview:texto];
    
    
    UIView *linea=[[UIView alloc]initWithFrame:CGRectMake(0, texto.frame.size.height+59, 276, 59)];
    linea.backgroundColor=[UIColor redColor];
    [alerta addSubview:linea];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
   // button.tintColor=[UIColor colorWithRed:24/255 green:156/255 blue:255/255 alpha:1];
    button.tintColor=[UIColor whiteColor];
    
    button.titleLabel.font = [UIFont fontWithName:@"NIISans-Bold" size:18];
    [button addTarget:self
               action:@selector(cerrar_reseña)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Aceptar" forState:UIControlStateNormal];
    
    button.frame = CGRectMake(58, 4, 160.0, 40.0);
    [linea addSubview:button];
    
    [reseña addSubview:alerta];
    [self.view addSubview:reseña];
    
   
   
   
   
 
}
-(void)cerrar_reseña{
    [reseña removeFromSuperview];
}
-(void)cerrar_precio{
    [preciov removeFromSuperview];
}

-(void)cerrar_contacto{
    [contactov removeFromSuperview];
}
-(IBAction)precio:(id)sender
{
    
    preciov=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    preciov.backgroundColor=[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3];
    
    UIView *alerta=[[UIView alloc]initWithFrame:CGRectMake(22, 200, 276, 150)];
    alerta.backgroundColor=[UIColor whiteColor];
    alerta.alpha=0.98;
    alerta.layer.cornerRadius = 5;
    alerta.layer.masksToBounds = YES;
    
    UILabel *desc=[[UILabel alloc]initWithFrame:CGRectMake(alerta.frame.size.width/2-35, 10, 100, 20)];
    //desc.tintColor=[UIColor redColor];
    //desc.textColor=[UIColor redColor];
    desc.text=@"Precio";
    desc.font=[UIFont fontWithName:@"NIISans-Bold" size:18];
    [alerta addSubview:desc];
    
    UITextView *texto=[[UITextView alloc]initWithFrame:CGRectMake(14, 40, 252, 70)];
    texto.editable=NO;
    [texto setFont:[UIFont fontWithName:@"NIISans" size:13]];
    [texto setTextAlignment:NSTextAlignmentCenter];
    texto.backgroundColor=[UIColor clearColor];
    texto.text=[_evento objectForKey:@"precio"];
    [alerta addSubview:texto];
    
    
    UIView *linea=[[UIView alloc]initWithFrame:CGRectMake(0, texto.frame.size.height+40, 276, 40)];
    linea.backgroundColor=[UIColor redColor];
    [alerta addSubview:linea];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // button.tintColor=[UIColor colorWithRed:24/255 green:156/255 blue:255/255 alpha:1];
    button.tintColor=[UIColor whiteColor];
    
    button.titleLabel.font = [UIFont fontWithName:@"NIISans-Bold" size:18];
    [button addTarget:self
               action:@selector(cerrar_precio)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Aceptar" forState:UIControlStateNormal];
    
    button.frame = CGRectMake(58, 4, 160.0, 40.0);
    [linea addSubview:button];
    
    [preciov addSubview:alerta];
    [self.view addSubview:preciov];
    
}
-(IBAction)contacto:(id)sender
{
    contactov=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    contactov.backgroundColor=[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3];
    
    UIView *alerta=[[UIView alloc]initWithFrame:CGRectMake(22, 200, 276, 150)];
    alerta.backgroundColor=[UIColor whiteColor];
    alerta.alpha=0.98;
    alerta.layer.cornerRadius = 5;
    alerta.layer.masksToBounds = YES;
    
    UILabel *desc=[[UILabel alloc]initWithFrame:CGRectMake(alerta.frame.size.width/2-35, 10, 100, 20)];
    //desc.tintColor=[UIColor redColor];
    //desc.textColor=[UIColor redColor];
    desc.text=@"Contacto";
    desc.font=[UIFont fontWithName:@"NIISans-Bold" size:18];
    [alerta addSubview:desc];
    
    UITextView *texto=[[UITextView alloc]initWithFrame:CGRectMake(14, 40, 252, 70)];
    texto.editable=NO;
    [texto setFont:[UIFont fontWithName:@"NIISans" size:13]];
    [texto setTextAlignment:NSTextAlignmentCenter];
    texto.backgroundColor=[UIColor clearColor];
    texto.text=[_evento objectForKey:@"contacto"];
    [alerta addSubview:texto];
    
    
    UIView *linea=[[UIView alloc]initWithFrame:CGRectMake(0, texto.frame.size.height+40, 276, 40)];
    linea.backgroundColor=[UIColor redColor];
    [alerta addSubview:linea];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // button.tintColor=[UIColor colorWithRed:24/255 green:156/255 blue:255/255 alpha:1];
    button.tintColor=[UIColor whiteColor];
    
    button.titleLabel.font = [UIFont fontWithName:@"NIISans-Bold" size:18];
    [button addTarget:self
               action:@selector(cerrar_contacto)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Aceptar" forState:UIControlStateNormal];
    
    button.frame = CGRectMake(58, 4, 160.0, 40.0);
    [linea addSubview:button];
    
    [contactov addSubview:alerta];
    [self.view addSubview:contactov];
}
-(IBAction)web:(id)sender
{
   
    ResenaViewController *resena1 ;
    resena1 = [[self storyboard] instantiateViewControllerWithIdentifier:@"resena"];
    resena1.texto=[_evento objectForKey:@"pagina"];
    
     [self presentViewController:resena1 animated:YES completion:NULL];
    
    
}




@end
