//
//  MenuViewController.m
//  DejateCaer
//
//  Created by Carlos Castellanos on 19/03/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import "MenuViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
@interface MenuViewController ()
@property (nonatomic, strong)IBOutlet UITableView *tabla;
@property (nonatomic, strong) IBOutlet UIImageView *foto_perfil;
@property (nonatomic, strong) IBOutlet FBProfilePictureView *foto_perfil1;
@property (nonatomic, assign) BOOL tw;

@end

@implementation MenuViewController
{
    NSArray *menuItems;
    AppDelegate *delegate;
    
    FBLoginView *loginView;
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
    delegate= (AppDelegate *) [[UIApplication sharedApplication] delegate];
    _tw=FALSE;
    /*
    _tabla= [[UITableView alloc] init];
    _tabla.delegate = self;
    _tabla.dataSource = self;
     [_tabla registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tabla.frame = self.view.bounds;
    //añadimos el menu a la vista actual
    CGRect frame;
    frame.size.height=176;//self.view.frame.size.height;
    frame.size.width=self.view.frame.size.width;
    frame.origin.x=0;
    frame.origin.y=150;
    _tabla.frame=frame;
    _tabla.scrollEnabled = NO;
    // CGRectMake(0, 150,self.view.frame.size.width , self.view.frame.size.height)];
    [self.view addSubview:_tabla]; */
    _tabla.backgroundColor=[UIColor redColor];
    _tabla.scrollEnabled = NO;
    menuItems = @[@"Eventos", @"Mis Eventos", @"Agregar Evento", @"Configuraciones"];

    [super viewDidLoad];
    
    //Añadimos boton de fb
    
    loginView = [[FBLoginView alloc] init];
    loginView.delegate = self;
    loginView.readPermissions = @[@"basic_info", @"email", @"user_likes"];
    
    // Align the button in the center horizontally
    CGRect frame_fb;
    frame_fb.size.height=35;//self.view.frame.size.height;
    frame_fb.size.width=213;
    frame_fb.origin.x=20;
    frame_fb.origin.y=411;
    loginView.frame=frame_fb;
    [self.view addSubview:loginView];
    //

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: [menuItems objectAtIndex:indexPath.row]];
    cell.textLabel.text = menuItems[indexPath.row];
    */
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    return cell;
}


- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [_tabla indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[menuItems objectAtIndex:indexPath.row] capitalizedString];
    
    // Set the photo if it navigates to the PhotoView
    /*if ([segue.identifier isEqualToString:@"showPhoto"]) {
        PhotoViewController *photoController = (PhotoViewController*)segue.destinationViewController;
        NSString *photoFilename = [NSString stringWithFormat:@"%@_photo.jpg", [menuItems objectAtIndex:indexPath.row]];
        photoController.photoFilename = photoFilename;
    } */
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
    
}

/*-(IBAction)twitter:(id)sender{
    menuItems = @[@"Eventos", @"Configuraciones"];
    [_tabla reloadData];
    CGRect frame;
    frame.origin.x=0;
    frame.origin.y=150;
    frame.size.height=88;//self.view.frame.size.height;
    frame.size.width=self.view.frame.size.width;
    _tabla.frame=frame;

}*/

//Creo que esto ya no lo uso asi que podría borralo
-(IBAction)fb:(id)sender{
    CGRect frame;
    frame.origin.x=0;
    frame.origin.y=150;
    frame.size.height=176;//self.view.frame.size.height;
    frame.size.width=self.view.frame.size.width;
    _tabla.frame=frame;
     menuItems = @[@"Eventos", @"Mis Eventos", @"Agregar Evento", @"Configuraciones"];
    [_tabla reloadData];
}
//metodos de FB
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [FBLoginView class];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    self.foto_perfil1.profileID = user.id;
    CGRect frame;
    frame.origin.x=0;
    frame.origin.y=150;
    frame.size.height=176;//self.view.frame.size.height;
    frame.size.width=self.view.frame.size.width;
    _tabla.frame=frame;
    menuItems = @[@"Eventos", @"Mis Eventos", @"Agregar Evento", @"Configuraciones"];
    [_tabla reloadData];
    [self performSelector:@selector(getImage) withObject:nil afterDelay:3];
    _twtBtn.hidden=TRUE;
    
    
    NSLog(@"%@", user.name);
}
-(void)getImage{
    UIImage *image2 = nil;
    
    for (NSObject *obj in [self.foto_perfil1 subviews]) {
        if ([obj isMemberOfClass:[UIImageView class]]) {
            UIImageView *objImg = (UIImageView *)obj;
            image2 = objImg.image;
            break;
        }
    }
    self.foto_perfil.image=image2;
    
    self.foto_perfil.layer.cornerRadius = image2.size.width / 2;
    //self.foto_perfil.layer.cornerRadius = 2000;
    UIGraphicsBeginImageContextWithOptions( self.foto_perfil.bounds.size, NO, [UIScreen mainScreen].scale);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect: self.foto_perfil.bounds
                                cornerRadius:50.0] addClip];
    // Draw your image
    [image2 drawInRect: self.foto_perfil.bounds];
    
    // Get the image, here setting the UIImageView image
    self.foto_perfil.image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
}
// Logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    _twtBtn.hidden=FALSE;
    self.foto_perfil1.profileID=nil;//[UIImage imageNamed:@"sin_perfil.jpg"];
    [self performSelector:@selector(getImage) withObject:nil afterDelay:1];
    CGRect frame;
    frame.origin.x=0;
    frame.origin.y=150;
    frame.size.height=176;//self.view.frame.size.height;
    frame.size.width=self.view.frame.size.width;
    _tabla.frame=frame;
    menuItems = @[@"Eventos",  @"Configuraciones"];
    [_tabla reloadData];    // self.nameLabel.text = @"";
    //self.statusLabel.text= @"You're not logged in!";
}



