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

@interface ViewController ()

@end

@implementation ViewController
{
 NSArray *eventos;
 NSString *currentLatitud;
 NSString *currentLongitud;
    NSString *radio;
    
    NSInteger depth;
    NSMutableString *currentName;
    NSString *currentElement;
}
@synthesize mapa,LocationManager;
- (void)viewDidLoad
{

    radio=@"2000";
    LocationManager = [[CLLocationManager alloc] init];
    LocationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    LocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [LocationManager startUpdatingLocation];
    
  
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    [mapa setDelegate:self];
    [mapa setShowsUserLocation:YES];

   // eventos = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
    
   
    

    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 222, 320, 346)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.rowHeight=75;
    _tableView.backgroundColor=[UIColor blueColor];
    [self leerXML];
    [self llamada_asincrona];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)pull{
NSLog (@"pull");
}
-(void)getLista {
    

    [self.view addSubview:_tableView];
    [self.tableView reloadData];
    [self getMapa];
}
-(void)getMapa
{
    for(int i=0;i<[eventos count];i++) {
        NSLog(@"%i",i);
        NSMutableDictionary *lugar=[[NSMutableDictionary alloc]init];
        lugar=[eventos objectAtIndex:i];
        
        CLLocationCoordinate2D SCL;
        SCL.latitude = [[lugar objectForKey:@"latitud"] doubleValue];
        SCL.longitude = [[lugar objectForKey:@"longitud"]doubleValue];
        MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
        annotationPoint.coordinate = SCL;
        annotationPoint.title = [lugar objectForKey:@"nombre"];
        annotationPoint.subtitle = [lugar objectForKey:@"direccion"];
        [mapa addAnnotation:annotationPoint];
        
        
    }
    [self getCurrentLocation:nil];

}

-(void)getEventos{
    currentLatitud=[NSString stringWithFormat:@"%.8f", LocationManager.location.coordinate.latitude];
    currentLongitud=[NSString stringWithFormat:@"%.8f", LocationManager.location.coordinate.longitude];
    NSLog(@"%@" ,currentLongitud);
    NSLog(@"%@",currentLatitud );
    
   // NSString *urlString =@"http://codigo.labplc.mx/~rockarloz/dejatecaer/prueba.php";
   NSString *urlString =@"http://codigo.labplc.mx/~rockarloz/dejatecaer/dejatecaer.php";
   NSString *url=[NSString stringWithFormat:@"%@?longitud=%@&latitud=%@&radio=%@&fecha=2014-03-14",urlString,currentLongitud,currentLatitud,radio];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSOperationQueue *queue =[[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     
     {
         if ([data length] >0  && error == nil)
         {
                 NSLog(@"dentro del asyn");
             NSArray *lugares;
             NSString *dato=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             NSMutableString * miCadena = [NSMutableString stringWithString: dato];
             NSData *data1 = [miCadena dataUsingEncoding:NSUTF8StringEncoding];
             
             NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
             
             NSMutableDictionary *consulta=[[NSMutableDictionary alloc]init];
             consulta = [jsonObject objectForKey:@"eventos"];
             lugares= [jsonObject objectForKey:@"eventos"];//[consulta objectForKey:@"ubicaciones"];
             eventos=lugares;
             [self getLista];
             
             
         }
         else{
          //   respuesta = nil;             NSLog(@"Contenido vacio");
             
         }
        //Termina el método asíncrono
     }];
    NSLog(@"fuera del asyn");

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DescripcionViewController *detalles;//=[[DescripcionViewController alloc]init];
  
    detalles = [[self storyboard] instantiateViewControllerWithIdentifier:@"descripcion"];
      detalles.evento=[eventos objectAtIndex:indexPath.row];
detalles.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//[self presentViewController:detalles animated:YES completion:NULL];
 [self.navigationController pushViewController:detalles animated:YES];
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


- (IBAction)getCurrentLocation:(id)sender {
    CLLocationCoordinate2D SCL;
    NSString *lat=[NSString stringWithFormat:@"%.8f", LocationManager.location.coordinate.latitude];
    ;
    NSString *lot=[NSString stringWithFormat:@"%.8f", LocationManager.location.coordinate.longitude];
    ;
    SCL.latitude = [lat doubleValue];
    SCL.longitude = [lot doubleValue];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(SCL, 2000, 2000);
    
    [mapa setRegion:region animated:YES];
}

-(void)llamada_asincrona{
    
    currentLatitud=[NSString stringWithFormat:@"%.8f", LocationManager.location.coordinate.latitude];
    currentLongitud=[NSString stringWithFormat:@"%.8f", LocationManager.location.coordinate.longitude];
    NSLog(@"%@" ,currentLongitud);
    NSLog(@"%@",currentLatitud );
    
    // NSString *urlString =@"http://codigo.labplc.mx/~rockarloz/dejatecaer/prueba.php";
    NSString *urlString =@"http://codigo.labplc.mx/~rockarloz/dejatecaer/dejatecaer.php";
    NSString *url=[NSString stringWithFormat:@"%@?longitud=%@&latitud=%@&radio=%@&fecha=2014-03-14",urlString,currentLongitud,currentLatitud,radio];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        if ([data length] >0  )
        {
           // NSLog(@"dentro del asyn");
            NSArray *lugares;
            NSString *dato=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSMutableString * miCadena = [NSMutableString stringWithString: dato];
            NSData *data1 = [miCadena dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
            
            NSMutableDictionary *consulta=[[NSMutableDictionary alloc]init];
            consulta = [jsonObject objectForKey:@"eventos"];
            lugares= [jsonObject objectForKey:@"eventos"];//[consulta objectForKey:@"ubicaciones"];
            eventos=lugares;
            [self getLista];
            
            
            }
        
   
            
          //  [spinner stopAnimating];
          
        
        
    });
    
}
-(void)leerXML{
    NSString *url=@"http://paw.dev.datos.labplc.mx/movilidad/transporte/planner/01/1394999266.xml?lat_origin=19.4527656&lon_origin=-99.1211996&lat_destination=19.4257912&lon_destination=-99.132911";
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSXMLParser* parser = [[NSXMLParser alloc] initWithData: data];
        
        [parser setDelegate:self];
        [parser parse];
        if ([data length] >0  )
        {
           
            
            
        }
        
        
        
        //  [spinner stopAnimating];
        
        
        
    });


}/*
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
    
    if ([elementName isEqualToString:@"options"]) {
        NSDictionary *segmento;
        segmento=attributeDict;
        NSLog(@"");
       // NSString* title = [attributeDict valueForKey:@"title"];
       // int id = [[attributeDict valueForKey:@"id"] intValue];
        //NSLog(@"Title: %@, ID: %i", title, id);
    }
}
*/

