//
//  ViewControllerTest.m
//  DejateCaer
//
//  Created by Carlos Castellanos on 25/04/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"
#import "DescripcionViewController.h"
#import "ViewController_ViewControllerClassExtension.h"
@interface ViewControllerTest : XCTestCase

@end

@implementation ViewControllerTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

// comprobamos que el arreglo de eventos este inicializado y tenga eventos
- (void)testMatchesDifferentCardWithSameContents
{
    ViewController *firstView = [[ViewController alloc] init];
    int e=0;
    if (firstView.eventos!=nil)
    {
        e=1;
    }
    else{
        e=0;
    
    }
    
    
    XCTAssertEqual(e, 0, @" tenemos eventos");
}

//despues de cada llamada con el servidor verificamos el contenido del array eventos
-(void)testofTestGetEventos{
    ViewController *firstView = [[ViewController alloc] init];
    
    //guardamos la respuesta
    int returnValue = [firstView respuestaObtenerEventos];
    //comparamos si es 1 
    XCTAssertEqual(returnValue, 1, @" tenemoss 1");

}

-(void) testConecction{


}

@end
