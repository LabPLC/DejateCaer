//
//  ResenaViewController.h
//  DejateCaer
//
//  Created by Carlos Castellanos on 19/05/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResenaViewController : UIViewController
@property (nonatomic,retain) NSString *texto;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextView *descripcion;
-(IBAction)regresar:(id)sender;
@end
