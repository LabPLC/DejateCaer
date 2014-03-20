//
//  MenuViewController.h
//  DejateCaer
//
//  Created by Carlos Castellanos on 19/03/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, FBLoginViewDelegate>

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *radiolbl;

- (IBAction) slideRadioChangee:(id)sender;
-(IBAction)twitter:(id)sender;
-(IBAction)fb:(id)sender;
@end
