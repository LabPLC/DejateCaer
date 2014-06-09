//
//  ViewController.m
//  DejateCaer
//  @rockarloz
//  rockarlos@me.com
//  Created by Carlos Castellanos on 12/03/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//
#define SCROLL_UPDATE_DISTANCE          .80
#import "ViewController.h"
#import "eventCell.h"
#import "SinEventoTableViewCell.h"
#import "DescripcionViewController.h"
#import "AppDelegate.h"
#import "Mipin.h"
#import "CustomCalloutAnnotation.h"




@interface ViewController ()
@property (strong, nonatomic)   UITapGestureRecognizer  *tapMapViewGesture;
@property (strong, nonatomic)   UITapGestureRecognizer  *tapTableViewGesture;

@end

@implementation ViewController
{
 
  //  NSArray *eventos;
    NSString *currentLatitud;
    NSString *currentLongitud;
    NSString *radio;
    NSString *radio_anterior;
    int moviendo;
    BOOL isEmpty;
    
    BOOL isArrow;  //diseño
    UIView *flechas; //diseño
    UITapGestureRecognizer* tapFlechas;//diseño
    UIButton *encuentrame;//diseño
    UIButton *herramientas;//diseño
    UITextField *buscar;//diseño
    UIView *contenedor_flotante;
    UIView *vista_auxiliar;
    UIButton *bucar_aqui;
   
  
    UITapGestureRecognizer* tapDetails;//diseño
    UITapGestureRecognizer* tapRecMap;
    UIView *opcciones;
    // UIView *vista_atras;
    
    AppDelegate *delegate;
    CLLocationCoordinate2D initialLocation;
 
    //Vista de Loading que se presenta mientras se hace la peticion 
    UIView *loading;
    UIActivityIndicatorView *spinner;
}
@synthesize mapa,LocationManager,eventos;

@synthesize heighTableView          = _heighTableView;



-(id)init{
    self =  [super init];
    if(self){
       
    }
    return self;
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    //variable para contar las veces que se mueve el mapa
    moviendo=0;
    //Definde Fondo de la vista
    self.view.backgroundColor=[UIColor whiteColor];
   // self.view.backgroundColor=[UIColor colorWithRed:(243/255.0) green:(23/255.0) blue:(52/255.0) alpha:1];
   
    
    //Banderas para las vistas
    isArrow=FALSE;
    delegate.isOption=FALSE;
  
    //Añadimos un escuchado de eventos de notificationController  para recargar la pagina
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cerrarOpcciones) name:@"aceptar" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actualizar) name:@"actualizar" object:nil];

    //declaramos un variable que nos servira como delegado
    delegate= (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
   
    
    //Copiamos el radio del delegado por default es  2000 metros
    radio=delegate.user_radio;//@"2000";
    [self crearBarraBusqueda];
    
    [mapa setDelegate:self];
    //obtenemos la ubicacion del usuario y centramos el mapa ahi
    LocationManager = [[CLLocationManager alloc] init];
    
    LocationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    LocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [LocationManager startUpdatingLocation];
    
    
    
    
    initialLocation.latitude = LocationManager.location.coordinate.latitude-0.020;
    initialLocation.longitude = LocationManager.location.coordinate.longitude;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(initialLocation, 4000, 4000);
    [mapa setShowsUserLocation:YES];
    [mapa setRegion:region animated:YES];
    
    
    
    //llamamos metodo para crear la tabla
    [self crearTabla];
    
    //iniciamos el mapa
    [self setupMapView];
    

    
    [self crearLoadingView];
    
    //obtenemos los eventos
    [self obtenerEventos:LocationManager.location.coordinate.latitude Y:LocationManager.location.coordinate.longitude];
    //iniciamos con la lista de evnetos oculta
    [self handleTapMapView:nil];
    
    [super viewDidLoad];
    
	
}

-(void)crearTabla{
    
    
    _tableView = [[UITableView alloc]  initWithFrame: CGRectMake(0, 64, 320, self.view.frame.size.height-64)];
    
    _tableView.tableHeaderView  = [[UIView alloc]       initWithFrame: CGRectMake(0.0, 0.0, self.view.frame.size.width, 290)];
    _tableView.rowHeight=90;
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.tableHeaderView.backgroundColor=[UIColor grayColor];
   [self.tableView setSeparatorColor:[UIColor redColor]];
    // Add Gestoss
    _tapMapViewGesture      = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                      action:@selector(handleTapMapView:)];
    _tapTableViewGesture    = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                      action:@selector(handleTapTableView:)];
    [_tableView.tableHeaderView addGestureRecognizer:_tapMapViewGesture];
   
    
    _tableView.dataSource   = self;
    _tableView.delegate     = self;
    [self.view addSubview:_tableView];
    
    tapFlechas = [[UITapGestureRecognizer alloc]
                  initWithTarget:self action:@selector(touchTabla)];
    
    
       
    [flechas addGestureRecognizer:tapFlechas];
    _tableView.scrollEnabled=FALSE;
    
}

