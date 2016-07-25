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
#import "SessionManager.h"
#import "Tools.h"

@interface DetalleBeneficioViewController ()

@end
@implementation DetalleBeneficioViewController
@synthesize benefitId;
CLLocationCoordinate2D storeLocation;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.benefitImageView.image = _benefitImage;
     self.benefitAdressLabel.alpha = 0;
      // self.benefitDescriptionTextView.text = _benefitDescription;
   // [self loadBenefitForBenefitId:self.benefitId];
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
    SessionManager *sesion = [SessionManager session];
    CLLocation *userLocation = sesion.userLocation;


      CLLocationCoordinate2D coord2DSource = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    CLLocationCoordinate2D coord2DDestination = storeLocation;

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

-(void)loadStoreWithId:(int)idStore{
    
    NSLog(@"Load Store");
    // IMPORTANT - Only update the UI on the main thread
    // [SVProgressHUD showWithStatus:@"Obteniendo beneficios disponibles" maskType:SVProgressHUDMaskTypeClear];
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    BOOL estaConectado = [connectionManager verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);
    [connectionManager getStoreWithId:^(BOOL success, NSArray *arrayJson, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                NSLog(@"Error obteniendo datos! %@ %@", error, [error localizedDescription]);
            } else {
                [self loadStoreDataFromService:arrayJson];
            }
        });
    }:idStore];
}

-(void) loadStoreDataFromService:(NSArray*)arrayJson{
    
    NSDictionary *storeDict = (NSDictionary*)arrayJson;

    NSString* address = [storeDict objectForKey:@"address"];
   // NSString* city = [storeDict objectForKey:@"city"];
    NSString* region = [storeDict objectForKey:@"region"];
    NSArray* arrayCoords = (NSArray*)[storeDict objectForKey:@"geocoords"];
    double latitud = [arrayCoords[0] doubleValue];
    double longuitud = [arrayCoords[1] doubleValue];
    storeLocation = CLLocationCoordinate2DMake(latitud, longuitud);
    CLLocation *coordenadas = [[CLLocation alloc] initWithLatitude:latitud longitude:longuitud ];
    NSString * direccion = [NSString stringWithFormat:@"%@, Región %@",address,region];
    self.benefitAdressLabel.text = direccion;
    self.benefitAdressLabel.alpha = 0;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{ self.benefitAdressLabel.alpha = 1;}
                     completion:nil];
    // NSLog(@"Geolocalizacion es: Latitud:%f, Longuitud:%f",coordenadas.latitude,coordenadas.longitude);
    SessionManager *sesion = [SessionManager session];
    CLLocation *userLocation = sesion.userLocation;
    
    CLLocationDistance distanceMeters = [coordenadas distanceFromLocation:userLocation];
    //int kms = (int) (distanceMeters/1000);

    NSLog(@"A %f kms de distancia",distanceMeters);
}

-(void) reloadBenefitsDataFromService:(NSArray*)arrayJson{
    NSLog(@"  reload beenfits  ");
    
    NSDictionary *tempDict = (NSDictionary*)arrayJson;
    
    //Loading summary
    NSString* summary = [tempDict objectForKey:@"summary"];
    self.benefitSubtitleLabel.text = summary;
    //[self.benefitSubtitleLabel setNumberOfLines:0];
    //[self.benefitSubtitleLabel sizeToFit];
    self.benefitSubtitleLabel.alpha = 0;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{ self.benefitSubtitleLabel.alpha = 1;}
                     completion:nil];
    
    //Loading Duration
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
    self.expiredDateLabel.alpha = 0;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{ self.expiredDateLabel.alpha = 1;}
                     completion:nil];
    
    NSArray *profilesArray= (NSArray*)[tempDict objectForKey:@"profiles"];
    NSDictionary * profileDictionary = (NSDictionary*)profilesArray[0];
    NSLog(@"Profile text : %@",profileDictionary );
    
    BOOL forFremium = false;
    BOOL forSuscriptor = false;
    BOOL forAnonimo = false;
    
    
    for(id key in profileDictionary) {
        int valor= [[profileDictionary objectForKey:@"id"] intValue];

        if ( valor == 0 ){
            forAnonimo = true;
           // NSLog(@"Es anonimo");
        }
        
        if ( valor == 1 ){
            forFremium = true;
           // NSLog(@"Es fremium");
        }
        
        if ( valor == 2 ){
            forSuscriptor = true;
            //NSLog(@"Es suscriptor");
        }

     }

      //  self.profileBenefitLabel.text = nameProfile;
    self.profileBenefitLabel.alpha = 0;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{ self.profileBenefitLabel.alpha = 1;}
                     completion:nil];
    

    self.benefitDiscountLabel.text = _benefitDiscount;
    self.benefitTitleLabel.text = _benefitTitle;
    self.benefitAdressLabel.text = _benefitAddress;
    
    self.benefitDiscountLabel.alpha = 0;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{ self.benefitDiscountLabel.alpha = 1;}
                     completion:nil];
    
    self.benefitTitleLabel.alpha = 0;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{ self.benefitTitleLabel.alpha = 1;}
                     completion:nil];


    //Loading Store
    NSArray* storeArray = (NSArray*)[tempDict objectForKey:@"related_store"];
    int storeId = [[storeArray firstObject] intValue];
    NSLog(@" EL store relacionado es:%d",storeId);
    [self loadStoreWithId:storeId];

    //Loading Description
    NSString* description = [tempDict objectForKey:@"description"];

    NSString *finalDescription = [NSString stringWithFormat:@"<span style=\"font-family: PT Sans; font-size: 16\">%@</span>",description];


    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                            initWithData: [finalDescription dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes:nil                                            error: nil
                                            ];

    self.benefitDescriptionTextView.attributedText = attributedString;
}

-(IBAction)shareBenefit:(id)sender{
    
    [Tools shareText:self.benefitSubtitleLabel.text andImage:self.benefitImageView.image  andUrl:[NSURL URLWithString:@"www.google.com"] forSelf:self];
    
}


@end
