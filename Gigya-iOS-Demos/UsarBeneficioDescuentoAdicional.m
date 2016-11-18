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

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation UsarBeneficioDescuentoAdicional
NSString * idBeneficio = @"";//@"187";
NSString * codComercio = @"";
NSString * idComercio = @"";
NSString * sucursal = @"";//@"273";
NSString * email;

int monto = 0;

- (void)viewDidLoad {
    _spinner.hidden = true;
   monto = [_montoTextField.text intValue];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
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

-(void)dismissKeyboard {
    [_montoTextField resignFirstResponder];
     [_codigoComercioTextfield resignFirstResponder];
}

- (IBAction)confirmUseBenefitClicked:(id)sender {
    _spinner.hidden = false;
    NSLog(@"Confirmar beneficio click DETECTED");
    
    if([self algunCampoVacio]){
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Datos incompletos"
                                      message:@"Debes ingresar todos los datos solicitados"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* volver= [UIAlertAction
                             actionWithTitle:@"Volver"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 NSLog(@"Volver apretado");
                                 [alert dismissViewControllerAnimated:YES completion:nil]
                                 
                                 ;
                             }];
        UIAlertAction* mostrarTarjeta = [UIAlertAction
                                 actionWithTitle:@"Mostrar Tarjeta Virtual"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                  
                                         [self showVirtualCard];
                          
                                     
                                 }];
        
        [alert addAction:mostrarTarjeta];
        [alert addAction:volver];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
    
    
    SessionManager *sesion = [SessionManager session];
    
    NSLog(@"Singleton description: %@",[sesion profileDescription]);
    UserProfile *perfil = [sesion getUserProfile];

    ConnectionManager * connectionManager = [[ConnectionManager alloc] init];
    
   email = perfil.email;
    monto = [_montoTextField.text intValue];
    

    
    codComercio = [NSString stringWithFormat:@"C%@S%@",idComercio,sucursal];
    NSLog(@"Vamos a usar el beneficio y llamar al WS");
    NSLog(@"El codigo comercio es: %@",codComercio);
    // ConnectionManager * connectionManager = [[ConnectionManager alloc] init];
    NSString *textoCod = _codigoComercioTextfield.text;
    NSString *resultMessageUseBenefit = [connectionManager UseBenefitWithIdBenefit:idBeneficio codigoComercio:textoCod sucursal:sucursal email:email monto:monto];

    NSLog(@"El mensaje del WS es: %@",resultMessageUseBenefit);
    NSData *data = [resultMessageUseBenefit dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    int exito = [[json objectForKey:@"exito"] intValue];
    
    
    if(exito==1){
        
        NSLog(@"Erxitoooo! :D");
        ConfirmationViewController *confirmationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"confirmationScreen"];
        //confirmationViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        confirmationViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
       [self presentViewController:confirmationViewController animated:YES completion:nil];

    }else{
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Algo ha salido mal"
                                      message:@"Para hacer válido el descuento muestra la Tarjeta Virtual al vendedor"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* volver= [UIAlertAction
                                actionWithTitle:@"Volver"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {

                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                }];
        UIAlertAction* mostrarTarjeta = [UIAlertAction
                                         actionWithTitle:@"Mostrar Tarjeta Virtual"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                         
                                        
                                                 [self showVirtualCard];
                                           
                                         }];
        
        [alert addAction:mostrarTarjeta];
        [alert addAction:volver];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
        }
    }
    
    
}


-(void)comeBack{
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self setEditing:NO];
}

-(void)showVirtualCard{
    
    NSLog(@"MOstrar Terjeta :/");
    SessionManager *sesion = [SessionManager session];

    ConnectionManager * connectionManager = [[ConnectionManager alloc] init];
    UserProfile *perfil = [sesion getUserProfile];
    
    
    email = perfil.email;
    NSString *resultMessage = [connectionManager getVirtualCardWithEmail:email];
    NSLog(@"El mensaje del WS de tarjeta es: %@",resultMessage);
    
    NSData *data = [resultMessage dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    BOOL success = [[json  valueForKey:@"exito"] boolValue];
    
    if (success){
        
        
        NSString *cardImage64 = [json objectForKey:@"imagen_tarjeta"];
        
        NSArray * stringFiltrado = [cardImage64 componentsSeparatedByString:@","];
        
        //Now data is decoded. You can convert them to UIImage
        
        UIImage *imagenTarjetaVirtual =  [self decodeBase64ToImage:[stringFiltrado lastObject]];
        
        TarjetaVirtual * tarjetaVirtual = [self.storyboard instantiateViewControllerWithIdentifier:@"tarjetaVirtualScreen"];
        tarjetaVirtual.virtualCardImage = imagenTarjetaVirtual;
        [self presentViewController:tarjetaVirtual animated:YES completion:nil];
        
    }else{
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"Error al cargar tarjeta"
                                           message:@"Hubo un error al cargar la tarjeta."
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];
    }
    



}

-(BOOL)algunCampoVacio{
    
    
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedString1 = [_montoTextField.text stringByTrimmingCharactersInSet:charSet];
    NSString *trimmedString2 = [_codigoComercioTextfield.text stringByTrimmingCharactersInSet:charSet];
    if ([trimmedString1 isEqualToString:@""] || [trimmedString2 isEqualToString:@""]) {
        NSLog(@"Campo vacio");
        return YES;
    }else{
        NSLog(@"No es Campo vacio");

        return NO;
    }
    
    
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}
- (IBAction)backButtonPressed:(id)sender {
    [self  dismissViewControllerAnimated:YES completion:nil];

}
@end