-(void)setupMapView{
    mapa                        = [[MKMapView alloc] initWithFrame:CGRectMake(0, 64, 320, _heighTableView)];
    mapa.rotateEnabled = NO;
    [mapa setShowsUserLocation:YES];
    mapa.delegate = self;
    [self.view insertSubview:mapa
                belowSubview: _tableView];
    UITapGestureRecognizer* tapRec = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(touchMap)];
    [mapa addGestureRecognizer:tapRec];
    [self crearBuscaAqui];
}


#pragma mark - Comportamiento de la vista del mapa y lista

//vista de la lista escondida
- (void)handleTapMapView:(UIGestureRecognizer *)gesture {
    isArrow=NO;
    UIView *linea=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
    linea.backgroundColor=[UIColor clearColor];
    UIImageView *mas=[[UIImageView alloc]initWithFrame:CGRectMake(140, 5, 45, 45)];
    mas.image=[UIImage imageNamed:@"mas.png"];
    mas.hidden=TRUE;
     [self.view endEditing:YES];
    //NSLog(@"lista escondida");
      [_tableView setContentOffset:CGPointMake(0, 0) animated:NO];
      // [self.tableView setContentOffset:CGPointZero animated:NO];
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                                                  //custom al mapa
                         mapa.frame = CGRectMake(0, 20, 320, self.view.frame.size.height-73);
                         [mapa addSubview:contenedor_flotante];
                         self.tableView.frame           = CGRectMake(0, self.view.frame.size.height-53,320, 53);
                        
                                                  self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 53)];
                         
                         //NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"flechas" owner:nil options:nil];
                         
                         // Cargamos la vista desde el XIB
                         // flechas = [nibContents lastObject];
                        
                         
                         UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 52)];
                         view2.backgroundColor=[UIColor clearColor];
                         [flechas addGestureRecognizer:tapFlechas];
                        
                         [self.tableView.tableHeaderView addSubview:linea];
                         [self.tableView.tableHeaderView addSubview:mas];
                         [self.tableView.tableHeaderView addSubview:view2];
                         [view2 addGestureRecognizer:tapFlechas];
                         
                        

                     }
                     completion:^(BOOL finished){
                         

                         linea.backgroundColor=[UIColor blackColor];
                         mas.hidden=FALSE;
                        
                         self.tableView.tableHeaderView.userInteractionEnabled = YES;
                         UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc]
                                                        initWithTarget:self action:@selector(handlePan:)];
                         [pgr setMinimumNumberOfTouches:1];
                         [pgr setMaximumNumberOfTouches:1];
                         [pgr setDelegate:self];
                         
                         [self.tableView.tableHeaderView addGestureRecognizer:pgr];

                         
                         
                         [self.tableView.tableHeaderView addSubview:flechas];
                           _tableView.scrollEnabled=FALSE;
                         [self.tableView.tableHeaderView addGestureRecognizer:_tapMapViewGesture];
                         flechas.hidden=FALSE;
                     }];
    
    
}


- (void)handleTapTableView:(UIGestureRecognizer *)gesture {
    
   // NSLog(@"push on the header");
}


-(int)respuestaObtenerEventos{
    if (!isEmpty) {
        //si tiene evento
          return 1;
    }
    else {
        //no tiene eventos
        return 0;
    }
}



