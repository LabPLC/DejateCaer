//
//  ViewController.m
//  DejateCaer
//
//  Created by Carlos Castellanos on 12/03/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import "ViewController.h"
#import "eventCell.h"
#import "SinEventoTableViewCell.h"
#import "DescripcionViewController.h"
#import "AppDelegate.h"
#import "Mipin.h"
#import "CalloutAnnotation.h"


#define DEFAULT_Y_OFFSET                     ([[UIScreen mainScreen] bounds].size.height == 480.0f) ? -200.0f : -250.0f
#define FULL_Y_OFFSET                        20.0f
#define MIN_Y_OFFSET_TO_REACH                -30
#define OPEN_SHUTTER_LATITUDE_MINUS          .005
#define CLOSE_SHUTTER_LATITUDE_MINUS         -0.013

@interface ViewController ()


@property (strong, nonatomic)   UITapGestureRecognizer  *tapMapViewGesture;
@property (strong, nonatomic)   UITapGestureRecognizer  *tapTableViewGesture;
@property (nonatomic)           CGRect                  headerFrame;
@property (nonatomic)           float                   headerYOffSet;
@property (nonatomic)           BOOL                    isShutterOpen;
@property (nonatomic)           BOOL                    displayMap;
@end

@implementation ViewController
{
    NSArray *eventos;
    NSString *currentLatitud;
    NSString *currentLongitud;
    NSString *radio;
    NSString *radio_anterior;
    
    BOOL isEmpty;
    
    BOOL isArrow;  //diseño
    UIView *flechas; //diseño
    UITapGestureRecognizer* tapFlechas;//diseño
    UIButton *encuentrame;//diseño
    UIButton *herramientas;//diseño
    UITextField *buscar;//diseño
    UIView *contenedor_flotante;
    
  
   
    UITapGestureRecognizer* tapRecMap;
    UIView *opcciones;
    // UIView *vista_atras;
    
    AppDelegate *delegate;
    Mipin *annotationPointUbication;
    
    UIView *loading;
    UIActivityIndicatorView *spinner;
}
@synthesize mapa,LocationManager;

@synthesize minHeighTableViewHeader = _minHeighTableViewHeader;
@synthesize heighTableView          = _heighTableView;
@synthesize default_Y_mapView       = _default_Y_mapView;
@synthesize default_Y_tableView     = _default_Y_tableView;
@synthesize Y_tableViewOnBottom     = _Y_tableViewOnBottom;
@synthesize latitudeUserUp          = _latitudeUserUp;
@synthesize latitudeUserDown        = _latitudeUserDown;
@synthesize minYOffsetToReach       = _minYOffsetToReach;
-(void)slideMenu{
    
}
-(id)init{
    self =  [super init];
    if(self){
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setup];
    }
    return self;
}

// Set all view we will need
-(void)setup{

    _minYOffsetToReach          = MIN_Y_OFFSET_TO_REACH;
    _latitudeUserUp             = CLOSE_SHUTTER_LATITUDE_MINUS;
    _latitudeUserDown           = OPEN_SHUTTER_LATITUDE_MINUS;
    _default_Y_mapView          = DEFAULT_Y_OFFSET;
}


