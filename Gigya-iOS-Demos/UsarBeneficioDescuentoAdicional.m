//
//  UsarBeneficioDescuentoAdicional.m
//  La Tercera
//
//  Created by diseno on 21-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "UsarBeneficioDescuentoAdicional.h"
#import "ConfirmationViewController.h"

@interface UsarBeneficioDescuentoAdicional ()

@end

@implementation UsarBeneficioDescuentoAdicional

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (IBAction)confirmUseBenefitClicked:(id)sender {
    
    NSLog(@"Confirmar beneficio click DETECTED");
    
    ConfirmationViewController *confirmationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"confirmationScreen"];
    //confirmationViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    confirmationViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:confirmationViewController animated:YES completion:nil];
    
    
}

@end
