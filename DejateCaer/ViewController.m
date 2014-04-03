//
//  ViewController.m
//  DejateCaer
//
//  Created by Carlos Castellanos on 12/03/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import "ViewController.h"
#import "eventCell.h"
#import "DescripcionViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "Mipin.h"
#import "CalloutAnnotation.h"
@interface ViewController ()

@end

@implementation ViewController
{
    NSArray *eventos;
    NSString *currentLatitud;
    NSString *currentLongitud;
    NSString *radio;
    NSString *radio_anterior;
    BOOL touchMap;
    BOOL isDidLoad;
    UITapGestureRecognizer* touchViewGest;
    UITapGestureRecognizer* tapRecMap;
    
    AppDelegate *delegate;
    Mipin *annotationPointUbication;
    
    UIView *loading;
    UIActivityIndicatorView *spinner;
}
@synthesize mapa,LocationManager;
-(void)slideMenu{
    
}
- (void)viewDidLoad
{
    //Añadimos un escuchado de eventos de notificationController  para recargar la pagina
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"SlideMenu" object:nil];
    
    //Le asignamos el valor falso a la variable ShowMenu ya que en un
    //principio el menu esta escondido
    self.revealViewController.showMenu=FALSE;
    
    //Decimos que isDidload es True cada que se comienza cargando esta vew
    isDidLoad=TRUE;
    
    //Decimos que el mapa no ah sido tocado
    touchMap=FALSE;
    
    //declaramos un variable que nos servira como delegado
    delegate= (AppDelegate *) [[UIApplication sharedApplication] delegate];
    ;
    //Titulo para la vista en el navegation controller
    self.title=@"Eventos";
    
    //llamamos metodo para crear vista de loading
    [self crearLoadingView];
    
    //Asiganamos delegado de SWRevalmenu para un boto y tenga una accion
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    
    //Creamos gesto para que un evento suceda cuando tocamos el mapa y lo pegamos a la vista mapa
    tapRecMap = [[UITapGestureRecognizer alloc]
                 initWithTarget:self action:@selector(touchMaps)];
    [mapa addGestureRecognizer:tapRecMap];
    
    
    // Damos gesto de SWReveal para mostrar el menu al hacer Slide en la vista
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    //Copiamos el radio del delegado por default es  2000 metros
    radio=delegate.user_radio;//@"2000";
    
    
    LocationManager = [[CLLocationManager alloc] init];
    LocationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    LocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [LocationManager startUpdatingLocation];
    
    
    
    [mapa setDelegate:self];
    
    
    //llamamos metodo para crear la tabla
    [self crearTabla];
    
    
    //obtenemos los eventos
    [self llamada_asincrona];
    
    
    
    [super viewDidLoad];
	
}
-(void)crearTabla{
    //Creamos la tabla  y la escondemos
    //Cambiar 346 por el largo de la pantalla -222
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 222, 320, self.view.frame.size.height-222)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.rowHeight=90;
    _tableView.backgroundColor=[UIColor redColor];
    _tableView.hidden=TRUE;
    [self.view addSubview:_tableView];
}
-(void)crearLoadingView{
    //Creamos vista que contiene el spinner y lo enseñamos al usuario
    loading=[[UIView alloc]initWithFrame:CGRectMake(10, 75
                                                    , self.view.frame.size.width-20, self.view.frame.size.height-84)];
    loading.backgroundColor=[UIColor blackColor];
    loading.alpha=0.8;
    loading.layer.cornerRadius = 5;
    loading.layer.masksToBounds = YES;
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:CGPointMake(loading.frame.size.width/2.0, loading.frame.size.height/2.0)];
    [spinner startAnimating];
    [loading addSubview:spinner];
    [self.view addSubview:loading];
    
}

-(void)llamada_asincrona{
    //obtenemos la posicion del usuario
    currentLatitud=[NSString stringWithFormat:@"%.8f", LocationManager.location.coordinate.latitude];
    currentLongitud=[NSString stringWithFormat:@"%.8f", LocationManager.location.coordinate.longitude];
    // guardamos el radio anteriot
    radio_anterior=radio;
    
    NSString *urlString =@"http://codigo.labplc.mx/~rockarloz/dejatecaer/dejatecaer.php";
    NSString *url=[NSString stringWithFormat:@"%@?longitud=%@&latitud=%@&radio=%@&fecha=2014-03-18",urlString,currentLongitud,currentLatitud,radio];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        if ([data length] >0  )
        {
            NSArray *lugares;
            NSString *dato=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSMutableString * miCadena = [NSMutableString stringWithString: dato];
            NSData *data1 = [miCadena dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
            
            NSMutableDictionary *consulta=[[NSMutableDictionary alloc]init];
            consulta = [jsonObject objectForKey:@"eventos"];
            lugares= [jsonObject objectForKey:@"eventos"];//[consulta objectForKey:@"ubicaciones"];
            eventos=lugares;
            
            //Mandamos a llamar la lista para llenarla y enseñarla
            [self getLista];
        }
    });
    
}

