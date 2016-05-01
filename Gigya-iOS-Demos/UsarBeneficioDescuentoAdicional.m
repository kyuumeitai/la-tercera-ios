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
    CATransition* transition = [CATransition animation];
    transition.duration = 0.8;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    //[self.navigationController pushViewController:confirmationViewController animated:YES ];
    [self presentViewController:confirmationViewController animated:YES completion:nil];

    /*
    confirmationViewController.modalPresentationStyle = UIModalP
    //confirmationViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:confirmationViewController animated:YES completion:nil];
    */
    
}

@end