-(void)obtenerEventos :(float) latitud Y : (float) longitud {
    
    //obtenemos la posicion del usuario
    currentLatitud=[NSString stringWithFormat:@"%.8f", latitud];
    currentLongitud=[NSString stringWithFormat:@"%.8f", longitud];
    radio=delegate.user_radio;
    // guardamos el radio anteriot
    radio_anterior=radio;
    
    NSString *urlString =@"http://eventario.mx/eventos.json";
    NSString *url=[NSString stringWithFormat:@"%@?lon=%@&lat=%@&dist=%@",urlString,currentLongitud,currentLatitud,radio];
   // NSString *url=@"http://dev.codigo.labplc.mx/EventarioWeb/eventos.json";
    NSLog(@"%@",url);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        if ([data length] >0  )
        {
                      NSString *dato=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSMutableString * miCadena = [NSMutableString stringWithString: dato];
            NSData *data1 = [miCadena dataUsingEncoding:NSUTF8StringEncoding];
            
           
           // lugares= [jsonObject objectForKey:@"eventos"];//[consulta objectForKey:@"ubicaciones"];
            
            eventos=[NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
            
            
            


            
            if ([eventos count]==0) {
                _tableView.rowHeight=450;
                NSArray *vacio=[[NSArray alloc]initWithObjects:@"VACIO", nil];
                eventos=vacio;
                isEmpty=TRUE;
                UIAlertView *alerta=[[UIAlertView alloc]initWithTitle:@"Mensaje" message:@"No encontramos eventos cerca de este lugar intenta ampliando el radio desde el menú opcciones" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                [alerta show];
                
                [self getMapa:latitud Y :longitud];
                [self.tableView reloadData];
                [self respuestaObtenerEventos];
                
            }
            else{
                for (int i=0; i<=[eventos count]-1; i++) {
                    NSString *d=[[eventos objectAtIndex:i] objectForKey:@"imagen"];
                    
                    [self performSelectorInBackground: @selector(buscar_imagen:) withObject: d];
                }
                _tableView.rowHeight=90;
                isEmpty=FALSE;
                //Mandamos a llamar la lista para llenarla y enseñarla
                [self getMapa:latitud Y :longitud];
                
                [self.tableView reloadData];
                  [self respuestaObtenerEventos];
                
                
            }
           // [self respuetaObtenerEventos:1];
            //[self getLista];
            
        }
        else {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Mensaje" message:@"Revisa tu conexión de internet y  vuelve a intentarlo. " delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
            [alert show];
            _tableView.rowHeight=450;
            NSArray *vacio=[[NSArray alloc]initWithObjects:@"VACIO", nil];
            eventos=vacio;
            isEmpty=TRUE;
          
            [self getMapa:latitud Y :longitud];
            [self.tableView reloadData];

            loading.hidden=TRUE;
              [self respuestaObtenerEventos];
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
        
        
    }
    
    // [self getMapa];
}

-(void)getMapa :(float) latitud Y : (float) longitud
{
    //Quitamos todo los markers que pueda tener el mapa
    [mapa removeAnnotations:mapa.annotations];
   
    if (!isEmpty) {
        
        
        for(int i=0;i<([eventos count]);i++) {
            
            NSMutableDictionary *lugar=[[NSMutableDictionary alloc]init];
            lugar=[eventos objectAtIndex:i];
            
            CLLocationCoordinate2D SCL;
            SCL.latitude = [[lugar objectForKey:@"latitud"] doubleValue];
            SCL.longitude = [[lugar objectForKey:@"longitud"]doubleValue];
            
            
            CGFloat newLat = [[lugar objectForKey:@"latitud"] doubleValue];
            CGFloat newLon = [[lugar objectForKey:@"longitud"] doubleValue];
            
            CLLocationCoordinate2D newCoord = {newLat, newLon};
            
            Mipin *annotationPoint = [[Mipin alloc] initWithTitle:[lugar objectForKey:@"nombre"] subtitle:[lugar objectForKey:@"lugar"] andCoordinate:newCoord tipo:@"" evento:i lugar:[lugar objectForKey:@"lugar"] hora:[lugar objectForKey:@"hora_inicio"]];
            
            [mapa addAnnotation:annotationPoint];
        }}
    
    //Quitamos la vista de loading y paramos el spinner
    // [spinner stopAnimating];
    //[loading removeFromSuperview];
    loading.hidden=TRUE;
    CLLocationCoordinate2D SCL;
    SCL.latitude = latitud;
    SCL.longitude = longitud;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(SCL, 4000, 4000);
    [mapa setShowsUserLocation:YES];
    [mapa setRegion:region animated:YES];
    
    //obtememos la localizacion actual del usuario
    //[self getCurrentLocation:nil];
    
}


- (IBAction)getCurrentLocation:(id)sender {
    loading.hidden=FALSE;
    LocationManager = [[CLLocationManager alloc] init];
    LocationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    LocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [LocationManager startUpdatingLocation];
    CLLocationCoordinate2D SCL;
    
    SCL.latitude = LocationManager.location.coordinate.latitude;
    
    SCL.longitude = LocationManager.location.coordinate.longitude;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(SCL, 4000, 4000);
    [mapa setShowsUserLocation:YES];
    [mapa setRegion:region animated:YES];
    [self obtenerEventos:SCL.latitude Y:SCL.longitude];
    
    
}
#pragma mark - Table view Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (!isEmpty) {
        
        DescripcionViewController *detalles;//=[[DescripcionViewController alloc]init];
        if ([delegate.alto intValue] < 568)
        {
            detalles = [[self storyboard] instantiateViewControllerWithIdentifier:@"descripcion2"];
            
        }
        
        else
        {
            
            detalles = [[self storyboard] instantiateViewControllerWithIdentifier:@"descripcion"];
            
        }
   
        
    
    
    detalles.evento=[eventos objectAtIndex:indexPath.row];
    detalles.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
   // [self.navigationController pushViewController:detalles animated:YES];
    
    
    [self presentViewController:detalles animated:YES completion:NULL];
    
    }
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [eventos count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isEmpty) {
        
        
        eventCell *cell=[[eventCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customCell"];
        
        if(indexPath.row == 0){
            
            
            
        }
        
        
        if (cell == nil) {
        }
        
        
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        
       // [self buscar_imagen:[[eventos objectAtIndex:indexPath.row ]   objectForKey:@"imagen"]];
        
        NSString *cat=[NSString stringWithFormat:@("%@.png"),[[eventos objectAtIndex:indexPath.row ]   objectForKey:@"categoria"]];
        cell.imagen.image=[UIImage imageNamed:cat]; //[delegate.cacheImagenes objectForKey:[[eventos objectAtIndex:indexPath.row ]   objectForKey:@"imagen"]];
        
        cell.nombre.text= [[eventos objectAtIndex:indexPath.row ]   objectForKey:@"nombre"];
        NSString *horas=[[[eventos objectAtIndex:indexPath.row ]   objectForKey:@"hora_inicio"]
         stringByReplacingOccurrencesOfString:@"2000-01-01T" withString:@""];
        horas=[horas  stringByReplacingOccurrencesOfString:@":00Z" withString:@""];
       
        NSString *horasfin=[[[eventos objectAtIndex:indexPath.row ]   objectForKey:@"hora_fin"]
                         stringByReplacingOccurrencesOfString:@"2000-01-01T" withString:@""];
        horasfin=[horasfin  stringByReplacingOccurrencesOfString:@":00Z" withString:@""];
        
        cell.hora.text=[NSString stringWithFormat:@("%@ - %@"),horas,horasfin];
        //cell.hora.text= [[eventos objectAtIndex:indexPath.row ]   objectForKey:@"hora_inicio"];
        float metros= [[[eventos objectAtIndex:indexPath.row ]   objectForKey:@"distancia"] doubleValue];
        
        
        cell.distancia.text= [NSString stringWithFormat:(@"%.2f Km."),metros];
        /*
        if (metros>=1) {
            //metros=(metros/1000);
            
            cell.distancia.text= [NSString stringWithFormat:(@"%@ Km."),[[eventos objectAtIndex:indexPath.row ]   objectForKey:@"distancia"]];
        }
        else{
            NSLog(@"%@",[[eventos objectAtIndex:indexPath.row ] objectForKey:@"distancia"]);
            cell.distancia.text= [NSString stringWithFormat:(@"%@ m"),[[eventos objectAtIndex:indexPath.row ]   objectForKey:@"distancia"]];
        }*/
        return cell;
    }
    
    else{
        SinEventoTableViewCell *cell=[[SinEventoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customCell"];
        //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            //  NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"evento_cell" owner:self options:nil];
            //  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            // cell = [topLevelObjects objectAtIndex:0];
        }
        cell.nombre.text= @"No encontramos eventos cerca de este lugar intenta ampliando el radio";
        return cell;
        
    }
    
    // cell.textLabel.text = [[eventos objectAtIndex:indexPath.row ]   objectForKey:@"nombre"];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //first get total rows in that section by current indexPath.
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
    
    //this is the last row in section.
    if(indexPath.row == totalRow -1){
        // get total of cells's Height
        float cellsHeight = totalRow * cell.frame.size.height;
        // calculate tableView's Height with it's the header
        float tableHeight = (tableView.frame.size.height - tableView.tableHeaderView.frame.size.height);
        
        // Check if we need to create a foot to hide the backView (the map)
        if((cellsHeight - tableView.frame.origin.y)  < tableHeight){
            // Add a footer to hide the background
            int footerHeight = tableHeight - cellsHeight;
            tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, footerHeight)];
            
          //  [tableView.tableFooterView setBackgroundColor:[UIColor colorWithRed:(243/255.0) green:(23/255.0) blue:(52/255.0) alpha:1]];
            
            [tableView.tableFooterView setBackgroundColor:[UIColor whiteColor]];
        }
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)actualizar{
       radio=delegate.user_radio;
    
    [self getCurrentLocation:nil];
    
}
-(IBAction)opcciones:(id)sender
{

    delegate.isOption=TRUE;
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"Opcciones" owner:nil options:nil];
    
    // Find the view among nib contents (not too hard assuming there is only one view in it).
    opcciones = [nibContents lastObject];
    opcciones.frame=CGRectMake(2, 0, self.view.frame.size.width-4, self.view.frame.size.height);
    //opcciones.backgroundColor=[UIColor grayColor];
    opcciones.alpha=1;
    opcciones.layer.cornerRadius = 5;
    opcciones.layer.masksToBounds = YES;
    
    [UIView transitionFromView:self.view
                        toView:opcciones
                      duration:1
                       options:UIViewAnimationOptionBeginFromCurrentState
                    completion:nil];
    
  
    
}
-(void)cerrarOpcciones{
    delegate.isOption=FALSE;
    //self.navigationController.navigationBarHidden = NO;
    [UIView transitionFromView:opcciones
                        toView:self.view
                      duration:1
                       options:UIViewAnimationOptionBeginFromCurrentState
                    completion:nil];
    
    //[opcciones removeFromSuperview];
}
// vista de cuando se muestra la lista
-(void)touchTabla{
    if (!isArrow) {
     

        isArrow=TRUE; //diseño
        
       [UIView animateWithDuration:0.2
                              delay:0.1
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.tableView.frame           = CGRectMake(0, 20,320, self.view.frame.size.height-20);
                             
                             mapa.frame             = CGRectMake(0, 20, 320, 278);
                             [mapa addSubview:contenedor_flotante];
                             
                             
                             self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0, self.view.frame.size.width, self.view.frame.size.height/2+34)];
                             self.tableView.tableHeaderView.backgroundColor=[UIColor clearColor];
                             self.tableView.scrollEnabled=YES;
                             
                             NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"flechas_cierran" owner:nil options:nil];
                             
                             // llamar la vista desde el XIB
                           
                       
                             
                             
                             
                             flechas = [nibContents lastObject];
                             flechas.frame=CGRectMake(0, self.tableView.tableHeaderView.frame.size.height-40, 320, 50);
                             
                             
                             

                             
                           //  self.tableView.tableHeaderView.backgroundColor=[UIColor blackColor];
                                                         [self.tableView.tableHeaderView addSubview:flechas];
                             [flechas addGestureRecognizer:tapFlechas];
                             
                             
                             
                             
                             
                             
                         }
                         completion:^(BOOL finished){
                            
                             [self.tableView setScrollEnabled:YES];
                             [self.tableView.tableHeaderView addGestureRecognizer:_tapMapViewGesture];
                             
                          }];
    }
    else{
        isArrow=FALSE;
        [self handleTapMapView:nil];
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (buscar.text!=nil ) {
        if ([buscar.text isEqualToString:@" "]) {
            [self.view endEditing:YES];
            
        }
        else{
          
        }
    }
    
    else{
        [self.view endEditing:YES];
    }
    
        if (textField.text && textField.text.length > 0)
        {
           // NSLog(@"%@",buscar.text);
           // NSLog(@"%@",buscar.text);
            [self.view endEditing:YES];
            [self getPlaces];
        }
        else
        {
            UIAlertView *alerta=[[UIAlertView alloc]initWithTitle:@"Mensaje" message:@"Introduce un lugar de búsqueda" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
            [alerta show];
        }
     [self.view endEditing:YES];
        return YES;
}

-(void)getPlacesApple{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    NSString *direccion=[NSString stringWithFormat:@"%@,Mexico,distrito federal",buscar.text];
    [geocoder geocodeAddressString:direccion completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error)
        {
            UIAlertView *alerta=[[UIAlertView alloc]initWithTitle:@"Mensaje" message:@"No encontramos el lugar que buscas" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
            [alerta show];
           // NSLog(@"Geocode failed with error: %@", error);
            //[self displayError:error];
            
            return;
            
        }
        
        CLPlacemark *placemark=[placemarks objectAtIndex:0];
      //  NSLog(@"Received placemarks: %@", placemarks);
       // NSLog(@"%f,%f",placemark.location.coordinate.latitude,placemark.location.coordinate.longitude);
        loading.hidden=FALSE;
        [self obtenerEventos: placemark.location.coordinate.latitude Y:placemark.location.coordinate.longitude];
        //[self displayPlacemarks:placemarks];
    }];
    
}

