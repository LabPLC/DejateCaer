//
//  ViewController.m
//  DejateCaer
//
//  Created by Carlos Castellanos on 12/03/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//master

#import "ViewController.h"
#import "eventCell.h"
#import "SinEventoTableViewCell.h"
#import "DescripcionViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "Mipin.h"
#import "CalloutAnnotation.h"

#define SCREEN_HEIGHT_WITHOUT_STATUS_BAR     [[UIScreen mainScreen] bounds].size.height - 65
#define HEIGHT_STATUS_BAR                    64
#define Y_DOWN_TABLEVIEW                     SCREEN_HEIGHT_WITHOUT_STATUS_BAR - 40
#define DEFAULT_HEIGHT_HEADER                100.0f
#define MIN_HEIGHT_HEADER                    0.0f
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
    BOOL touchMap;
    BOOL isDidLoad;
    BOOL isEmpty;
    BOOL findCenter;
    UIView *vista;
    UITapGestureRecognizer* touchViewGest;
    UITapGestureRecognizer* tapRecMap;
    
    UIView *vista_atras;
    
    CLLocationCoordinate2D centre;
    AppDelegate *delegate;
    Mipin *annotationPointUbication;
    
    UIView *loading;
    UIActivityIndicatorView *spinner;
}
@synthesize mapa,LocationManager;
@synthesize heighTableViewHeader    = _heighTableViewHeader;
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
    _heighTableViewHeader       = DEFAULT_HEIGHT_HEADER;
    _heighTableView             = SCREEN_HEIGHT_WITHOUT_STATUS_BAR;
    _minHeighTableViewHeader    = MIN_HEIGHT_HEADER;
    _default_Y_tableView        = HEIGHT_STATUS_BAR;
    _Y_tableViewOnBottom        = Y_DOWN_TABLEVIEW;
    _minYOffsetToReach          = MIN_Y_OFFSET_TO_REACH;
    _latitudeUserUp             = CLOSE_SHUTTER_LATITUDE_MINUS;
    _latitudeUserDown           = OPEN_SHUTTER_LATITUDE_MINUS;
    _default_Y_mapView          = DEFAULT_Y_OFFSET;
}
-(void)putView{
[self.view addSubview:vista];
}
-(void) quitView{
    [vista removeFromSuperview];
}
- (void)viewDidLoad
{
    findCenter=FALSE;
    //Añadimos un escuchado de eventos de notificationController  para recargar la pagina
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"SlideMenu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(putView) name:@"ShowMenu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitView) name:@"HiddenMenu" object:nil];
    
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
    
    
    //Asiganamos delegado de SWRevalmenu para un boto y tenga una accion
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    
    //Creamos gesto para que un evento suceda cuando tocamos el mapa y lo pegamos a la vista mapa
    //tapRecMap = [[UITapGestureRecognizer alloc]
      //           initWithTarget:self action:@selector(touchMaps)];
    //[mapa addGestureRecognizer:tapRecMap];
    
    
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
    
    [self setupMapView];
    
    CLLocationCoordinate2D SCL;
   
    SCL.latitude = LocationManager.location.coordinate.latitude-0.020;
    SCL.longitude = LocationManager.location.coordinate.longitude;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(SCL, 4000, 4000);
    [mapa setShowsUserLocation:YES];
    [mapa setRegion:region animated:YES];
    
    [self crearLoadingView];
    //obtenemos los eventos
    [self llamada_asincrona];
    vista=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    vista.backgroundColor=[UIColor clearColor];
    
    
    [super viewDidLoad];
	
}
-(void)crearTabla{
    
    vista_atras=[[UIView alloc]initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, _heighTableViewHeader)];
    vista_atras.backgroundColor=[UIColor greenColor];
    [self.view addSubview:vista_atras];
    
    _tableView                  = [[UITableView alloc]  initWithFrame: CGRectMake(0, 70, 320, _heighTableView)];
    _tableView.tableHeaderView  = [[UIView alloc]       initWithFrame: CGRectMake(0.0, 0.0, self.view.frame.size.width, _heighTableViewHeader)];
    _tableView.rowHeight=90;
    [_tableView setBackgroundColor:[UIColor clearColor]];
    
    // Add gesture to gestures
    _tapMapViewGesture      = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                      action:@selector(handleTapMapView:)];
    _tapTableViewGesture    = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                      action:@selector(handleTapTableView:)];
    [_tableView.tableHeaderView addGestureRecognizer:_tapMapViewGesture];
    //[_tableView addGestureRecognizer:_tapTableViewGesture];
    
    // Init selt as default tableview's delegate & datasource
    _tableView.dataSource   = self;
    _tableView.delegate     = self;
    [self.view addSubview:_tableView];
    //esto es lo mio
    /*
    //Creamos la tabla  y la escondemos
    //Cambiar 346 por el largo de la pantalla -222
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 222, 320, self.view.frame.size.height-222)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.rowHeight=90;
    _tableView.backgroundColor=[UIColor redColor];
    _tableView.hidden=TRUE;
    [self.view addSubview:_tableView];*/
}