- (void)viewDidLoad
{
    // [self getPlacesApple];
    isArrow=FALSE;
    
    contenedor_flotante=[[UIView alloc]initWithFrame:CGRectMake(5, 25, 273, 35)];
    contenedor_flotante.backgroundColor=[UIColor whiteColor];
    UIImageView *lupa=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    lupa.image=[UIImage imageNamed:@"search.png"];
    [contenedor_flotante addSubview:lupa];
    buscar=[[UITextField alloc]initWithFrame:CGRectMake(37, 0, 158, 35)];
    buscar.delegate = self;
    buscar.placeholder=@"Zamora 54,Condesa,Cuahutemoc";
    [contenedor_flotante addSubview:buscar];
    encuentrame = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [encuentrame addTarget:self
                    action:@selector(getCurrentLocation:)
          forControlEvents:UIControlEventTouchUpInside];
    encuentrame.frame = CGRectMake(203, 0, 35, 35);
    UIImage *btnImage = [UIImage imageNamed:@"findme.png"];
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, encuentrame.frame.size.width, encuentrame.frame.size.height)];
    img.image=btnImage;
    [encuentrame addSubview:img];
    
    herramientas = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [herramientas addTarget:self
                     action:@selector(opcciones:)
           forControlEvents:UIControlEventTouchUpInside];
    herramientas.frame = CGRectMake(238, 0, 35, 35);
    UIImage *btnImage2 = [UIImage imageNamed:@"tools.png"];
    UIImageView *img2=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, herramientas.frame.size.width, herramientas.frame.size.height)];
    img2.image=btnImage2;
    [herramientas addSubview:img2];
    [contenedor_flotante addSubview:encuentrame];
    [contenedor_flotante addSubview:herramientas];
    
    
    
    delegate.isOption=FALSE;
  
    //Añadimos un escuchado de eventos de notificationController  para recargar la pagina
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cerrarOpcciones) name:@"aceptar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actualizar) name:@"actualizar" object:nil];
    
    //Le asignamos el valor falso a la variable ShowMenu ya que en un
    
    
    
    
    //declaramos un variable que nos servira como delegado
    delegate= (AppDelegate *) [[UIApplication sharedApplication] delegate];
    ;
    //Titulo para la vista en el navegation controller
    self.title=@"Eventos";
    
    //Copiamos el radio del delegado por default es  2000 metros
    radio=delegate.user_radio;//@"2000";
    
    
    LocationManager = [[CLLocationManager alloc] init];
    LocationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    LocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [LocationManager startUpdatingLocation];
    
    
    
    [mapa setDelegate:self];
    
    
    //llamamos metodo para crear la tabla
    [self crearTabla];
    
    [self setupMapView];
    
    CLLocationCoordinate2D SCL;
    SCL.latitude = LocationManager.location.coordinate.latitude-0.020;
    SCL.longitude = LocationManager.location.coordinate.longitude;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(SCL, 4000, 4000);
    [mapa setShowsUserLocation:YES];
    [mapa setRegion:region animated:YES];
    
    [self crearLoadingView];
    //obtenemos los eventos
    [self llamada_asincrona:LocationManager.location.coordinate.latitude Y:LocationManager.location.coordinate.longitude];
    
    [self handleTapMapView:nil];
    [super viewDidLoad];
	
}
-(void)crearTabla{
    
    
    
    _tableView                  = [[UITableView alloc]  initWithFrame: CGRectMake(0, 64, 320, self.view.frame.size.height-64)];
    
    _tableView.tableHeaderView  = [[UIView alloc]       initWithFrame: CGRectMake(0.0, 0.0, self.view.frame.size.width, 290)];
    _tableView.rowHeight=90;
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.tableHeaderView.backgroundColor=[UIColor grayColor];
    // Add gesture to gestures
    _tapMapViewGesture      = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                      action:@selector(handleTapMapView:)];
    _tapTableViewGesture    = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                      action:@selector(handleTapTableView:)];
    [_tableView.tableHeaderView addGestureRecognizer:_tapMapViewGesture];
    //[_tableView addGestureRecognizer:_tapTableViewGesture];
    
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
    [mapa setShowsUserLocation:YES];
    mapa.delegate = self;
    [self.view insertSubview:mapa
                belowSubview: _tableView];
}

#pragma mark - Internal Methods
//vista de la lista escondida
- (void)handleTapMapView:(UIGestureRecognizer *)gesture {
    NSLog(@"push tap on the header");
      [_tableView setContentOffset:CGPointMake(0, 0) animated:NO];
      // [self.tableView setContentOffset:CGPointZero animated:NO];
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                                                  //custom al mapa
                         mapa.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-30);
                         [mapa addSubview:contenedor_flotante];
                         self.tableView.frame           = CGRectMake(0, self.view.frame.size.height-30,320, 30);
                        
                         
                        

                     }
                     completion:^(BOOL finished){
                         
                         self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
                         self.tableView.tableHeaderView.backgroundColor=[UIColor greenColor];
                         
                         NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"flechas" owner:nil options:nil];
                         
                         // Find the view among nib contents (not too hard assuming there is only one view in it).
                         flechas = [nibContents lastObject];
                         [flechas addGestureRecognizer:tapFlechas];
                         [self.tableView.tableHeaderView addSubview:flechas];
                         self.isShutterOpen = NO;
                           _tableView.scrollEnabled=FALSE;
                         [self.tableView.tableHeaderView addGestureRecognizer:_tapMapViewGesture];
                         
                                                // Inform the delegate
                      /*   if([self.delegate respondsToSelector:@selector(didTableViewMoveUp)]){
                             [self.delegate didTableViewMoveUp];
                         }*/
                     }];
    
    
}


- (void)handleTapTableView:(UIGestureRecognizer *)gesture {
    
    NSLog(@"push on the header");
}