// twitter
-(IBAction)twitter:(id)sender
{
    //estas logeado con twitter? _tw=TRUE = no
    if (_tw) {
        loginView.hidden=FALSE;
        self.foto_perfil1.profileID=nil;//[UIImage imageNamed:@"sin_perfil.jpg"];
        [self performSelector:@selector(getImage) withObject:nil afterDelay:1];
        CGRect frame;
        frame.origin.x=0;
        frame.origin.y=150;
        frame.size.height=176;//self.view.frame.size.height;
        frame.size.width=self.view.frame.size.width;
        _tabla.frame=frame;
        menuItems = @[@"Eventos",  @"Configuraciones"];
        [_tabla reloadData];
        _tw=FALSE;
    }
    else{ // si estas logeado con twitter
        loginView.hidden=TRUE;

        _tw=TRUE;
        // Request access to the Twitter accounts
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
            if (granted) {
                
                NSArray *accounts = [accountStore accountsWithAccountType:accountType];
                
                // Check if the users has setup at least one Twitter account
                
                if (accounts.count > 0)
                {
                    ACAccount *twitterAccount = [accounts objectAtIndex:0];
                    
                    // Creating a request to get the info about a user on Twitter
                    NSString *d=twitterAccount.username;
                    
                    SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"] parameters:[NSDictionary dictionaryWithObject:@"rockarloz" forKey:@"screen_name"]];
                    [twitterInfoRequest setAccount:twitterAccount];
                    
                    // Making the request
                    
                    [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            // Check if we reached the reate limit
                            
                            if ([urlResponse statusCode] == 429) {
                                NSLog(@"Rate limit reached");
                                return;
                            }
                            
                            // Check if there was an error
                            
                            if (error) {
                                NSLog(@"Error: %@", error.localizedDescription);
                                return;
                            }
                            
                            // Check if there is some response data
                            
                            if (responseData) {
                                
                                NSError *error = nil;
                                NSArray *TWData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                                
                                NSString *profileImageStringURL = [(NSDictionary *)TWData objectForKey:@"profile_image_url_https"];
                                
                                // Get the profile image in the original resolution
                                
                                profileImageStringURL = [profileImageStringURL stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
                                [self getProfileImageForURLString:profileImageStringURL];
                                
                                
                            }
                        });
                    }];
                }
            } else {
                NSLog(@"No access granted");
            }
        }];
        
    }
}

- (void) getProfileImageForURLString:(NSString *)urlString;
{
    CGRect frame;
    frame.origin.x=0;
    frame.origin.y=150;
    frame.size.height=176;//self.view.frame.size.height;
    frame.size.width=self.view.frame.size.width;
    _tabla.frame=frame;
    menuItems = @[@"Eventos", @"Mis Eventos", @"Agregar Evento", @"Configuraciones"];
    [_tabla reloadData];

    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.foto_perfil.image = [UIImage imageWithData:data];
    
    /*self.foto_perfil.layer.cornerRadius = self.foto_perfil.image .size.width / 2;
     UIGraphicsBeginImageContextWithOptions( self.foto_perfil.bounds.size, NO, [UIScreen mainScreen].scale);
     [[UIBezierPath bezierPathWithRoundedRect: self.foto_perfil.bounds
     cornerRadius:50.0] addClip];
     [self.foto_perfil.image  drawInRect: self.foto_perfil.bounds];
     self.foto_perfil.image = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();*/
}
- (IBAction) slideRadioChangee:(UISlider *)sender {
    
    int radio = [[NSString stringWithFormat:@" %.1f", [sender value]] doubleValue]*10000;
    delegate.user_radio=[NSString stringWithFormat:@"%i",radio];
    if (radio==0) {
        radio=500;
    }
    if (radio>=1000) {
        radio=radio/1000;
        _radiolbl.text= [NSString stringWithFormat:@"%i kms.",radio];
    }
    else{
    _radiolbl.text= [NSString stringWithFormat:@"%i mts.",radio];
	}
        NSLog(@"%i",radio );
}



@end
