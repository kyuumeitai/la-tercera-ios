//
//  DetalleEventosViewController.m
//  La Tercera
//
//  Created by Mario Alejandro on 16-10-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "DetalleEventosViewController.h"
#import "UsarBeneficioEstandar.h"
#import "UsarBeneficioNoLogueado.h"
#import "UsarBeneficioDescuentoAdicional.h"
#import "ConnectionManager.h"
#import "SessionManager.h"
#import "UserProfile.h"
#import "Tools.h"

@interface DetalleEventosViewController ()

@end

@implementation DetalleEventosViewController

@synthesize eventoId;
CLLocationCoordinate2D storeLocationEvent;

BOOL forFremiumEvent = false;
BOOL forSuscriptorEvent = false;
BOOL forAnonimoEvent = false;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.eventoImageView.image = _eventoImage;
    self.eventoAdressLabel.alpha = 0;
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


#pragma mark -->> Data Functions <<---

/**
 Load Event from web service
 
 @param idEvent the id from the specific Event
 */
-(void)loadEventForEventId:(int)idEvent{
    
    NSLog(@"Load event ");
    
    // IMPORTANT - Only update the UI on the main thread
    // [SVProgressHUD showWithStatus:@"Obteniendo beneficios disponibles" maskType:SVProgressHUDMaskTypeClear];
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    BOOL estaConectado = [connectionManager verifyConnection];
    
    NSLog(@"Verificando conexión: %d",estaConectado);
    
    [connectionManager getEventWithEventId:^(BOOL success, NSArray *arrayJson, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                NSLog(@"Error obteniendo datos! %@ %@", error, [error localizedDescription]);
            } else {
                [self reloadBenefitsDataFromService:arrayJson];
            }
        });
    }:idEvent];
}



-(void) reloadBenefitsDataFromService:(NSArray*)arrayJson{
    NSLog(@"  reload eventos  ");
    
    NSDictionary *tempDict = (NSDictionary*)arrayJson;
    
    //Loading summary
    NSString* summary = [tempDict objectForKey:@"descripcion"];
    self.eventoSubtitleTextView.text = summary;
    //[self.benefitSubtitleLabel setNumberOfLines:0];
    //[self.benefitSubtitleLabel sizeToFit];
    self.eventoSubtitleTextView.alpha = 0;
    NSString* precioTemp = [tempDict objectForKey:@"precio"];
    NSString* precio = [NSString stringWithFormat:@"$%@",precioTemp];
    
    self.eventoDiscountLabel.text = precio;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{ self.eventoSubtitleTextView.alpha = 1;}
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
    
    NSString *caducidad = [NSString stringWithFormat:@"Evento válido desde el %@ al %@",displayStart,displayEnd];
    
    self.expiredDateLabel.text=caducidad;
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
            forAnonimoEvent = true;
            NSLog(@"Es anonimo");
        }
        
        if ( valor == 1 ){
            forFremiumEvent = true;
            NSLog(@"Es fremium");
        }
        
        if ( valor == 2 ){
            forSuscriptorEvent = true;
            NSLog(@"Es suscriptor");
        }
        
        
    }
    /*
     //We can read benefit profile
     for(id key in profileDictionary) {
     
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
     */
    
    
    //  self.profileBenefitLabel.text = nameProfile;
    self.profileEventoLabel.alpha = 0;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{ self.profileEventoLabel.alpha = 1;}
                     completion:nil];
    
    self.eventoTitleLabel.text = _eventoTitle;
    // self.eventoAdressLabel.text = _benefitAddress;
    
    self.eventoDiscountLabel.alpha = 0;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{ self.eventoDiscountLabel.alpha = 1;}
                     completion:nil];
    
    self.eventoTitleLabel.alpha = 0;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{ self.eventoTitleLabel.alpha = 1;}
                     completion:nil];
    
    /*
     //Loading Store
     NSArray* storeArray = (NSArray*)[tempDict objectForKey:@"related_store"];
     storeId = [[storeArray firstObject] intValue];
     NSLog(@" EL store relacionado es:%d",storeId);
     
     [self loadStoreWithId:storeId];
     
     */
    //Loading Description
    NSString* description = [tempDict objectForKey:@"descripcion"];
    
    NSString *finalDescription = [NSString stringWithFormat:@"<span style=\"font-family: PT Sans; font-size: 16\">%@</span>",description];
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithData: [finalDescription dataUsingEncoding:NSUnicodeStringEncoding]
                                                   options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                   documentAttributes:nil                                            error: nil
                                                   ];
    
    //self.eventoDescriptionTextView.attributedText = attributedString;
    self.eventoSubtitleTextView.text = description;
}

-(IBAction)shareBenefit:(id)sender{
    
    [Tools shareText:self.eventoSubtitleLabel.text andImage:self.eventoImageView.image  andUrl:[NSURL URLWithString:@"www.google.com"] forSelf:self];
    
}


@end
