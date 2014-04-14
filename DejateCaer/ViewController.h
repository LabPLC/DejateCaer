//
//  ViewController.h
//  DejateCaer
//
//  Created by Carlos Castellanos on 12/03/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@protocol SLParallaxControllerDelegate <NSObject>

// Tap handlers
-(void)didTapOnMapView;
-(void)didTapOnTableView;
// TableView's move
-(void)didTableViewMoveDown;
-(void)didTableViewMoveUp;

@end

@interface ViewController : UIViewController  <MKMapViewDelegate ,UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>


@property (strong, nonatomic) CLLocationManager *LocationManager;
@property (nonatomic, retain) IBOutlet MKMapView *mapa;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

  @property (nonatomic, retain) IBOutlet UIView *Opcciones;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (nonatomic, weak)     id<SLParallaxControllerDelegate>    delegate;
@property (nonatomic)           float                               heighTableView;
@property (nonatomic)           float                               heighTableViewHeader;
@property (nonatomic)           float                               minHeighTableViewHeader;
@property (nonatomic)           float                               minYOffsetToReach;
@property (nonatomic)           float                               default_Y_mapView;
@property (nonatomic)           float                               default_Y_tableView;
@property (nonatomic)           float                               Y_tableViewOnBottom;
@property (nonatomic)           float                               latitudeUserUp;
@property (nonatomic)           float                               latitudeUserDown;

// Move the map in terms of user location
// @minLatitude : subtract to the current user's latitude to move it on Y axis in order to view it when the map move
- (void)zoomToUserLocation:(MKUserLocation *)userLocation minLatitude:(float)minLatitude;


- (IBAction)getCurrentLocation:(id)sender;
@end
