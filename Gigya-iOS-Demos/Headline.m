//
//  Headline.m
//  La Tercera
//
//  Created by diseno on 14-06-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "Headline.h"

@implementation Headline
-(id)init {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(void)logDescription{
    
    NSLog(@" >>>> Artículo de id: %d, titulo: %@, resumen: %@, imagen Thumb: %@ ",_idArt,_title,_summary, _imagenThumbString);
    
}
@end
