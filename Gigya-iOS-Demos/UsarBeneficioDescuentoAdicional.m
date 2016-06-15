//
//  UsarBeneficioDescuentoAdicional.m
//  La Tercera
//
//  Created by diseno on 21-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "UsarBeneficioDescuentoAdicional.h"
#import "ConfirmationViewController.h"
#import "ConnectionManager.h"

@interface UsarBeneficioDescuentoAdicional ()

@end

@implementation UsarBeneficioDescuentoAdicional
NSString * idBeneficio = @"18";
NSString * codComercio = @"227";
NSString * sucursal = @"377";
NSString * email = @"roadell@gmail.com";
int monto = 1000;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    codComercio = [NSString stringWithFormat:@"C%@S%@",codComercio,sucursal];
    // Do view setup here.
}

- (IBAction)confirmUseBenefitClicked:(id)sender {
    
    NSLog(@"Confirmar beneficio click DETECTED");
    
    NSLog(@"Vamos a usar el beneficio y llamar al WS");
    ConnectionManager * connectionManager = [[ConnectionManager alloc] init];
    NSString *resultMessage = [connectionManager UseBenefitWithIdBenefit:idBeneficio codigoComercio:codComercio sucursal:sucursal email:email monto:monto];
    NSLog(@"El mensaje del WS es: %@",resultMessage);
    
    ConfirmationViewController *confirmationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"confirmationScreen"];
    //confirmationViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    confirmationViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //[self presentViewController:confirmationViewController animated:YES completion:nil];
    
}

@end
