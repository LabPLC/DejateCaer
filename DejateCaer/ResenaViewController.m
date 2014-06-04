//
//  ResenaViewController.m
//  DejateCaer
//
//  Created by Carlos Castellanos on 19/05/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import "ResenaViewController.h"

@interface ResenaViewController ()
{
    UIView *loading;
      UIActivityIndicatorView *spinner;
}
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
 
    
    
    loading=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25, self.view.frame.size.height/2 -50, 50, 50)];
    loading.backgroundColor=[UIColor colorWithRed:(243/255.0) green:(23/255.0) blue:(52/255.0) alpha:0.8];
    // loading.alpha=0.8;
    loading.layer.cornerRadius = 5;
    loading.layer.masksToBounds = YES;
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:CGPointMake(loading.frame.size.width/2.0, loading.frame.size.height/2.0)];
    [spinner startAnimating];
    [loading addSubview:spinner];
    
    _webView.delegate=self;

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

- (void) webViewDidStartLoad:(UIWebView *)webView {
    
    [self.view addSubview:loading];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    
    [loading removeFromSuperview];
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
