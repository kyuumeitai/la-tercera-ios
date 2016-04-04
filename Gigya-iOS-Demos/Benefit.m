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
    
    NSLog(@" >>>> Beneficio de id: %@, titulo: %@, url:%@, imagen: %@, summary: %@",_idBen,_title,_url,_imagen,_summary );
    
}
@end
