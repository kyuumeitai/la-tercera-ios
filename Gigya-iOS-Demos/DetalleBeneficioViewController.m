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
            }
        });
    }:idBenefit];
}

-(void) reloadBenefitsDataFromService:(NSArray*)arrayJson{
    NSLog(@"  reload beenfits  ");
    
    NSDictionary *tempDict = (NSDictionary*)arrayJson;
    NSString* description = [tempDict objectForKey:@"description"];
    
    NSString* startDate = [tempDict objectForKey:@"start_date"];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"YYYY'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    NSDate *dateFromString1 = [dateFormatter1 dateFromString:startDate];
    NSDateFormatter *displayingFormatter1 = [NSDateFormatter new];
    [displayingFormatter1 setDateStyle:NSDateFormatterLongStyle];
    [displayingFormatter1 setDateFormat:@"dd' de 'MMMM' del 'YYYY"];
    NSString *displayStart = [displayingFormatter1 stringFromDate:dateFromString1];
    
    NSString* endDate = [tempDict objectForKey:@"end_date"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    NSDate *dateFromString = [dateFormatter dateFromString:endDate];
    NSDateFormatter *displayingFormatter = [NSDateFormatter new];
    [displayingFormatter setDateStyle:NSDateFormatterLongStyle];
    [displayingFormatter setDateFormat:@"dd' de 'MMMM' del 'YYYY"];
    NSString *displayEnd = [displayingFormatter stringFromDate:dateFromString];

    NSString *caducidad = [NSString stringWithFormat:@"Beneficio válido desde el %@ al %@",displayStart,displayEnd];
    
    self.expiredDateLabel.text=caducidad;
    
     NSString* summary = [tempDict objectForKey:@"summary"];
    self.benefitSubtitleLabel.text = summary;
    
    
    NSArray *profilesArray = (NSArray*)[tempDict objectForKey:@"profiles"];
    /*
    NSString *profile = profilesArray[0];
   
    NSString *stringWithoutTrash = [profile
                                     stringByReplacingOccurrencesOfString:@"u'" withString:@"'"];
    stringWithoutTrash = [stringWithoutTrash
                          stringByReplacingOccurrencesOfString:@"{" withString:@""];
    
    stringWithoutTrash= [stringWithoutTrash
                                stringByReplacingOccurrencesOfString:@"'nombre':" withString:@""];
    
    stringWithoutTrash= [stringWithoutTrash
                         stringByReplacingOccurrencesOfString:@"'" withString:@""];
    
    NSString *profile2 = profilesArray[0];
    
    NSString *stringWithoutTrash2 = [profile2
                                    stringByReplacingOccurrencesOfString:@"u'" withString:@"'"];
    
    stringWithoutTrash2= [stringWithoutTrash2
                                stringByReplacingOccurrencesOfString:@"'id':" withString:@""];
    stringWithoutTrash2= [stringWithoutTrash2
                         stringByReplacingOccurrencesOfString:@" " withString:@""];
      stringWithoutTrash2 =  [stringWithoutTrash2                 stringByReplacingOccurrencesOfString:@"}" withString:@""];
NSArray *profilesValues = [stringWithoutTrash componentsSeparatedByString:@","];
    
   NSLog(@"Profile text : %@",stringWithoutTrash);
    NSString* profileName = profilesValues[0];
    NSString* profileId = profilesValues[1];
    NSLog(@"Profile Name : %@ and Profile Id: %@",profileName,profileId);
*/
    
    NSString *finalDescription = [NSString stringWithFormat:@"<span style=\"font-family: PT Sans; font-size: 16\">%@</span>",description];


    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                            initWithData: [finalDescription dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes:nil                                            error: nil
                                            ];

    self.benefitDescriptionTextView.attributedText = attributedString;

    
}



@end
