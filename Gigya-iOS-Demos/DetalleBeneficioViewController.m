//
//  DetalleViewController.m
//  La Tercera
//
//  Created by diseno on 16-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "DetalleBeneficioViewController.h"
#import "UsarBeneficioEstandar.h"
#import "UsarBeneficioNoLogueado.h"
#import "UsarBeneficioDescuentoAdicional.h"
#import "ConnectionManager.h"
#import "SessionManager.h"
#import "UserProfile.h"
#import "Tools.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAITrackedViewController.h"
#import "GAIDictionaryBuilder.h"

@interface DetalleBeneficioViewController ()

@end
@implementation DetalleBeneficioViewController
@synthesize benefitId,benefitRemoteId;
@synthesize storeId;
@synthesize commerceId;
@synthesize benefitURL;

CLLocationCoordinate2D storeLocation;
BOOL forFremium = false;
BOOL forSuscriptor = false;
BOOL forAnonimo = false;

- (void)viewDidLoad {
     //NSLog(@"ESTOIY EN DetalleViewController.m");
    [super viewDidLoad];
    self.benefitImageView.image = _benefitImage;
     self.benefitAdressLabel.alpha = 0;
      // self.benefitDescriptionTextView.text = _benefitDescription;
   // [self loadBenefitForBenefitId:self.benefitId];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    NSString *value = [NSString stringWithFormat:@"Beneficios/%@/%@", _beneficioTipo, _benefitTitle];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:value];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    [super viewWillAppear:animated];
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
     SessionManager *sesion = [SessionManager session];
    UserProfile *profile = [sesion getUserProfile];
    int profileCode = profile.profileLevel;
    
    if ((profileCode == 0 && forAnonimo) || (profileCode == 1 && forFremium) || (profileCode == 2 && forSuscriptor)){
        NSLog(@"Beneficio válido para el usuario");
        
        UsarBeneficioDescuentoAdicional *usarBeneficioController = [self.storyboard instantiateViewControllerWithIdentifier:@"usarBeneficioScreen"];
        
        NSString * ben = [ NSString stringWithFormat:@"%i",benefitId];
        NSString * sto = [ NSString stringWithFormat:@"%i",storeId];
        NSString *comm = [ NSString stringWithFormat:@"%i",commerceId];
        NSLog(@"el detalle el parametro comercio sale con valor: %@ y commerce Id: %d",comm,commerceId);
        [usarBeneficioController initWithIdBeneficio:ben  andSucursal:sto andCommerce:comm];
    
        usarBeneficioController.nombreBeneficio = _benefitTitle;
        usarBeneficioController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:usarBeneficioController animated:YES completion:nil];
    
    } else {
        
        //suscriberNeededScreen
        NSLog(@"Sin permisos");
        UsarBeneficioNoLogueado *usarBeneficioNoLogueadoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"suscriberNeededScreen"];
        usarBeneficioNoLogueadoViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:usarBeneficioNoLogueadoViewController animated:YES completion:nil];
        
    }

}

- (IBAction)seeInTheMapClicked:(id)sender {
    SessionManager *sesion = [SessionManager session];
    CLLocation *userLocation = sesion.userLocation;


    CLLocationCoordinate2D coord2DSource = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    CLLocationCoordinate2D coord2DDestination = CLLocationCoordinate2DMake(self.benefitLocation.coordinate.latitude, self.benefitLocation.coordinate.longitude);
    
    NSLog(@"beneficio: %@", self.benefitLocation);
    
    if(self.benefitLocation){
        [Tools openMapsAppWithSourceLocation:coord2DSource andDestinationLocation:coord2DDestination];
    }else{
        NSLog(@"%@", _benefitAdressLabel.text);
        [Tools openMapsAppWithOneLocationAndAddress:coord2DSource address:_benefitAdressLabel.text];
    }
}


#pragma mark -->> Data Functions <<---