-(void)setupMapView{
    mapa                        = [[MKMapView alloc] initWithFrame:CGRectMake(0, 64, 320, _heighTableView)];
    [mapa setShowsUserLocation:YES];
    mapa.delegate = self;
    [self.view insertSubview:mapa
                belowSubview: _tableView];
}

#pragma mark - Internal Methods

- (void)handleTapMapView:(UIGestureRecognizer *)gesture {
    if(!self.isShutterOpen){
        // Move the tableView down to let the map appear entirely
        [self openShutter];
        // Inform the delegate
        if([self.delegate respondsToSelector:@selector(didTapOnMapView)]){
            [self.delegate didTapOnMapView];
        }
    }
}

- (void)handleTapTableView:(UIGestureRecognizer *)gesture {
    if(self.isShutterOpen){
        // Move the tableView up to reach is origin position
        [self closeShutter];
        // Inform the delegate
        if([self.delegate respondsToSelector:@selector(didTapOnTableView)]){
            [self.delegate didTapOnTableView];
        }
    }
}

// Move DOWN the tableView to show the "entire" mapView
-(void) openShutter{
    touchMap=TRUE;
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         mapa.frame                 = CGRectMake(0, FULL_Y_OFFSET, mapa.frame.size.width, mapa.frame.size.height);
                         self.tableView.tableHeaderView     = [[UIView alloc] initWithFrame: CGRectMake(0.0, 0.0, self.view.frame.size.width, self.minHeighTableViewHeader)];
                         self.tableView.frame               = CGRectMake(0, self.Y_tableViewOnBottom, self.tableView.frame.size.width, self.tableView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         self.isShutterOpen = YES;
                         [self.tableView setScrollEnabled:NO];
                         // Center the user 's location
                         [self zoomToUserLocation:mapa.userLocation minLatitude:self.latitudeUserDown];
                         
                         // Inform the delegate
                         if([self.delegate respondsToSelector:@selector(didTableViewMoveDown)]){
                             [self.delegate didTableViewMoveDown];
                         }
                     }];
}

// Move UP the tableView to get its original position
-(void) closeShutter{
    touchMap=FALSE;
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         mapa.frame             = CGRectMake(0, self.default_Y_mapView, mapa.frame.size.width, mapa.frame.size.height);
                         self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, _headerYOffSet, self.view.frame.size.width, self.heighTableViewHeader)];
                         self.tableView.frame           = CGRectMake(0, self.default_Y_tableView, self.tableView.frame.size.width, self.tableView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         self.isShutterOpen = NO;
                         [self.tableView setScrollEnabled:YES];
                         [self.tableView.tableHeaderView addGestureRecognizer:_tapMapViewGesture];
                         
                         // Center the user 's location
                         [self zoomToUserLocation:mapa.userLocation minLatitude:self.latitudeUserUp];
                         
                         // Inform the delegate
                         if([self.delegate respondsToSelector:@selector(didTableViewMoveUp)]){
                             [self.delegate didTableViewMoveUp];
                         }
                     }];
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
    if(self.displayMap)
        [self openShutter];
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
            
            if ([eventos count]==0) {
                _tableView.rowHeight=450;
                NSArray *vacio=[[NSArray alloc]initWithObjects:@"VACIO", nil];
                eventos=vacio;
                isEmpty=TRUE;
                
                /*radio= [NSString stringWithFormat:@"%i",[radio integerValue]+1000];
                NSLog(@"nuevo radio %@",radio);
                [self llamada_asincrona];*/
                [self getMapa];
                [self.tableView reloadData];
            }
            else{
                  _tableView.rowHeight=90;
                isEmpty=FALSE;
            //Mandamos a llamar la lista para llenarla y enseñarla
                [self getMapa];
                
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
    if (findCenter) {
        [mapa addAnnotation:annotationPointUbication];
    }
    if (!isEmpty) {
        
    
    for(int i=0;i<([eventos count]);i++) {
        
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
    }}
    
    //Quitamos la vista de loading y paramos el spinner
    [spinner stopAnimating];
    //[loading removeFromSuperview];
    loading.hidden=TRUE;
    
    //obtememos la localizacion actual del usuario
    //[self getCurrentLocation:nil];
    
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
/*
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
                         
                    /***** }
                     completion:^(BOOL finished){
                         if (finished)
                         {}
                         //  mapa.backgroundColor=[UIColor blackColor];
                         
                         //  [top_menu removeFromSuperview];
                         //   NSLog(@"falso");
                     }];
    
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    if ([self.revealViewController showMenu]) {
        [self.revealViewController revealToggle:self];
        // [_tableView removeFromSuperview];
                [self reload];
    }
    
    else{
        if (indexPath.row==0 && touchMap==TRUE) {
              [self closeShutter];
           /* _tapTableViewGesture    = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(handleTapTableView:)];
           [_tableView addGestureRecognizer:_tapTableViewGesture];*/

        }
        else{
            if (!isEmpty) {
                   DescripcionViewController *detalles;//=[[DescripcionViewController alloc]init];
            detalles = [[self storyboard] instantiateViewControllerWithIdentifier:@"descripcion"];
            detalles.evento=[eventos objectAtIndex:indexPath.row];
            detalles.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self.navigationController pushViewController:detalles animated:YES];
            }
         
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
#pragma mark - MapView Delegate

