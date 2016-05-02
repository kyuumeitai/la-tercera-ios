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
    self.benefitDescriptionTextView.text = _benefitDescription;
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
                //[self reloadBenefitsDataFromService:arrayJson];
                 NSLog(@"Lista json del beneficio: %@",arrayJson);
            }
        });
    }:idBenefit];
}

/*
-(void) reloadBenefitsDataFromService:(NSArray*)arrayJson{
    NSLog(@"  reload beenfits  ");
    self.benefitsItemsArray1 = [[NSMutableArray alloc] init];
    
    NSDictionary *tempDict = (NSDictionary*)arrayJson;
    id benefits = [tempDict objectForKey:@"benefits"];
    
    
    for (id benefit in benefits){
        
        id titleBen = [benefit objectForKey:@"title"];
        id idBen = [benefit objectForKey:@"id"] ;
        id linkBen = [benefit objectForKey:@"url"] ;
        id summaryBen = [benefit objectForKey:@"summary"] ;
        id benefitLabelBen = [benefit objectForKey:@"benefit_label"] ;
        
        
        Benefit *beneficio = [[Benefit alloc] init];
        beneficio.idBen = idBen;
        beneficio.title = titleBen;
        beneficio.url = linkBen;
        beneficio.summary= summaryBen;
        beneficio.desclabel = benefitLabelBen;
        
        
        if([benefit objectForKey:@"image"] != [NSNull null]){
            UIImage *imagenBeneficio = nil;
            NSString *imagenBen = [benefit objectForKey:@"image"] ;
            NSArray * arr = [imagenBen componentsSeparatedByString:@","];
            
            //Now data is decoded. You can convert them to UIImage
            imagenBeneficio = [Tools decodeBase64ToImage:[arr lastObject]];
            beneficio.imagenNormal = imagenBeneficio;
        }
        
        [self.benefitsItemsArray1 addObject:beneficio];
        
        
        
    }
    self.view.alpha = 0.0;
    [self.tableView reloadData];
    [UIView animateWithDuration:0.5
                     animations:^{ self.view.alpha = 1.0;
                     }
                     completion:^(BOOL finished)
     {
         [SVProgressHUD dismiss];
     }];
    
    
    NSLog(@" ******* RELOAD DATA TABLEEE ****** ----------------------");
}
*/


@end
