//
//  contentType.m
//  La Tercera
//
//  Created by diseno on 10-08-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "ContentType.h"

@implementation ContentType

-(id)init {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)logDescription{
    
    NSLog(@" >>>> Objeto Content  /r Id: %d, Slug: %@,  Title: %@",_contentId,_contentSlug,_contentTitle);
}

@end
