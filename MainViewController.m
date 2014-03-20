//
//  MainViewController.m
//  DejateCaer
//
//  Created by Carlos Castellanos on 14/03/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import "MainViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#define kExposedWidth 200.0
#define kMenuCellID @"MenuCell"


@interface MainViewController ()
@property (nonatomic, strong) UITableView *menu;
@property (nonatomic, strong) IBOutlet UIImageView *foto_perfil;
@property (nonatomic, strong) IBOutlet FBProfilePictureView *foto_perfil1;
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) NSArray *menuTitles;

@property (nonatomic, assign) NSInteger indexOfVisibleController;

@property (nonatomic, assign) BOOL isMenuVisible;
@end

@implementation MainViewController
{
int flag;
}
- (id)initWithViewControllers:(NSArray *)viewControllers andMenuTitles:(NSArray *)menuTitles
{
    if (self = [super init])
    {
        // revisa si hay la misma cantidad de titulos y de views
        NSAssert(self.viewControllers.count == self.menuTitles.count, @"El numero de vistas y titulos debe coincidir !");    // (1)
        
        //Array con temporal con capacidad del los viewcontrollers recibidos
        NSMutableArray *tempVCs = [NSMutableArray arrayWithCapacity:viewControllers.count];
        
        //Guardamos el array de los titulos en un array propio
        self.menuTitles = [menuTitles copy];
        
        // for checando y recorriendo si hay  viewcontrolles en el array recibido
        for (UIViewController *vc in viewControllers) // (2)
        {
            //si el viewcontroller actua no es navigation controller
            if (![vc isMemberOfClass:[UINavigationController class]])
            {
                //creamos navegation contoller con root vc y lo añadimos al array temporal
                [tempVCs addObject:[[UINavigationController alloc] initWithRootViewController:vc]];
            }
            else // agregamos el vc directo solo si es navigation controller
                [tempVCs addObject:vc];
            
            //creamos el boton del menu y le asignamos una accion
            
            
          
            
            UIImage *menu_image = [UIImage imageNamed:@"menuButton@2x.png"];
            UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
            [face addTarget:self
                       action:@selector(toggleMenuVisibility:)
             forControlEvents:UIControlEventTouchDown];
            face.bounds = CGRectMake( 0, 0, 35, 30 );
            [face setImage:menu_image forState:UIControlStateNormal];
            UIBarButtonItem *faceBtn = [[UIBarButtonItem alloc] initWithCustomView:face];
            
            UIBarButtonItem *revealMenuBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(toggleMenuVisibility:)]; // (3)
            revealMenuBarButtonItem.customView=face;
            //si existe boton el navigation controller lo recorre a la derecha y pone el del menu al principio
            UIViewController *topVC = ((UINavigationController *)tempVCs.lastObject).topViewController;
            topVC.navigationItem.leftBarButtonItems = [@[revealMenuBarButtonItem] arrayByAddingObjectsFromArray:topVC.navigationItem.leftBarButtonItems];
            
            
        }
        self.viewControllers = [tempVCs copy];
        // agrgamos el delegado y source del menu
        self.menu = [[UITableView alloc] init]; // (4)
        self.menu.delegate = self;
        self.menu.dataSource = self;
        
    }
    return self;
}



- (void)viewDidLoad
{
    CGRect frame_foto;
    frame_foto.size.height=74;
    frame_foto.size.width=74;
    frame_foto.origin.x=63;
    frame_foto.origin.y=47;
    
 
    
    
    UIImage *image = [UIImage imageNamed:@"sin_perfil.jpg"];
    self.foto_perfil = [[UIImageView alloc] initWithImage:image];
    self.foto_perfil1=[[FBProfilePictureView alloc]initWithFrame:CGRectMake(0, 0, 63, 47)];
    self.foto_perfil.backgroundColor = [UIColor clearColor];
    self.foto_perfil.frame=frame_foto;
    
    self.foto_perfil.layer.cornerRadius = image.size.width / 2;
    //self.foto_perfil.layer.cornerRadius = 2000;
    UIGraphicsBeginImageContextWithOptions( self.foto_perfil.bounds.size, NO, [UIScreen mainScreen].scale);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect: self.foto_perfil.bounds
                                cornerRadius:50.0] addClip];
    // Draw your image
    [image drawInRect: self.foto_perfil.bounds];
    
    // Get the image, here setting the UIImageView image
     self.foto_perfil.image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
   // self.foto_perfil.profileID = nil;
    [self.view addSubview: self.foto_perfil];
   // [self.view addSubview: self.foto_perfil1];
    
    flag=1;
    //fondo de la vista que contiene la tabla del menu
    self.view.backgroundColor=[UIColor grayColor];
    [super viewDidLoad];
    //table del menu
    [self.menu registerClass:[UITableViewCell class] forCellReuseIdentifier:kMenuCellID];
    self.menu.frame = self.view.bounds;
    //añadimos el menu a la vista actual
    CGRect frame;
    frame.size.height=176;//self.view.frame.size.height;
    frame.size.width=self.view.frame.size.width;
    frame.origin.x=0;
    frame.origin.y=150;
    self.menu.frame=frame;
    self.menu.scrollEnabled = NO;
   // CGRectMake(0, 150,self.view.frame.size.width , self.view.frame.size.height)];
    [self.view addSubview:self.menu];
    // se guarda el index (de la posicion en el array del controller que se mostrata primero)
    self.indexOfVisibleController = 0;
    // le decimos cual sera el controller con el que habra con que comenzar
    UIViewController *visibleViewController = self.viewControllers[0];
   
    //Añadimos boton de fb
    
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.delegate = self;
    loginView.readPermissions = @[@"basic_info", @"email", @"user_likes"];
    
    // Align the button in the center horizontally
    CGRect frame_fb;
    frame_fb.size.height=35;//self.view.frame.size.height;
    frame_fb.size.width=200;
    frame_fb.origin.x=0;
    frame_fb.origin.y=361;
    loginView.frame=frame_fb;
    [self.view addSubview:loginView];
    //
    
    
    visibleViewController.view.layer.shadowOpacity = 0.75f;
    visibleViewController.view.layer.shadowRadius = 10.0f;
    visibleViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    UIPanGestureRecognizer *tapTest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slide:)];
    [tapTest setMinimumNumberOfTouches:1];
    [tapTest setMaximumNumberOfTouches:1];
    [tapTest setDelegate:self];
    [visibleViewController.view addGestureRecognizer:tapTest];
    // [visibleViewController.view addGestureRecognizer:self.menu.panGesture];
    
    visibleViewController.view.frame = [self offScreenFrame];
    [self addChildViewController:visibleViewController]; // (5)
    [self.view addSubview:visibleViewController.view]; // (6)
    // Yes si el menu se esta viendo
    self.isMenuVisible = NO;
    
    [self adjustContentFrameAccordingToMenuVisibility]; // (7)
    
    
    [self.viewControllers[0] didMoveToParentViewController:self]; // (8)
    
}

