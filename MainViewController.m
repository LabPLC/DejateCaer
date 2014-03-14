//
//  MainViewController.m
//  DejateCaer
//
//  Created by Carlos Castellanos on 14/03/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import "MainViewController.h"
#define kExposedWidth 200.0
#define kMenuCellID @"MenuCell"

@interface MainViewController ()
@property (nonatomic, strong) UITableView *menu;
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
            UIBarButtonItem *revealMenuBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(toggleMenuVisibility:)]; // (3)
            
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
    flag=1;
    //fondo de la vista que contiene la tabla del menu
    self.view.backgroundColor=[UIColor purpleColor];
    [super viewDidLoad];
    //table del menu
    [self.menu registerClass:[UITableViewCell class] forCellReuseIdentifier:kMenuCellID];
    self.menu.frame = self.view.bounds;
    //añadimos el menu a la vista actual
    [self.view addSubview:self.menu];
    // se guarda el index (de la posicion en el array del controller que se mostrata primero)
    self.indexOfVisibleController = 0;
    // le decimos cual sera el controller con el que habra con que comenzar
    UIViewController *visibleViewController = self.viewControllers[0];
    
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
                [self toggleMenuVisibility:self];
            }
        } else {
            // if (!_showingLeftPanel) {
            //   childView = [self getRightView];
            // }
            if (!self.isMenuVisible) {
                [self toggleMenuVisibility:self];
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
    [self replaceVisibleViewControllerWithViewControllerAtIndex:indexPath.row];
}

- (CGRect)offScreenFrame
{
    return CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}


@end
