//
//  Benefit.m
//  La Tercera
//
//  Created by Mario Alejandro Ramos on 03-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "Benefit.h"

@implementation Benefit

-(id)init {
    
    self = [super init];
    if (self) {
        
        
    }
    return self;
}
-(void)logDescription{
    
    NSLog(@" >>>> Beneficio de id: %d, titulo: %@, url:%@, imagen: %@, summary: %@, disponible anonimo: %i, disponible fremium: %i, disponible suscriptor: %i ",_idBen,_title,_url,_imagenNormal,_summary,_disponibleParaAnonimo,_disponibleParaFremium,_disponibleParaSuscriptor );
    
}
@end