-(void)loadBenefitForBenefitId:(int)idBenefit{
    
    NSLog(@"Load category benefits");
    benefitId = idBenefit;
    
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

-(void)loadBenefitForBenefitId:(int)idBenefit andStore:(NSString*)_idStore  andAddress:(NSString*)_address  andLocation:(CLLocation*)_location {
    
    NSLog(@"Load category benefits from normal view");
    
    self.benefitAddress = _address;
    self.benefitLocation = _location;
    NSLog(@"La store es: %@ y la direccion es: %@",_idStore, _address);
    // IMPORTANT - Only update the UI on the main thread
    // [SVProgressHUD showWithStatus:@"Obteniendo beneficios disponibles"
   self.benefitAdressLabel.text = self.benefitAddress;
//maskType:SVProgressHUDMaskTypeClear];
    
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
-(void)loadBenefitForBenefitId:(int)idBenefit andStore:(NSString*)_idStore {

    NSLog(@"Load category benefits");
    NSLog(@"La store es%@",_idStore);
    benefitId = idBenefit;

    // IMPORTANT - Only update the UI on the main thread
   // [SVProgressHUD showWithStatus:@"Obteniendo beneficios disponibles" maskType:SVProgressHUDMaskTypeClear];
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    BOOL estaConectado = [connectionManager verifyConnection];

    NSLog(@"Verificando conexión: %d",estaConectado);
    
     NSString *resultMessage = [connectionManager getCommerceFromBenefitWithIdBenefit:benefitId];
    NSData *data = [resultMessage dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    int exito = [[json objectForKey:@"related_commerce"] intValue];
    
    NSLog(@"Entonces el comercio asociado es : %d",exito);
  
    commerceId = exito;
    
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

-(void)loadContestForContestId:(int)idContest{
    
    NSLog(@"Load category benefits");
    
    // IMPORTANT - Only update the UI on the main thread
    // [SVProgressHUD showWithStatus:@"Obteniendo beneficios disponibles" maskType:SVProgressHUDMaskTypeClear];
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    BOOL estaConectado = [connectionManager verifyConnection];
    
    NSLog(@"Verificando conexión: %d",estaConectado);
    
    [connectionManager getContestWithContestId:^(BOOL success, NSArray *arrayJson, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                NSLog(@"Error obteniendo datos! %@ %@", error, [error localizedDescription]);
            } else {
                [self reloadBenefitsDataFromService:arrayJson];
            }
        });
    }:idContest];
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
    self.benefitLocation = coordenadas;
   // CLLocation *coordenadas =self.benefitLocation;
    CLLocationDistance distanceMeters = [coordenadas distanceFromLocation:userLocation];
    //int kms = (int) (distanceMeters/1000);

    NSLog(@"A %f kms de distancia",distanceMeters);
}

-(void) reloadBenefitsDataFromService:(NSArray*)arrayJson{
    NSLog(@"  reload beenfits  ");
    
    NSDictionary *tempDict = (NSDictionary*)arrayJson;
    
    //Loading summary
    NSString* summary = [tempDict objectForKey:@"summary"];
    NSString* content= [tempDict objectForKey:@"content"];
    NSString* terms = [tempDict objectForKey:@"terms"];
    self.benefitURL = [tempDict objectForKey:@"benefit_url"];
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
    
    
    self.expiredDateLabel.alpha = 0;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{ self.expiredDateLabel.alpha = 1;}
                     completion:nil];
    
    NSArray *profilesArray= (NSArray*)[tempDict objectForKey:@"profiles"];
    
    for ( int i = 0; i < profilesArray.count; i++){
        NSDictionary * profileDictionary = (NSDictionary*)profilesArray[i];
        NSLog(@"Profile text : %@",profileDictionary );
        
        int valor= [[profileDictionary objectForKey:@"id"] intValue];
        
        if ( valor == 0 ){
            forAnonimo = true;
            NSLog(@"Es anonimo");
        }
        
        if ( valor == 1 ){
            forFremium = true;
            NSLog(@"Es fremium");
        }
        
        if ( valor == 2 ){
            forSuscriptor = true;
            NSLog(@"Es suscriptor");
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
    storeId = [[storeArray firstObject] intValue];
    NSLog(@" EL store relacionado es:%d",storeId);
    
    [self loadStoreWithId:storeId];
    
    //Loading Description
    NSString* description = [tempDict objectForKey:@"description"];
    
    
    NSString *textoCondiciones =[NSString stringWithFormat:@"%@\r%@\r%@", description,terms,caducidad];
    
    if(terms.length <1)
        textoCondiciones =[NSString stringWithFormat:@"%@\r%@", description,caducidad];
    NSLog(@"Texto confdixiones: %@",textoCondiciones);
    
    self.expiredDateLabel.text=textoCondiciones;
  
     NSString *finalDescription = [NSString stringWithFormat:@"<span style=\"font-family: PT Sans; font-size: 16\">%@</span>",content];
     
     
     NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
     initWithData: [finalDescription dataUsingEncoding:NSUTF16StringEncoding]
     options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
     documentAttributes:nil                                           error: nil
     ];
    
     self.benefitDescriptionTextView.attributedText = attributedString;
    
}

-(IBAction)shareBenefit:(id)sender{
    
    [Tools shareText:self.benefitSubtitleLabel.text andImage:self.benefitImageView.image  andUrl:[NSURL URLWithString:self.benefitURL] forSelf:self];
    
    NSString *value = [NSString stringWithFormat:@"Beneficios/btn/usarbeneficio/compartir/%@", _benefitTitle];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:value];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}


@end
