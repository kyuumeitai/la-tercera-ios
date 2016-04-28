//
//  DetalleViewController.m
//  La Tercera
//
//  Created by diseno on 16-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "DetalleBeneficioViewController.h"
#import "UsarBeneficioEstandar.h"
#import "Tools.h"

@interface DetalleBeneficioViewController ()

@end
@implementation DetalleBeneficioViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.benefitImageView.image = _benefitImage;
    self.benefitDiscountLabel.text = _benefitDiscount;
    self.benefitTitleLabel.text = _benefitTitle;
    self.benefitAdressLabel.text = _benefitAddress;
    self.benefitDescriptionTextView.text = _benefitDescription;
    
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
    
    UsarBeneficioEstandar *usarBeneficioEstandarViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"usarBeneficioScreen"];
    usarBeneficioEstandarViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:usarBeneficioEstandarViewController animated:YES completion:nil];

}


- (IBAction)seeInTheMapClicked:(id)sender {
    

    CLLocationCoordinate2D coord2DSource = CLLocationCoordinate2DMake(-33.467992, -70.626039);
      CLLocationCoordinate2D coord2DDestination = CLLocationCoordinate2DMake(-33.422463, -70.609491);

    [Tools openMapsAppWithSourceLocation:coord2DSource andDestinationLocation:coord2DDestination];
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