- (void)zoomToUserLocation:(MKUserLocation *)userLocation minLatitude:(float)minLatitude
{
    if (!userLocation)
        return;
    
    
    /*CLLocationCoordinate2D SCL;
    NSString *lat=[NSString stringWithFormat:@"%.8f", LocationManager.location.coordinate.latitude];
    ;
    NSString *lot=[NSString stringWithFormat:@"%.8f", LocationManager.location.coordinate.longitude];
    ;
    SCL.latitude = [lat doubleValue];
    SCL.longitude = [lot doubleValue];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(SCL, 2000, 2000);
    */
    if (!findCenter) {
        MKCoordinateRegion region;
        CLLocationCoordinate2D loc  = userLocation.location.coordinate;
        NSLog(@"%f, %f ,%f",loc.latitude,loc.longitude ,minLatitude);
        loc.latitude                = loc.latitude - minLatitude;
        NSLog(@"%f, %f",loc.latitude, loc.longitude);
        
        region.center               = loc;
        region.span                 = MKCoordinateSpanMake(.05, .05);       //Zoom distance
        region                      = [mapa regionThatFits:region];
        [mapa setRegion:region
               animated:YES];
  
    }
    else{
    
        MKCoordinateRegion region;
        CLLocationCoordinate2D loc  = centre;
        NSLog(@"%f, %f ,%f",loc.latitude,loc.longitude ,minLatitude);
        loc.latitude                = loc.latitude +0.018;
        NSLog(@"%f, %f",loc.latitude, loc.longitude);
        
        region.center               = loc;
        region.span                 = MKCoordinateSpanMake(.05, .05);       //Zoom distance
        region                      = [mapa regionThatFits:region];
        [mapa setRegion:region
               animated:YES];

    }
    
    
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
  /*  if(_isShutterOpen)
        [self zoomToUserLocation:mapa.userLocation minLatitude:self.latitudeUserDown];
    else
        [self zoomToUserLocation:mapa.userLocation minLatitude:self.latitudeUserUp];*/
}
-(IBAction)getCenter:(id)sender{
    findCenter=TRUE;
    centre = [mapa centerCoordinate];
    NSLog(@"%f, %f", centre.latitude, centre.longitude);
    //[mapa removeAnnotation:annotationPointUbication];
    
    annotationPointUbication = [[Mipin alloc] initWithTitle:@"Centro" subtitle:@"" andCoordinate:centre tipo:@"ubicacion" evento:0];
    
   // [mapa addAnnotation:annotationPointUbication];
    
    //obtenemos la posicion del usuario
    currentLatitud=[NSString stringWithFormat:@"%.8f", centre.latitude];
    currentLongitud=[NSString stringWithFormat:@"%.8f", centre.longitude];
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
                [self getMapa];
                [self.tableView reloadData];
            }
            else{
                _tableView.rowHeight=90;
                isEmpty=FALSE;
                //Mandamos a llamar la lista para llenarla y enseñarla
                [self getMapa];
                [self.tableView reloadData];
                
            }
            //[self getLista];
        }
    });
    
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
            [tableView.tableFooterView setBackgroundColor:[UIColor whiteColor]];
        }
    }
}
@end