-(void)getLista {
    
    // Revisamos si los eventos son pocos (4) para redimencionar la tabla y no poder scrollear
    if ([eventos count] <5 && [eventos count] >0) {
        CGRect frame;
        frame.size.height=([eventos count]*90);
        frame.size.width=320;
        frame.origin.x=0;
        frame.origin.y=222;
        _tableView.frame=frame;
        _tableView.scrollEnabled=FALSE;
        [self.tableView reloadData];
        _tableView.hidden=FALSE;
        //[self.view addSubview:_tableView];
        
    }
    else if ([eventos count]>5){
        // [self.view addSubview:_tableView];
        [self.tableView reloadData];
        _tableView.hidden=FALSE;
        
    }
    else{
        //[self.tableView reloadData];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Mensaje" message:@"No tenemos eventos cercanos a ti con ese radio intenta ampliando el radio de busqueda" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        [alert show];
        _tableView.hidden=TRUE;
        
        //Como la tabla no se muestra por que esta vacia Agregamos Gesto a la vista vacia
        //Agregar a la vista el gesto que reconozca el touch
        touchViewGest = [[UITapGestureRecognizer alloc]
                         initWithTarget:self action:@selector(touchView)];
        [self.view addGestureRecognizer:touchViewGest];
        
    }
    
    [self getMapa];
}

-(void)getMapa
{
    //Quitamos todo los markers que pueda tener el mapa
    [mapa removeAnnotations:mapa.annotations];
    
    for(int i=0;i<[eventos count];i++) {
        
        NSMutableDictionary *lugar=[[NSMutableDictionary alloc]init];
        lugar=[eventos objectAtIndex:i];
        
        CLLocationCoordinate2D SCL;
        SCL.latitude = [[lugar objectForKey:@"latitud"] doubleValue];
        SCL.longitude = [[lugar objectForKey:@"longitud"]doubleValue];
        /*
         MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
         annotationPoint.coordinate = SCL;
         annotationPoint.title = [lugar objectForKey:@"nombre"];
         annotationPoint.subtitle = [lugar objectForKey:@"direccion"];
         
         
         */
        
        CGFloat newLat = [[lugar objectForKey:@"latitud"] doubleValue];
        CGFloat newLon = [[lugar objectForKey:@"longitud"] doubleValue];
        
        CLLocationCoordinate2D newCoord = {newLat, newLon};
        
        Mipin *annotationPoint = [[Mipin alloc] initWithTitle:[lugar objectForKey:@"nombre"] subtitle:[lugar objectForKey:@"direccion"] andCoordinate:newCoord tipo:@"" evento:i];
        [mapa addAnnotation:annotationPoint];
    }
    
    //Quitamos la vista de loading y paramos el spinner
    [spinner stopAnimating];
    //[loading removeFromSuperview];
    loading.hidden=TRUE;
    
    //obtememos la localizacion actual del usuario
    [self getCurrentLocation:nil];
    
}


- (IBAction)getCurrentLocation:(id)sender {
    
    [mapa removeAnnotation:annotationPointUbication];
    annotationPointUbication=nil;
    CLLocationCoordinate2D SCL;
    NSString *lat=[NSString stringWithFormat:@"%.8f", LocationManager.location.coordinate.latitude];
    ;
    NSString *lot=[NSString stringWithFormat:@"%.8f", LocationManager.location.coordinate.longitude];
    ;
    SCL.latitude = [lat doubleValue];
    SCL.longitude = [lot doubleValue];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(SCL, 2000, 2000);
    [mapa setShowsUserLocation:YES];
    [mapa setRegion:region animated:YES];
    //aqui debemos añadir un pin personalizado
    /*
     CGFloat newLat = [lat doubleValue];
     CGFloat newLon = [lot doubleValue];
     
     CLLocationCoordinate2D newCoord = {newLat, newLon};
     
     annotationPointUbication = [[Mipin alloc] initWithTitle:@"" subtitle:@"" andCoordinate:newCoord tipo:@"ubicacion" evento:0];
     
     
     
     [mapa addAnnotation:annotationPointUbication];*/
    
}