#pragma mark - Table view Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // check if the Y offset is under the minus Y to reach
    if (self.tableView.contentOffset.y < self.minYOffsetToReach){
        if(!self.displayMap)
            self.displayMap                      = YES;
    }else{
        if(self.displayMap)
            self.displayMap                      = NO;
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //
    //if(self.displayMap)
    // [self openShutter];
}


-(void)crearLoadingView{
    //Creamos vista que contiene el spinner y lo enseñamos al usuario
    loading=[[UIView alloc]initWithFrame:CGRectMake(10, 10
                                                    , self.view.frame.size.width-20, self.view.frame.size.height-20)];
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


-(void)llamada_asincrona :(float) latitud Y : (float) longitud {
    //obtenemos la posicion del usuario
    currentLatitud=[NSString stringWithFormat:@"%.8f", latitud];
    currentLongitud=[NSString stringWithFormat:@"%.8f", longitud];
    radio=delegate.user_radio;
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
            
            if ([eventos count]==0) {
                _tableView.rowHeight=450;
                NSArray *vacio=[[NSArray alloc]initWithObjects:@"VACIO", nil];
                eventos=vacio;
                isEmpty=TRUE;
                
                /*radio= [NSString stringWithFormat:@"%i",[radio integerValue]+1000];
                 NSLog(@"nuevo radio %@",radio);
                 [self llamada_asincrona];*/
                [self getMapa:latitud Y :longitud];
                [self.tableView reloadData];
            }
            else{
                _tableView.rowHeight=90;
                isEmpty=FALSE;
                //Mandamos a llamar la lista para llenarla y enseñarla
                [self getMapa:latitud Y :longitud];
                
                [self.tableView reloadData];
                
                
                
            }
            //[self getLista];
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
            
            Mipin *annotationPoint = [[Mipin alloc] initWithTitle:[lugar objectForKey:@"nombre"] subtitle:[lugar objectForKey:@"direccion"] andCoordinate:newCoord tipo:@"" evento:i];
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
    
    
    CLLocationCoordinate2D SCL;
    
    SCL.latitude = LocationManager.location.coordinate.latitude;
    
    SCL.longitude = LocationManager.location.coordinate.longitude;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(SCL, 4000, 4000);
    [mapa setShowsUserLocation:YES];
    [mapa setRegion:region animated:YES];
    [self llamada_asincrona:SCL.latitude Y:SCL.longitude];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    detalles.evento=[eventos objectAtIndex:indexPath.row];
    detalles.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:detalles animated:YES];
    
    
    [self presentViewController:detalles animated:YES completion:NULL];
    
    
    
    
    
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
    if (!isEmpty) {
        
        
        eventCell *cell=[[eventCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customCell"];
        
        if(indexPath.row == 0){
            
            
            
            CGRect shadowFrame      = cell.layer.bounds;
            CGPathRef shadowPath    = [UIBezierPath bezierPathWithRect:shadowFrame].CGPath;
            cell.layer.shadowPath   = shadowPath;
            [cell.layer setShadowOffset:CGSizeMake(-2, -2)];
            [cell.layer setShadowColor:[[UIColor grayColor] CGColor]];
            [cell.layer setShadowOpacity:.75];
            
        }
        
        
        if (cell == nil) {
        }
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
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
        cell.nombre.text= @"No encontramos eventos";
        return cell;
        
    }
    
    // cell.textLabel.text = [[eventos objectAtIndex:indexPath.row ]   objectForKey:@"nombre"];
    
}






-(void)actualizar{
    NSLog(@"reload");
    radio=delegate.user_radio;
 
        [self getCurrentLocation:nil];
   
    //[self llamada_asincrona];
}
#pragma mark - MapView Delegate

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
            imagen = [UIImage imageNamed:@"yo.png"];
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
            frame.size.width = 37;
            frame.size.height = 37;
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
    detalles.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:detalles animated:YES completion:NULL];}





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
            [tableView.tableFooterView setBackgroundColor:[UIColor whiteColor]];
        }
    }
}

