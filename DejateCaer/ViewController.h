//
//  ViewController.h
//  DejateCaer
//  @rockarloz
//  rockarlos@me.com
//  Created by Carlos Castellanos on 12/03/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@protocol SLParallaxControllerDelegate <NSObject>


@end

@interface ViewController : UIViewController  <MKMapViewDelegate ,UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate,UITextFieldDelegate>

@property (strong, nonatomic) CLLocationManager *LocationManager;
@property (nonatomic, retain) IBOutlet MKMapView *mapa;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic,strong)   NSArray *eventos;
@property (nonatomic, retain) IBOutlet UIView *Opcciones;



@property (nonatomic)           float                               heighTableView;
@property (nonatomic)           float                               heighTableViewHeader;

-(int)respuestaObtenerEventos;




@end
