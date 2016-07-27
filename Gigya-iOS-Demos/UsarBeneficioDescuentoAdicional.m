//
//  UsarBeneficioDescuentoAdicional.m
//  La Tercera
//
//  Created by diseno on 21-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "UsarBeneficioDescuentoAdicional.h"
#import "ConfirmationViewController.h"
#import "TarjetaVirtual.h"
#import "ConnectionManager.h"
#import "UserProfile.h"
#import "SessionManager.h"

@interface UsarBeneficioDescuentoAdicional ()

@end

@implementation UsarBeneficioDescuentoAdicional
NSString * idBeneficio = @"";//@"187";
NSString * codComercio = @"";
NSString * idComercio = @"";
NSString * sucursal = @"";//@"273";
NSString * email;
//NSString * email = @"olgaeliagarrido@yahoo.com";
//NSString * email = @"catabarbara.jpc@gmail.com";
//NSString * email = @"acornejo@copesa.cl";

int monto = 0;

- (void)viewDidLoad {
    
   monto = [_montoTextField.text intValue];

    [super viewDidLoad];
    
    //codComercio = _codigoComercioTextfield.text;

    // Do view setup here.
}

- (void)initWithIdBeneficio:(NSString*)_idBeneficio andSucursal:(NSString*)_idSucursal andCommerce:(NSString*)_idComercio{
    idBeneficio = _idBeneficio;
    sucursal = _idSucursal;
    idComercio = _idComercio;
    //_commerce
    NSLog(@"Iniciado y el beneficio es id: %@ y la sucursal %@ y el comercio es: %@", idBeneficio, sucursal, idComercio);

}

- (IBAction)confirmUseBenefitClicked:(id)sender {
    
    NSLog(@"Confirmar beneficio click DETECTED");
    
    SessionManager *sesion = [SessionManager session];
    
    NSLog(@"Singleton description: %@",[sesion profileDescription]);
    UserProfile *perfil = [sesion getUserProfile];

    ConnectionManager * connectionManager = [[ConnectionManager alloc] init];
    
   email = perfil.email;
  
    NSString *resultMessage = [connectionManager getVirtualCardWithEmail:email];
    NSLog(@"El mensaje del WS de tarjeta es: %@",resultMessage);
    
    NSData *data = [resultMessage dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    int exito = [[json objectForKey:@"exito"] intValue];
    
    NSLog(@"Entonces el resultado de solicitar la tarjeta es : %d",exito);
    
    if(exito==1){
        
        NSLog(@"Erxitoooo! :D");

            // [self pushViewController:tarjetaVirtual animated:YES];
    }else{
        
         NSLog(@"Failed :(");
        /*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Usuario no suscrito"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
         */
        NSString *cardImage64 = [json objectForKey:@"imagen_tarjeta"];
        
        NSArray * stringFiltrado = [cardImage64 componentsSeparatedByString:@","];
        
        //Now data is decoded. You can convert them to UIImage
        
        UIImage *imagenTarjetaVirtual =  [self decodeBase64ToImage:[stringFiltrado lastObject]];
        
        TarjetaVirtual * tarjetaVirtual = [self.storyboard instantiateViewControllerWithIdentifier:@"tarjetaVirtualScreen"];
        tarjetaVirtual.virtualCardImage = imagenTarjetaVirtual;
        [self presentViewController:tarjetaVirtual animated:YES completion:nil];

    }
    codComercio = [NSString stringWithFormat:@"C%@S%@",idComercio,sucursal];
    NSLog(@"Vamos a usar el beneficio y llamar al WS");
     NSLog(@"El codigo comercio es: %@",codComercio);
   // ConnectionManager * connectionManager = [[ConnectionManager alloc] init];
  resultMessage = [connectionManager UseBenefitWithIdBenefit:idBeneficio codigoComercio:codComercio sucursal:sucursal email:email monto:monto];
    NSLog(@"El mensaje del WS es: %@",resultMessage);
    
    ConfirmationViewController *confirmationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"confirmationScreen"];
    //confirmationViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    confirmationViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //[self presentViewController:confirmationViewController animated:YES completion:nil];
   
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

@end
