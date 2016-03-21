//
//  DetalleViewController.m
//  La Tercera
//
//  Created by diseno on 16-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "DetalleViewController.h"
#import "UsarBeneficioEstandar.h"

@interface DetalleViewController ()

@end
@implementation DetalleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)usarBeneficioPressed:(id)sender {
    
    NSLog(@"Usar beneficio click DETECTED");
    
    UsarBeneficioEstandar *usarBeneficioEstandarViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"usarBeneficioEstandarSB"];
   // usarBeneficioEstandarViewController.modalTransitionStyle = UIModalPresentationPopover;
    usarBeneficioEstandarViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //[self.navigationController presentModalViewController:usarBeneficioEstandarViewController animated:YES];
    [self presentViewController:usarBeneficioEstandarViewController animated:YES completion:nil];
   // self pres
    //[self.navigationController pushViewController: usarBeneficioEstandarViewController animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