/*

#pragma mark -
#pragma mark NSXMLParserDelegate methods

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"Document started", nil);
    depth = 0;
    currentElement = nil;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Error: %@", [parseError localizedDescription]);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    currentElement = [elementName copy];
    
    if ([currentElement isEqualToString:@"routes"])
    {
        ++depth;
        [self showCurrentDepth];
    }
    else if ([currentElement isEqualToString:@"options"])
    {
       // [currentName release];
        currentName = [[NSMutableString alloc] init];
    }
    else if ([currentElement isEqualToString:@"segments"])
    {
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqualToString:@"routes"])
    {
        --depth;
        [self showCurrentDepth];
    }
    else if ([elementName isEqualToString:@"options"])
    {
        if (depth == 1)
        {
            NSLog(@"Outer name tag: %@", currentName);
        }
        else
        {
            NSLog(@"Inner name tag: %@", currentName);
        }
    }
    else if ([elementName isEqualToString:@"stop_origin_id"])
    {
        if (depth == 1)
        {
            NSLog(@"Outer name tag: %@", currentName);
        }
        else
        {
            NSLog(@"Inner name tag: %@", currentName);
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
   // if ([currentElement isEqualToString:@"name"])
   // {
        [currentName appendString:string];
    //}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"Document finished", nil);
}

#pragma mark -
#pragma mark Private methods

- (void)showCurrentDepth
{
    NSLog(@"Current depth: %d", depth);
}*/
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSIndexPath *firstVisibleIndexPath = [[self.tableView indexPathsForVisibleRows] objectAtIndex:0];
    if (firstVisibleIndexPath.row==0) {
         NSLog(@"first visible cell's section: %i, row: %i", firstVisibleIndexPath.section, firstVisibleIndexPath.row);
    }
  
}
@end