#pragma mark - MapView Delegate

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
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [rightButton setTitle:annotation.title forState:UIControlStateNormal];
    [aView setRightCalloutAccessoryView:rightButton];
    
    // [aView setBackgroundColor:[UIColor colorWithRed:(243/255.0) green:(23/255.0) blue:(52/255.0) alpha:0.7]];
    
    aView.canShowCallout = YES;
    aView.enabled = YES;
    aView.centerOffset = CGPointMake(0, -20);
    aView.tag=anotacion1.id_event;
    aView.draggable = YES;
    UIImage *imagen;
    if ([anotacion1.tipo isEqualToString:@"ubicacion"]) {
        imagen = [UIImage imageNamed:@"yo.png"];
    }
    else{
        imagen = [UIImage imageNamed:@"pin2.png"];
    }
    
    aView.image = imagen;
    //\\-------------------------------------------------------------------------------///
    // Establecemos el tamaño óptimo para el Pin
    //\\-------------------------------------------------------------------------------///
    
    if ([anotacion1.tipo isEqualToString:@"ubicacion"]) {
        CGRect frame = aView.frame;
        frame.size.width = 43;
        frame.size.height = 71;
        aView.frame = frame;
    }
    else{
        CGRect frame = aView.frame;
        frame.size.width = 30;
        frame.size.height = 40;
        aView.frame = frame;
        
    }
    
    
    return aView;
    //}
    
    
}
//Metodo para ir a la siguiente vista desde el boton del CallOut en el marcador
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    
    
    DescripcionViewController *detalles;//=[[DescripcionViewController alloc]init];
    if ([delegate.alto intValue] < 568)
    {
        detalles = [[self storyboard] instantiateViewControllerWithIdentifier:@"descripcion2"];
        
    }
    
    else
    {
        
        detalles = [[self storyboard] instantiateViewControllerWithIdentifier:@"descripcion"];
        
    }
    
    // detalles = [[self storyboard] instantiateViewControllerWithIdentifier:@"descripcion"];
    detalles.evento=[eventos objectAtIndex:view.tag];
    detalles.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:detalles animated:YES completion:NULL];
}


