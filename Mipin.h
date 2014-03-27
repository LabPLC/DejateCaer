//
//  Mipin.h
//  LugaresCDMX
//
//  Created by Carlos Castellanos on 23/01/14.
//  Copyright (c) 2014 Carlos Castellanos. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>

@class CalloutAnnotation;

@interface Mipin : NSObject  <MKAnnotation> {
    
    // Creamos un título
    NSString *title;
    // Declaramos un subtítulo
    NSString *subtitle;
    // Y una coordenada
    CLLocationCoordinate2D coordinate;
    
}
// Definimos sus propiedades
@property (nonatomic, assign) int  id_event;
@property (nonatomic, copy) NSString *tipo;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

// Y el método de inicialización
- (id)initWithTitle:(NSString *)aTitle subtitle:(NSString*)aSubtitle andCoordinate:(CLLocationCoordinate2D)coord tipo:(NSString*)atipo evento:(int)id_evento;
@property (nonatomic, weak) CalloutAnnotation *calloutAnnotation;

@end