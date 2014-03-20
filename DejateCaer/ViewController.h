//
//  ViewController.h
//  DejateCaer
//
//  Created by Carlos Castellanos on 12/03/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>



@interface ViewController : UIViewController  <MKMapViewDelegate ,UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate,NSXMLParserDelegate>
@property (strong, nonatomic) CLLocationManager *LocationManager;
@property (nonatomic, retain) IBOutlet MKMapView *mapa;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

- (IBAction)getCurrentLocation:(id)sender;
@end
