//
//  ResenaViewController.m
//  DejateCaer
//
//  Created by Carlos Castellanos on 19/05/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import "ResenaViewController.h"

@interface ResenaViewController ()

@end

@implementation ResenaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
 
    
    
    NSURL *url3 = [NSURL URLWithString:_texto];
    
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url3];
    
    
    
    [_webView loadRequest:requestObj];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)regresar:(id)sender
{
    // [self dismissModalViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:NO completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