-(IBAction)opcciones:(id)sender
{
    //[[UIView alloc]initWithFrame:CGRectMake(5, 24, self.view.frame.size.width-10, self.view.frame.size.height-29)];
    delegate.isOption=TRUE;
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"Opcciones" owner:nil options:nil];
    
    // Find the view among nib contents (not too hard assuming there is only one view in it).
    opcciones = [nibContents lastObject];
    opcciones.frame=CGRectMake(5, 24, self.view.frame.size.width-10, self.view.frame.size.height-29);
    opcciones.backgroundColor=[UIColor grayColor];
    opcciones.alpha=1;
    opcciones.layer.cornerRadius = 5;
    opcciones.layer.masksToBounds = YES;
    
    
    
    
    [UIView transitionFromView:self.view
                        toView:opcciones
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromTop
                    completion:nil];
    
    //   self.navigationController.navigationBarHidden = YES;
    
    // [self.view addSubview:opcciones];
    
}
-(void)cerrarOpcciones{
    delegate.isOption=FALSE;
    //self.navigationController.navigationBarHidden = NO;
    [UIView transitionFromView:opcciones
                        toView:self.view
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromBottom
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
                             self.tableView.frame           = CGRectMake(0, 0,320, self.view.frame.size.height);
                             
                             mapa.frame             = CGRectMake(0, 0, 320, 278);
                             [mapa addSubview:contenedor_flotante];
                             
                             
                             self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0, self.view.frame.size.width, self.view.frame.size.height/2)];
                             self.tableView.tableHeaderView.backgroundColor=[UIColor clearColor];
                             self.tableView.scrollEnabled=YES;
                             
                             NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"flechas_cierran" owner:nil options:nil];
                             
                             // Find the view among nib contents (not too hard assuming there is only one view in it).
                             
                             flechas = [nibContents lastObject];
                             flechas.frame=CGRectMake(0, self.tableView.tableHeaderView.frame.size.height-30, 320, 30);
                             [self.tableView.tableHeaderView addSubview:flechas];
                             [flechas addGestureRecognizer:tapFlechas];
                             
                             //flechas=[[UIView alloc]initWithFrame:CGRectMake(0, self.tableView.tableHeaderView.frame.size.height-30, 320, 30)];
                             flechas.backgroundColor=[UIColor whiteColor];
                             
                             
                             
                             
                             
                             
                         }
                         completion:^(BOOL finished){
                             self.isShutterOpen = NO;
                             [self.tableView setScrollEnabled:YES];
                             [self.tableView.tableHeaderView addGestureRecognizer:_tapMapViewGesture];
                             
                          
                             // Inform the delegate
                           /*  if([self.delegate respondsToSelector:@selector(didTableViewMoveUp)]){
                                 [self.delegate didTableViewMoveUp];
                             }*/
                         }];
    }
    else{
        isArrow=FALSE;
        [self handleTapMapView:nil];
    }
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    NSLog(@"scrolleando tabla");
   //  [self touchTabla];
}
-(void) getPlaces{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *direccion=buscar.text;//@"juan%20escutia%2094,la%20Condesa";
        direccion = [direccion stringByReplacingOccurrencesOfString:@" "
                                                         withString:@"%20"];
        NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?key=TUAPIKEY&sensor=true&query=%@,distritofederal",direccion];
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        if (data!=nil) {
            
            
            NSString *dato=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSMutableString * miCadena = [NSMutableString stringWithString: dato];
            NSData *data1 = [miCadena dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *primero=[[jsonObject objectForKey:@"results"]objectAtIndex:0];
            NSDictionary *coordenadas=[[primero objectForKey:@"geometry"] objectForKey:@"location"];
            
            [self llamada_asincrona: [[coordenadas objectForKey:@"lat"] floatValue] Y:[[coordenadas objectForKey:@"lng"] floatValue]];
        }
        else{
            
            //noencotramosdireecion typea bien
        }
        
    });
    
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
            NSLog(@"%@",buscar.text);
            NSLog(@"%@",buscar.text);
            [self.view endEditing:YES];
            [self getPlacesApple];
        }
        else
        {
            UIAlertView *alerta=[[UIAlertView alloc]initWithTitle:@"Mensaje" message:@"Introduce un lugar de búsqueda" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
            [alerta show];
        }
        return YES;
}

-(void)getPlacesApple{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    NSString *direccion=[NSString stringWithFormat:@"%@,distrito federal",buscar.text];
    [geocoder geocodeAddressString:direccion completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error)
        {
            UIAlertView *alerta=[[UIAlertView alloc]initWithTitle:@"Mensaje" message:@"No encontramos el lugar que buscas" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
            [alerta show];
            NSLog(@"Geocode failed with error: %@", error);
            //[self displayError:error];
            
            return;
            
        }
        
        CLPlacemark *placemark=[placemarks objectAtIndex:0];
        NSLog(@"Received placemarks: %@", placemarks);
        NSLog(@"%f,%f",placemark.location.coordinate.latitude,placemark.location.coordinate.longitude);
        [self llamada_asincrona: placemark.location.coordinate.latitude Y:placemark.location.coordinate.longitude];
        //[self displayPlacemarks:placemarks];
    }];
    
}
@end

