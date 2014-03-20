//
//  RutaViewController.m
//  DejateCaer
//
//  Created by Carlos Castellanos on 20/03/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import "RutaViewController.h"

@interface RutaViewController ()

@end

@implementation RutaViewController
{
NSArray *segmentos;
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
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 60, 320, self.view.frame.size.height)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.rowHeight=75;
    _tableView.backgroundColor=[UIColor redColor];
    [self.view addSubview:_tableView];
    [super viewDidLoad];
    [self planner];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)planner{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *url= [NSString stringWithFormat:@"http://paw.dev.datos.labplc.mx/movilidad/transporte/planner/sunday/1394999266.json?lat_origin=19.4527656&lon_origin=-99.1211996&lat_destination=%@&lon_destination=%@",_latitud_destino,_longitud_destino];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        if ([data length] >0  )
        {
            // NSLog(@"dentro del asyn");
           
            NSString *dato=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSArray *listItems = [dato componentsSeparatedByString:@"<b>Warning</b>:  Cannot modify header information - headers already sent by (output started at /home/paw/datos/web/modules/movilidad/transporte.php:65) in <b>/home/paw/datos/web/outputs/Output_JSON.php</b> on line <b>23</b><br />"];
            NSMutableString * miCadena = [NSMutableString stringWithString: [listItems objectAtIndex:1]];
            NSData *data1 = [miCadena dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
            NSArray *options= [jsonObject objectForKey:@"options"];
            NSMutableDictionary *consulta=[[NSMutableDictionary alloc]init];
            int aux=[[[options objectAtIndex:0]objectForKey:@"segments"] count];
            //NSArray *aa=[options objectAtIndex:0];
            if (aux!=0) {
              consulta = [options objectAtIndex:0];
            }
            else{
            consulta = [options objectAtIndex:1];
            }
            segmentos=[consulta objectForKey:@"segments"];
            [_tableView reloadData];
        }});
}
//http://paw.dev.datos.labplc.mx/movilidad/transporte/planner/sunday/1394999266.json?lat_origin=19.4527656&lon_origin=-99.1211996&lat_destination=19.4257912&lon_destination=-99.132911
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [segmentos count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  NSLog(@"paso a celda");
    // static NSString *simpleTableIdentifier = @"SimpleTableItem";
    // eventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell"];
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customCell"];
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        //  NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"evento_cell" owner:self options:nil];
        //  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        // cell = [topLevelObjects objectAtIndex:0];
    }
   
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",[[segmentos objectAtIndex:indexPath.row ]   objectForKey:@"stop_origin_name"],[[segmentos objectAtIndex:indexPath.row ]   objectForKey:@"stop_destination_name"]];
    return cell;
}

@end
