//
//  UserProfile.m
//  La Tercera
//
//  Created by diseno on 28-06-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile

-(id)init {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)logDescription{
    
    NSLog(@" >>>> Objeto UserProfile de email: %@, status activo: %@,  perfil tipo: %i",_email,_profileType,_status);
}

@end