-(void)touchMaps{
    isDidLoad=FALSE;
    touchMap=TRUE;
    [UIView animateWithDuration:0.5
                          delay:0.2
                        options: 1
                     animations:^{
                         //mapa.frame = CGRectMake(0, 64, 320, 500);
                         
                         
                         
                     }
                     completion:^(BOOL finished){
                         if (finished){
                             mapa.frame = CGRectMake(0, 64, 320, self.view.frame.size.height-90);
                             CGRect frame;
                             frame.origin.x=0;
                             frame.size.height=([eventos count]*90);
                             frame.size.width=320;
                             frame.origin.y=self.view.frame.size.height-90;
                             _tableView.frame=frame;
                         }
                     }];
    [self.mapa removeGestureRecognizer:tapRecMap];
}

-(void)touchView{
    
    if ([self.revealViewController showMenu]) {
        [self.revealViewController revealToggle:self];
        //   [_tableView removeFromSuperview];
        
        [self viewDidLoad];
        [self.view removeGestureRecognizer:touchViewGest];
    }
    
}

-(void)resizeMap{
    [mapa addGestureRecognizer:tapRecMap];
    touchMap=FALSE;
    isDidLoad=FALSE;
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationCurveEaseIn
                     animations:^{
                         mapa.frame = CGRectMake(0, 64, 320,158);
                         //mapa.frame = CGRectMake(0, 64, 320, 500);
                         CGRect frame;
                         if ([eventos count] <5 && [eventos count] >0) {
                             
                             frame.size.height=([eventos count]*90);
                             frame.size.width=320;
                             frame.origin.x=0;
                             frame.origin.y=222;
                             _tableView.frame=frame;
                             _tableView.scrollEnabled=FALSE;
                             //[self.view addSubview:_tableView];
                             _tableView.hidden=FALSE;
                             [self.tableView reloadData];
                         }
                         else if ([eventos count]>5){
                             frame.origin.x=0;
                             frame.size.height=self.view.frame.size.height-222;//([eventos count]*75);
                             frame.size.width=320;
                             frame.origin.y=222;
                             _tableView.frame=frame;
                             _tableView.hidden=FALSE;
                             // [self.view addSubview:_tableView];
                             [self.tableView reloadData];
                         }
                         /*CGRect frame;
                          frame.origin.x=0;
                          frame.size.height=self.view.frame.size.height-222;//([eventos count]*75);
                          frame.size.width=320;
                          frame.origin.y=222;
                          _tableView.frame=frame;*/
                         
                     }
                     completion:^(BOOL finished){
                         if (finished)
                         {}
                         //  mapa.backgroundColor=[UIColor blackColor];
                         
                         //  [top_menu removeFromSuperview];
                         //   NSLog(@"falso");
                     }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if ([self.revealViewController showMenu]) {
        [self.revealViewController revealToggle:self];
        // [_tableView removeFromSuperview];
        _tableView.hidden=TRUE;
        [self reload];
    }
    
    else{
        if (indexPath.row==0 && touchMap==TRUE) {
            
            [self resizeMap];
        }
        else{
            
            DescripcionViewController *detalles;//=[[DescripcionViewController alloc]init];
            detalles = [[self storyboard] instantiateViewControllerWithIdentifier:@"descripcion"];
            detalles.evento=[eventos objectAtIndex:indexPath.row];
            detalles.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self.navigationController pushViewController:detalles animated:YES];
        }
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [eventos count];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  NSLog(@"paso a celda");
    // static NSString *simpleTableIdentifier = @"SimpleTableItem";
    // eventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell"];
    eventCell *cell=[[eventCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customCell"];
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        //  NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"evento_cell" owner:self options:nil];
        //  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        // cell = [topLevelObjects objectAtIndex:0];
    }
    cell.nombre.text= [[eventos objectAtIndex:indexPath.row ]   objectForKey:@"nombre"];
    cell.hora.text= [[eventos objectAtIndex:indexPath.row ]   objectForKey:@"hora"];
    double metros= [[[eventos objectAtIndex:indexPath.row ]   objectForKey:@"distancia"] doubleValue];
    if (metros>=1000) {
        metros=(metros/1000);
        
        cell.distancia.text= [NSString stringWithFormat:(@"%.2f Km"),metros];
    }
    else{
        cell.distancia.text= [NSString stringWithFormat:(@"%@ m"),[[eventos objectAtIndex:indexPath.row ]   objectForKey:@"distancia"]];
    }
    
    // cell.textLabel.text = [[eventos objectAtIndex:indexPath.row ]   objectForKey:@"nombre"];
    return cell;
}



/*
 - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
 NSIndexPath *firstVisibleIndexPath = [[self.tableView indexPathsForVisibleRows] objectAtIndex:0];
 if (firstVisibleIndexPath.row==0) {
 NSLog(@"first visible cell's section: %i, row: %i", firstVisibleIndexPath.section, firstVisibleIndexPath.row);
 }
 
 }*/

- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id<MKAnnotation>) annotation {
    
    
    if ([annotation isKindOfClass:[CalloutAnnotation class]]) {
        return nil;
        // NSLog(@"fue letrerito");
    }
    else{
        Mipin  *anotacion1 = (Mipin*)annotation;
        
        
        // Comprobamos si se trata de la anotación correspondiente al usuario.
        if ([annotation isKindOfClass:[MKUserLocation class]])
        {
            return nil;
        }
        
        MKAnnotationView *aView = [[MKAnnotationView alloc] initWithAnnotation:anotacion1 reuseIdentifier:@"pinView"];
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton setTitle:annotation.title forState:UIControlStateNormal];
        [aView setRightCalloutAccessoryView:rightButton];
        
        //\\-------------------------------------------------------------------------------///
        //Creo el nombre de la imagen
        //\\-------------------------------------------------------------------------------///
        
        
        
        //\\-------------------------------------------------------------------------------///
        // Configuramos la vista del mapa
        //\\-------------------------------------------------------------------------------///
        aView.canShowCallout = YES;
        aView.enabled = YES;
        aView.centerOffset = CGPointMake(0, -20);
        aView.tag=anotacion1.id_event;
        aView.draggable = YES;
        UIImage *imagen;
        if ([anotacion1.tipo isEqualToString:@"ubicacion"]) {
            imagen = [UIImage imageNamed:@"here.png"];
        }
        else{
            imagen = [UIImage imageNamed:@"markerblue.png"];
        }
        
        aView.image = imagen;
        //\\-------------------------------------------------------------------------------///
        // Establecemos el tamaño óptimo para el Pin
        //\\-------------------------------------------------------------------------------///
        
        if ([anotacion1.tipo isEqualToString:@"ubicacion"]) {
            CGRect frame = aView.frame;
            frame.size.width = 20;
            frame.size.height = 20;
            aView.frame = frame;
        }
        else{
            CGRect frame = aView.frame;
            frame.size.width = 35;
            frame.size.height = 40;
            aView.frame = frame;
            
        }
        
        
        return aView;}
    
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    
    DescripcionViewController *detalles;//=[[DescripcionViewController alloc]init];
    detalles = [[self storyboard] instantiateViewControllerWithIdentifier:@"descripcion"];
    detalles.evento=[eventos objectAtIndex:view.tag];
    detalles.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:detalles animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (!isDidLoad) { //paso al didLoad?
        // NSLog(@"volviste");
        [mapa addGestureRecognizer:tapRecMap];
        CGRect frame;
        if ([eventos count] <5 && [eventos count] >0) {
            
            frame.size.height=([eventos count]*90);
            frame.size.width=320;
            frame.origin.x=0;
            frame.origin.y=222;
            _tableView.frame=frame;
            _tableView.scrollEnabled=FALSE;
            _tableView.hidden=FALSE;
            //[self.view addSubview:_tableView];
            [self.tableView reloadData];
        }
        else if ([eventos count]>5){
            frame.origin.x=0;
            frame.size.height=self.view.frame.size.height-222;//([eventos count]*75);
            frame.size.width=320;
            frame.origin.y=222;
            _tableView.frame=frame;
            _tableView.hidden=FALSE;
            //[self.view addSubview:_tableView];
            [self.tableView reloadData];
        }
        
    }
}

-(void)reload{
    NSLog(@"reload");
    radio=delegate.user_radio;
    [self llamada_asincrona];
}

@end