-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    for (UIView *subview in view.subviews ){
        [subview removeFromSuperview];
    }
}

//Metodo para Cambiar el CallOutView del Marker en el mapa
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
   
    /*if(![view.annotation isKindOfClass:[MKUserLocation class]]) {
        CustomCalloutAnnotation *calloutView = (CustomCalloutAnnotation *)[[[NSBundle mainBundle] loadNibNamed:@"CustomCallOutView" owner:self options:nil] objectAtIndex:0];
        CGRect calloutViewFrame = calloutView.frame;
        calloutViewFrame.origin = CGPointMake(-calloutViewFrame.size.width/2 + 85, -calloutViewFrame.size.height);
        calloutView.frame = calloutViewFrame;
        calloutView.nombre.text=@"fsdfr";
        [calloutView.nombre setText:[(Mipin*)[view annotation] title]];
        [calloutView.lugar setText:[(Mipin*)[view annotation] lugar]];
        [calloutView.hora setText:[(Mipin*)[view annotation] hora]];
        UIView *d=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 00)];
        d.backgroundColor=[UIColor greenColor];
        [calloutView addSubview:d];
        [calloutView addGestureRecognizer:tapDetails];
        [view addSubview:calloutView];
         
        
    }*/
     }

-(void)touchMap{
     [self.view endEditing:YES];
}


