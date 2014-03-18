//
//  MainViewController.h
//  DejateCaer
//
//  Created by Carlos Castellanos on 14/03/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@interface MainViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, FBLoginViewDelegate> // (1)

//metodo para inicializar el menu con array de nombres y array de viewscontrollers
- (id)initWithViewControllers:(NSArray *)viewControllers andMenuTitles:(NSArray *)titles; // (2)

@end
