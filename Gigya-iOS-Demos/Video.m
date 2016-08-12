//
//  Video.m
//  La Tercera
//
//  Created by diseno on 12-08-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "Video.h"

@implementation Video

-(id)init {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)logDescription{
    NSLog(@" >>>> Artículo de id: %d, titulo: %@, resumen: %@, imagen Thumb: %@, link de Video: %@ ",_idVideo,_title,_summary, _imagenThumbString,_link);
}
@end