-(IBAction)getCenter:(id)sender{
    [bucar_aqui removeFromSuperview];
    loading.hidden=FALSE;
    
    [self.view endEditing:YES];
    CLLocationCoordinate2D centre = [mapa centerCoordinate];
   // NSLog(@"%f, %f", centre.latitude, centre.longitude);
    //[mapa removeAnnotation:annotationPointUbication];
    radio=delegate.user_radio;
   // annotationPointUbication = [[Mipin alloc] initWithTitle:@"Centro" subtitle:@"" andCoordinate:centre tipo:@"ubicacion" evento:0];
    
    // [mapa addAnnotation:annotationPointUbication];
    
    //obtenemos la posicion del usuario
    currentLatitud=[NSString stringWithFormat:@"%.8f", centre.latitude];
    currentLongitud=[NSString stringWithFormat:@"%.8f", centre.longitude];
    // guardamos el radio anteriot
    [self obtenerEventos:centre.latitude Y:centre.longitude];
    
}



#pragma mark - Creando Vistas Auxiliates
-(void)crearLoadingView{
    //Creamos vista que contiene el spinner y lo enseñamos al usuario
    loading=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25, self.view.frame.size.height/2 -50, 50, 50)];
    loading.backgroundColor=[UIColor colorWithRed:(243/255.0) green:(23/255.0) blue:(52/255.0) alpha:0.8];
   // loading.alpha=0.8;
    loading.layer.cornerRadius = 5;
    loading.layer.masksToBounds = YES;
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:CGPointMake(loading.frame.size.width/2.0, loading.frame.size.height/2.0)];
    [spinner startAnimating];
    [loading addSubview:spinner];
    [self.view addSubview:loading];
    
    
}

