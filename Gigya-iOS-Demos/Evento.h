//
//  Evento.h
//  La Tercera
//
//  Created by Mario Alejandro on 15-10-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface Evento : NSObject

@property (nonatomic,strong) NSString * title;
@property (nonatomic,assign) int idEvento;
@property (nonatomic,strong) NSString * url;
@property (nonatomic,strong) NSString * summary;
@property (nonatomic,strong) NSString * desclabel;
@property (nonatomic,strong) UIImage *imagenNormal;
@property (nonatomic,strong) NSString *imagenNormalString;
@property (nonatomic,strong) NSDate *fechaInicioConcurso;
@property (nonatomic,strong) NSDate *fechaFinConcurso;
@property (nonatomic,strong) NSString *fechaInicioConcursoString;
@property (nonatomic,strong) NSDate *fechaFinConcursoString;
@property (nonatomic,strong) NSString *precio;
@property (nonatomic,strong) NSString *web;

@property BOOL allDay;
@property BOOL disponibleParaAnonimo;
@property BOOL disponibleParaFremium;
@property BOOL disponibleParaSuscriptor;

@property (nonatomic,copy) NSDictionary *ubicaciones;
@property (nonatomic,copy) NSDictionary *organizadores;

-(void)logDescription;

@end
