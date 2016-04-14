//
//  NewspaperThumbnail.m
//  La Tercera
//
//  Created by diseno on 13-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "NewspaperPage.h"


@implementation NewspaperPage

-(id)init {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)logDescription{
    
    NSLog(@" >>>> NewsPaper:titulo: %@, url:%@, imagenThumbnail: %@, imagenBig:%@",_title,_urlThumbnail,_imagenThumbnail,_imagenBig );
    
}
@end