-(void)slide:(id)sender{
    flag=flag+1;
       if (flag==8) {
        // [self toggleMenuVisibility:self];
        flag=0;
    }
    
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    
    // CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:[sender view]];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        //   UIView *childView = nil;
        
        if(velocity.x < 0) {
            if (self.isMenuVisible) {
                [self toggleMenuVisibility:nil];
            }
        } else {
            // if (!_showingLeftPanel) {
            //   childView = [self getRightView];
            // }
            if (!self.isMenuVisible) {
                [self toggleMenuVisibility:nil];
            }
        }
        // Make sure the view you're working with is front and center.
        // [self.view sendSubviewToBack:childView];
        [[sender view] bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    }
    
}
//evento que se llama cuando presionamos el boton de menu
- (void)toggleMenuVisibility:(id)sender // (9)
{
    self.isMenuVisible = !self.isMenuVisible;
    [self adjustContentFrameAccordingToMenuVisibility];
}

// ajustamos la pantalla cuando el menu este o no visible
- (void)adjustContentFrameAccordingToMenuVisibility // (10)
{
    UIViewController *visibleViewController = self.viewControllers[self.indexOfVisibleController];
    CGSize size = visibleViewController.view.frame.size;
    
    if (self.isMenuVisible)
    {
        // cuando el menu sera mostrado
        [UIView animateWithDuration:0.5 animations:^{
            visibleViewController.view.frame = CGRectMake(kExposedWidth, 0, size.width, size.height);
        }];
    }
    else
        //cuando el menu no se muestra
        [UIView animateWithDuration:0.5 animations:^{
            visibleViewController.view.frame = CGRectMake(0, 0, size.width, size.height);
        }];
    
}

- (void)replaceVisibleViewControllerWithViewControllerAtIndex:(NSInteger)index // (11)
{
    if (index == self.indexOfVisibleController) return;
    UIViewController *incomingViewController = self.viewControllers[index];
    incomingViewController.view.frame = [self offScreenFrame];
    UIViewController *outgoingViewController = self.viewControllers[self.indexOfVisibleController];
    CGRect visibleFrame = self.view.bounds;
    
    
    [outgoingViewController willMoveToParentViewController:nil]; // (12)
    
    [self addChildViewController:incomingViewController]; // (13)
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents]; // (14)
    [self transitionFromViewController:outgoingViewController // (15)
                      toViewController:incomingViewController
                              duration:0.5 options:0
                            animations:^{
                                outgoingViewController.view.frame = [self offScreenFrame];
                                
                            }
     
                            completion:^(BOOL finished) {
                                [UIView animateWithDuration:0.5
                                                 animations:^{
                                                     [outgoingViewController.view removeFromSuperview];
                                                     [self.view addSubview:incomingViewController.view];
                                                     incomingViewController.view.frame = visibleFrame;
                                                     [[UIApplication sharedApplication] endIgnoringInteractionEvents]; // (16)
                                                 }];
                                [incomingViewController didMoveToParentViewController:self]; // (17)
                                [outgoingViewController removeFromParentViewController]; // (18)
                                self.isMenuVisible = NO;
                                self.indexOfVisibleController = index;
                            }];
}


// (19):

// numero de secciones para el menu
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// los espacion que va a tener el menu
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuTitles.count;
}

// añadimos celdas al menu
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMenuCellID];
    cell.textLabel.text = self.menuTitles[indexPath.row];
    return cell;
}

// cuando seleccion una celda (opcion ) del menu
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self replaceVisibleViewControllerWithViewControllerAtIndex:0];//indexPath.row];
    [self toggleMenuVisibility:self];
}

- (CGRect)offScreenFrame
{
    return CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
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
      self.menuTitles=[[NSArray alloc]initWithObjects:@"Eventos",@"Mis Eventos",@"Agregar Evento",@"Configuraciones", nil];
    [self.menu reloadData];
    [self performSelector:@selector(getImage) withObject:nil afterDelay:3];
    

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
    self.foto_perfil1.profileID=nil;//[UIImage imageNamed:@"sin_perfil.jpg"];
     [self performSelector:@selector(getImage) withObject:nil afterDelay:1];
    self.menuTitles=[[NSArray alloc]initWithObjects:@"Eventos",@"Configuraciones", nil];
        [self.menu reloadData];
   // self.nameLabel.text = @"";
    //self.statusLabel.text= @"You're not logged in!";
}
@end
