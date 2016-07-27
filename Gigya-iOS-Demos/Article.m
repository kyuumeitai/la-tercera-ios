
//
//  Article.m
//  La Tercera
//
//  Created by diseno on 14-06-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "Article.h"

@implementation Article
-(id)init {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(void)logDescription{
    
    NSLog(@" >>>> Beneficio de id: %d, titulo: %@, url:%@, resumen: %@, contenido: %@ , imagen Thumb: %@ , imagen Normal: %@",_idArt,_title,_url,_summary,_content, _imagenThumbString, _imagenNormalString );
    
}
@end
