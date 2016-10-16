//
//  Concurso.m
//  La Tercera
//
//  Created by Mario Alejandro on 15-10-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "Concurso.h"

@implementation Concurso

-(id)init {
    
    self = [super init];
    if (self) {
        
        
    }
    return self;
}
-(void)logDescription{
    
    NSLog(@" >>>> Concurso de id: %d, titulo: %@, url:%@, imagen: %@, summary: %@, fecha Inicio:%@, fecha Fin:%@, disponible anonimo: %i, disponible fremium: %i, disponible suscriptor: %i",_idConcurso,_title,_url,_imagenNormal,_summary,_fechaInicioConcurso, _fechaFinConcurso, _disponibleParaAnonimo,_disponibleParaFremium,_disponibleParaSuscriptor );
    
}
@end