-(void)crearBarraBusqueda{
    //Crea contenedor de busqueda
    contenedor_flotante=[[UIView alloc]initWithFrame:CGRectMake(5, 5, 310, 35)];
    contenedor_flotante.backgroundColor=[UIColor blackColor];
    vista_auxiliar=[[UIView alloc]initWithFrame:CGRectMake(1, 1, 308, 33)];
    vista_auxiliar.backgroundColor=[UIColor whiteColor];
    [contenedor_flotante addSubview:vista_auxiliar];

    
    UIImageView *lupa=[[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 15, 15)];
    lupa.image=[UIImage imageNamed:@"lupa.png"];
    [vista_auxiliar addSubview:lupa];
    
    buscar=[[UITextField alloc]initWithFrame:CGRectMake(37, 0, 205, 35)];
    buscar.delegate = self;
    buscar.placeholder=@"Zamora 54,Condesa,Cuahutemoc";
    [buscar setFont:[UIFont systemFontOfSize:10]];
    buscar.returnKeyType = UIReturnKeySearch;

    [vista_auxiliar addSubview:buscar];
    
    UIView * aux=[[UIView alloc]initWithFrame:CGRectMake(240, 0, 1, 34)];
    aux.backgroundColor=[UIColor blackColor];
    
    encuentrame = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [encuentrame addTarget:self
                    action:@selector(getCurrentLocation:)
          forControlEvents:UIControlEventTouchUpInside];
    encuentrame.frame = CGRectMake(240, 0, 35, 35);
    UIImage *btnImage = [UIImage imageNamed:@"flecha2.png"];
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, encuentrame.frame.size.width, encuentrame.frame.size.height)];
    img.image=btnImage;
    [encuentrame setBackgroundImage:btnImage forState:UIControlStateNormal];
    //[encuentrame addSubview:img];
    
    UIView * aux2=[[UIView alloc]initWithFrame:CGRectMake(275, 0, 1, 34)];
    aux2.backgroundColor=[UIColor blackColor];
    herramientas = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [herramientas addTarget:self
                     action:@selector(opcciones:)
           forControlEvents:UIControlEventTouchUpInside];
    herramientas.frame = CGRectMake(275, 0, 35, 35);
    UIImage *btnImage2 = [UIImage imageNamed:@"tools.png"];
    UIImageView *img2=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, herramientas.frame.size.width, herramientas.frame.size.height)];
      [herramientas setBackgroundImage:btnImage2 forState:UIControlStateNormal];
    //img2.image=btnImage2;
    [herramientas addSubview:img2];
    [vista_auxiliar addSubview:aux2];
    [vista_auxiliar addSubview:aux];
    [vista_auxiliar addSubview:encuentrame];
    [vista_auxiliar addSubview:herramientas];
    //Termina contenedor de busqueda
    
    
}

-(void)crearBuscaAqui{
bucar_aqui = [UIButton buttonWithType:UIButtonTypeRoundedRect];
[bucar_aqui addTarget:self
               action:@selector(getCenter:)
     forControlEvents:UIControlEventTouchUpInside];
[bucar_aqui setTitle:@"Buscar en esta zona" forState:UIControlStateNormal];
    //UIImage *buttonImage=[UIImage imageNamed:@"buscaaqui.png"];
//    [bucar_aqui setBackgroundImage:buttonImage forState:UIControlStateNormal];
 
bucar_aqui.frame = CGRectMake(40 , 45, 240, 30.0);
    bucar_aqui.tintColor=[UIColor whiteColor];
bucar_aqui.backgroundColor=[UIColor colorWithRed:(243/255.0) green:(23/255.0) blue:(52/255.0) alpha:0.98];
  //  bucar_aqui.backgroundColor=[UIColor clearColor];

    //bucar_aqui.hidden=TRUE;
    //[mapa addSubview:bucar_aqui];
}


