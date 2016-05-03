//
//  Category.m
//  La Tercera
//
//  Created by Mario Alejandro Ramos on 03-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "Category.h"

@implementation Category

-(id)init {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)logDescription{
    
    NSLog(@" >>>> Categoria de id: %@, titulo: %@, url:%@, imagen: %@, arrayBen:%@",_idCat,_title,_url,_imagenDestacada, _arrayBenefits );
}

@end
