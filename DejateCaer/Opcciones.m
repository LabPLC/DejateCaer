//
//  Opcciones.m
//  DejateCaer
//  @rockarloz
//  rockarlos@me.com
//  Created by Carlos Castellanos on 04/04/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import "Opcciones.h"
#import "AppDelegate.h"
@implementation Opcciones
{
    AppDelegate *delegate;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self inicio];
        [_slide addTarget:self action:@selector(slidingStopped:)forControlEvents:UIControlEventTouchUpInside];
        [_slide addTarget:self action:@selector(slidingStopped:)forControlEvents:UIControlEventTouchUpOutside];
        
        [[NSUserDefaults standardUserDefaults] stringForKey:@"nombre"];
        delegate= (AppDelegate *) [[UIApplication sharedApplication] delegate];
    }
    return self;
}
-(void)loadView{
    [_slide addTarget:self action:@selector(slidingStopped:)forControlEvents:UIControlEventTouchUpInside];
    [_slide addTarget:self action:@selector(slidingStopped:)forControlEvents:UIControlEventTouchUpOutside];
    [self inicio];
    [[NSUserDefaults standardUserDefaults] stringForKey:@"nombre"];
    delegate= (AppDelegate *) [[UIApplication sharedApplication] delegate];

}
- (IBAction)Aceptar:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"aceptar"  object:self];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)inicio{
    int radio=[delegate.user_radio intValue];
    if (radio==0) {
        radio=500;
    }
    if (radio>=1000) {
        radio=radio/1000;
        _radiolbl.text= [NSString stringWithFormat:@"%i km.",radio];
    }
    else{
        _radiolbl.text= [NSString stringWithFormat:@"%i m.",radio];
	}

}
- (IBAction) slideRadioChangee:(UISlider *)sender {
    
    int radio = [[NSString stringWithFormat:@" %.1f", [sender value]] doubleValue]*10000;
    delegate.user_radio=[NSString stringWithFormat:@"%i",radio];
    if (radio==0) {
        radio=500;
    }
    if (radio>=1000) {
        radio=radio/1000;
        _radiolbl.text= [NSString stringWithFormat:@"%i km.",radio];
    }
    else{
        _radiolbl.text= [NSString stringWithFormat:@"%i m.",radio];
	}
    
    NSLog(@"%i",radio );
}

- (void) slidingStopped:(id)sender
{
    NSLog(@"stopped sliding");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"actualizar" object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [self inicio];
}

-(void)willMoveToSuperview:(UIView *)newSuperview {
    
    if (delegate.isOption) {
        [_slide addTarget:self action:@selector(slidingStopped:)forControlEvents:UIControlEventTouchUpInside];
        [_slide addTarget:self action:@selector(slidingStopped:)forControlEvents:UIControlEventTouchUpOutside];
        [self inicio];
        [[NSUserDefaults standardUserDefaults] stringForKey:@"nombre"];
        delegate= (AppDelegate *) [[UIApplication sharedApplication] delegate];
    }
}

-(void)didMoveToSuperview{
     delegate= (AppDelegate *) [[UIApplication sharedApplication] delegate];
    _slide.value=[delegate.user_radio doubleValue]/10000;
    if (delegate.isOption) {
        [_slide addTarget:self action:@selector(slidingStopped:)forControlEvents:UIControlEventTouchUpInside];
        [_slide addTarget:self action:@selector(slidingStopped:)forControlEvents:UIControlEventTouchUpOutside];
        [self inicio];
        [[NSUserDefaults standardUserDefaults] stringForKey:@"nombre"];
       
    }


}
-(IBAction)acerca:(id)sender{

    UIAlertView *acerca=[[UIAlertView alloc]initWithTitle:@"Acerca de Eventario" message:@"Eventario en su versión beta, permite  encontrar eventos en la ciudad de México de una manera fácil y amigable, los eventos que esta aplicación presenta  son eventos que promueven la ciudad de México. Con esto dar siempre al usuario una opcción atractiva para asisitir a los eventos que la ciudad le ofrece. " delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
    [acerca show];
}

-(IBAction)terminos:(id)sender{
    
    UIAlertView *terminos=[[UIAlertView alloc]initWithTitle:@"Términos de Uso" message:@"Esta aplicación es de código abierto, puedes encontrar más información en www.eventario.mx " delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
    [terminos show];
}

@end
