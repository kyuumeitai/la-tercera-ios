//
//  DetalleViewController.m
//  La Tercera
//
//  Created by diseno on 16-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "DetalleBeneficioViewController.h"
#import "UsarBeneficioEstandar.h"
#import "ConnectionManager.h"
#import "Tools.h"

@interface DetalleBeneficioViewController ()

@end
@implementation DetalleBeneficioViewController
@synthesize benefitId;
- (void)viewDidLoad {
    [super viewDidLoad];

    self.benefitImageView.image = _benefitImage;
    self.benefitDiscountLabel.text = _benefitDiscount;
    self.benefitTitleLabel.text = _benefitTitle;
    self.benefitAdressLabel.text = _benefitAddress;
   // self.benefitDescriptionTextView.text = _benefitDescription;
    [self loadBenefitForBenefitId:self.benefitId];
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
    usarBeneficioEstandarViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:usarBeneficioEstandarViewController animated:YES completion:nil];

}

- (IBAction)seeInTheMapClicked:(id)sender {
    

    CLLocationCoordinate2D coord2DSource = CLLocationCoordinate2DMake(-33.467992, -70.626039);
      CLLocationCoordinate2D coord2DDestination = CLLocationCoordinate2DMake(-33.422463, -70.609491);

    [Tools openMapsAppWithSourceLocation:coord2DSource andDestinationLocation:coord2DDestination];
}


#pragma mark -->> Data Functions <<---

-(void)loadBenefitForBenefitId:(int)idBenefit{
    
    NSLog(@"Load category benefits");
    // IMPORTANT - Only update the UI on the main thread
   // [SVProgressHUD showWithStatus:@"Obteniendo beneficios disponibles" maskType:SVProgressHUDMaskTypeClear];
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    BOOL estaConectado = [connectionManager verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);
    [connectionManager getBenefitWithBenefitId:^(BOOL success, NSArray *arrayJson, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                NSLog(@"Error obteniendo datos! %@ %@", error, [error localizedDescription]);
            } else {
                [self reloadBenefitsDataFromService:arrayJson];
                 //NSLog(@"Lista json del beneficio: %@",arrayJson);
            }
        });
    }:idBenefit];
}


-(void) reloadBenefitsDataFromService:(NSArray*)arrayJson{
    NSLog(@"  reload beenfits  ");
    
    NSDictionary *tempDict = (NSDictionary*)arrayJson;
    NSString* description = [tempDict objectForKey:@"description"];
    

  NSLog(@"Description essss::: >>>> %@",description);

    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [description dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    self.benefitDescriptionTextView.attributedText = attributedString;
    
    
    NSLog(@" ******* RELOAD DATA TABLEEE ****** ----------------------");
}



@end