#pragma mark - Metodos Auxiliares

-(int)test{

    return 0;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    //NSLog(@"scrolleando tabla");
    //  [self touchTabla];
}
/*- (NSIndexPath *)indexPathForRowAtPoint:(CGPoint)point{
    return point;
}*/
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat height = scrollView.frame.size.height;
    
    CGFloat contentYoffset = scrollView.contentOffset.y;
   // NSLog(@"el y %f",contentYoffset);
    if (contentYoffset<0) {
            [self handleTapMapView:nil];
    }
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    
    if(distanceFromBottom < height)
    {
     //   NSLog(@"end of the table");
    }
}

-(void) getPlaces{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *direccion=buscar.text;//@"juan%20escutia%2094,la%20Condesa";
       
        
        NSData *stringData = [direccion dataUsingEncoding: NSASCIIStringEncoding allowLossyConversion: YES];
        
        direccion = [[NSString alloc] initWithData: stringData encoding: NSASCIIStringEncoding];      direccion = [direccion stringByReplacingOccurrencesOfString:@" "
                                                         withString:@"%20"];
        NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?key=TUKEY&sensor=true&query=%@,distritofederal",direccion];
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        if (data!=nil) {
            
            
            NSString *dato=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSMutableString * miCadena = [NSMutableString stringWithString: dato];
            
            NSData *data1 = [miCadena dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
            NSArray *aux=[jsonObject objectForKey:@"results"];
            if ([aux count]==0) {
                UIAlertView *alerta=[[UIAlertView alloc]initWithTitle:@"Mensaje" message:@"No encontramos el lugar que buscas, intenta con otra direccón" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                [alerta show];
            }
            else{
            NSDictionary *primero=[[jsonObject objectForKey:@"results"]objectAtIndex:0];
            NSDictionary *coordenadas=[[primero objectForKey:@"geometry"] objectForKey:@"location"];
            
                [self obtenerEventos: [[coordenadas objectForKey:@"lat"] floatValue] Y:[[coordenadas objectForKey:@"lng"] floatValue]];}
        }
        else{
            
            UIAlertView *alerta=[[UIAlertView alloc]initWithTitle:@"Mensaje" message:@"No encontramos el lugar que buscas, intenta con otra direccón" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
            [alerta show];
        }
        
    });
    
}
-(IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
   
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint translatedPoint = [recognizer translationInView:self.view];
         NSLog(@"magnitude: %f", translatedPoint.y);
        if (translatedPoint.y<0) {
             NSLog(@"arriba");
             isArrow=FALSE;
            [self touchTabla];
            
        }
        
    }
}


-(void)buscar_imagen:(NSString *) url
{
   
    
    NSObject *o = [delegate.cacheImagenes objectForKey:url];
    if( o == nil ){
        @try{
            [delegate.cacheImagenes setObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: url]]]
                     forKey:url];
        }
        @catch (NSException *exception) {
            
        }
    }
    
    
}


// moviendo el mapa
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    moviendo++;
    NSLog(@"regionDidChangeAnimated");
    MKCoordinateRegion mapRegion;
    // set the center of the map region to the now updated map view center
    mapRegion.center = mapView.centerCoordinate;
    
    mapRegion.span.latitudeDelta = 0.3; // you likely don't need these... just kinda hacked this out
    mapRegion.span.longitudeDelta = 0.3;
    
    // get the lat & lng of the map region
    double lat = mapRegion.center.latitude;
    double lng = mapRegion.center.longitude;

    // note: I have a variable I have saved called lastLocationCoordinate. It is of type
    // CLLocationCoordinate2D and I initially set it in the didUpdateUserLocation
    // delegate method. I also update it again when this function is called
    // so I always have the last mapRegion center point to compare the present one with
    CLLocation *before = [[CLLocation alloc] initWithLatitude:initialLocation.latitude longitude:initialLocation.longitude];
    CLLocation *now = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    
    CLLocationDistance distance = ([before distanceFromLocation:now]) * 0.000621371192;
    
    
    NSLog(@"Scrolled distance: %@", [NSString stringWithFormat:@"%.02f", distance]);
    
    if( distance > SCROLL_UPDATE_DISTANCE )
    { NSLog(@"se movio");
        if (moviendo>3) {
            
        
       [mapa addSubview:bucar_aqui];
           }
    }
    
    // resave the last location center for the next map move event
    initialLocation.latitude = mapRegion.center.latitude;
    initialLocation.longitude = mapRegion.center.longitude;
    
}
@end

