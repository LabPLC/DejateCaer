//
//  AppDelegate.h
//  DejateCaer
//  @rockarloz
//  rockarlos@me.com
//  Created by Carlos Castellanos on 12/03/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *alto;
@property (strong, nonatomic) NSString *user_radio;
@property (strong, nonatomic) NSMutableDictionary *cacheImagenes;

@property (assign, nonatomic) BOOL isOption;

@end
