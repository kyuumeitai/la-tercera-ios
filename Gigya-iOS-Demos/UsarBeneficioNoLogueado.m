//
//  UsarBeneficioNoLogueado.m
//  La Tercera
//
//  Created by diseno on 21-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "UsarBeneficioNoLogueado.h"
#import "Tools.h"

@implementation UsarBeneficioNoLogueado
- (IBAction)openSuscriptionWeb:(id)sender {
    [Tools openSafariWithURL:@"http://suscripcioneslt.latercera.com/"];
    
    [self dismissViewControllerAnimated:YES
                                           completion:nil];
    
}

@end
