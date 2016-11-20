//
//  UsarBeneficioNoLogueado.m
//  La Tercera
//
//  Created by diseno on 21-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "AppDelegate.h"
#import <GigyaSDK/Gigya.h>
#import "UsarBeneficioNoLogueado.h"
#import "ConnectionManager.h"
#import "SessionManager.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Tools.h"

@interface UsarBeneficioNoLogueado ()
@property GSAccount *user;
@end

@implementation UsarBeneficioNoLogueado

BOOL respuestaStatus;
GigyaFormAction formTypeSecond;

- (IBAction)openSuscriptionWeb:(id)sender {
    [Tools openSafariWithURL:@"http://suscripcioneslt.latercera.com/"];
    
    [self dismissViewControllerAnimated:YES
                                           completion:nil];
    
}

- (IBAction)loginWithGigya:(id)sender{
 self.user = nil;
    [self showLoginScreenset];
}

- (IBAction)volver:(id)sender{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void) showLoginScreenset{
    
    NSLog(@"SHOW LOGIN");
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"Mobile-login" forKey:@"screenSet"];
    //[params setObject:@"gigya-complete-registration-screen" forKey:@"startScreen"];
    
    // [params setObject:@"gigya-register-screen" forKey:@"startScreen"];
    [Gigya showPluginDialogOver:self plugin:@"accounts.screenSet" parameters:params completionHandler:^(BOOL closedByUser, NSError *error) {
        if (!error) {
            // Login was successful
            NSLog(@"Screenset exitoso!");
        }
        else {
            // Handle error
            NSLog(@"Error mostrando el screenset");
        }
    }
                       delegate:self
     ];
}

- (void)cancelButtonText:(NSString*)texto{
    
    self.cancelButton.titleLabel.text = texto;
}

- (void)accountDidLogout {
    self.user = nil;
}

- (void)pluginView:(GSPluginView *)pluginView finishedLoadingPluginWithEvent:(NSDictionary *)event {
    NSLog(@"Carga de plugin finalizada con evento finishedLoadingPluginWithEvent: %@", event);
}

- (void)pluginView:(GSPluginView *)pluginView firedEvent:(NSDictionary *)event {
     NSLog(@"FIRED EVENT: %@", event);
    //Variables that will be send on login WS
    NSString *email;
    NSString *verifyState;
    NSString *firstName;
    NSString *lastName;
    NSString *gigyaID;
    NSString *birthdate;
    NSString *gender;
    NSString *deviceId;
    NSString *os = @"iOS";
    //[NSString stringWithFormat:@"iOS %@",[[UIDevice currentDevice] systemVersion]];
    NSString *operation;
    NSUUID *identifierForVendor = [[UIDevice currentDevice] identifierForVendor];
    deviceId = [identifierForVendor UUIDString];
    
    if([[event objectForKey:@"eventName"]isEqualToString:@"afterSubmit"]){
        if([event objectForKey:@"errorCode"] == 0){
            
            NSString * responseString = [event objectForKey:@"response"];
            NSLog(@"*** La respuesta es positiva: %@",responseString);
            
            operation = [self getStringValueForResponseString:responseString andLlave:@"operation"];
            
            if ([[self getStringValueForResponseString:responseString andLlave:@"status"] isEqualToString:@"FAIL"]){
                respuestaStatus = false;
            }else{
                respuestaStatus= true;
            }
            
            NSLog(@"*******++++++ La operacion: %@ ++++++*******",operation);
            
            if([operation isEqualToString:@"/accounts.l"]){
                NSLog(@"---------*** Es un login ***---------");
                formTypeSecond = LOGIN;
                email = [self getStringValueForResponseString:responseString andLlave:@"email\""];
                
                gigyaID = [self getStringValueForResponseString:responseString andLlave:@"UID\""];
                if([email isEqualToString:@"errorCode"]== false){
                    verifyState = [self getStringValueForResponseString:responseString andLlave:@"email"];
                    firstName = [self getStringValueForResponseString:responseString andLlave:@"firstName"];
                    lastName = [self getStringValueForResponseString:responseString andLlave:@"lastName"];
                    gigyaID = [self getStringValueForResponseString:responseString andLlave:@"UID\""];
                    gender = [self getStringValueForResponseString:responseString andLlave:@"gender"];
                    NSString *birthDay = [self getStringValueForResponseString:responseString andLlave:@"birthDay"];
                    NSString *birthMonth = [self getStringValueForResponseString:responseString andLlave:@"birthMonth"];
                    NSString *birthYear = [self getStringValueForResponseString:responseString andLlave:@"birthYear"];
                    
                    if ([birthDay isEqualToString:@""]){
                        birthdate = @"";
                    }else{
                        birthdate = [NSString stringWithFormat:@"%@/%@/%@",birthYear,birthMonth,birthDay];
                    }
                }
                
                NSString *allDataMessage = [NSString stringWithFormat:@"Los datos son: os: %@, deviceID: %@, email: %@, Nombre: %@, Apellidos: %@, Gender: %@, dateBirth: %@",os,deviceId,email,firstName,lastName, gender, birthdate];
                NSLog(@"***::::-----    %@     -----::::***",allDataMessage );
                
                
                
                ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
                NSString *respuesta = [connectionManager sendLoginDataWithEmail:email gigyaId:gigyaID firstName:firstName lastName:lastName gender:gender birthdate:birthdate uid:deviceId andOs:os];
                NSLog(@"***::::-----    %@     -----::::***\r\r\r",respuesta);
                
                //leemos el objeto retornado
                NSLog(@"***************::::-----  Procedemos al leer el perfil:        -----::::**************");
                
                NSData *data = [respuesta dataUsingEncoding:NSUTF8StringEncoding];
                id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                NSString *userEmail = [json objectForKey:@"email"];
                NSString *userProfileType = [json objectForKey:@"profile_type"];
                int notifClub = [[json objectForKey:@"notificaciones_club"] intValue];
                int notifNoticias = [[json objectForKey:@"notificaciones_noticias"] intValue];
                
                //temporary comment
                int userProfileLevel = [[json objectForKey:@"profile_level"] intValue];
                //int userProfileLevel = 0 ;
                NSString *valor= userProfileType;
                
                if ( [valor isEqualToString:@"anonimo"] ){
                    userProfileLevel = 0;
                    NSLog(@"Es anonimo");
                }
                
                if ( [valor isEqualToString:@"fremium"]){
                    userProfileLevel = 1;
                    NSLog(@"Es fremium");
                }
                
                if ( [valor isEqualToString:@"suscriptor"] ){
                    userProfileLevel = 2;
                    NSLog(@"Es suscriptor");
                }
                
                //id status = [json objectForKey:@"status"];
                
                int userDevice = [[json objectForKey:@"device"] intValue];
                //int userDevice =-111;
                NSString *userGigyaId = [json objectForKey:@"gigya_id"];
                BOOL userStatus = false;
                if([json objectForKey:@"status"] == NULL){
                    userStatus = false;
                }else{
                    userStatus = [[json objectForKey:@"status"] boolValue];
                }
                SessionManager *sesion = [SessionManager session];
                UserProfile *perfil = [sesion getUserProfile];
                perfil.email = userEmail;
                perfil.name = firstName;
                perfil.lastName = lastName;
                perfil.profileLevel = userProfileLevel;
                perfil.profileType = userProfileType;
                perfil.status = userStatus;
                perfil.device = userDevice;
                
                if (notifClub == 1){
                    perfil.notificacionesClub = true;
                }else{
                    perfil.notificacionesClub = false;
                }
                
                if (notifNoticias == 1){
                    perfil.notificacionesNoticias = true;
                }else{
                    perfil.notificacionesNoticias = false;
                }
                
                
                perfil.gigyaId = userGigyaId;
                sesion.isLogged = true;
                
                NSString *saveEmail= userEmail;
                NSString *saveGigyaId= userGigyaId;
                [[NSUserDefaults standardUserDefaults] setObject:saveEmail forKey:@"savedEmail"];
                [[NSUserDefaults standardUserDefaults] setObject:saveGigyaId forKey:@"savedGigyaId"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogged"];
                
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                for (NSString* key in json) {
                    id value = [json objectForKey:key];
                    NSLog(@"Clave %@: %@", key,value);
                }
                NSLog(@"***************::::-----  FIN DEL PERFIL      -----::::**************\r\r");
                
                
                NSLog(@"***************::::----- session  : %@  -----::::**************\r\r",[sesion profileDescription]);
                
            }
            
            if([operation isEqualToString:@"/accounts.s"]){
                NSLog(@"---------*** Es un login con red social***---------");
                formTypeSecond = LOGIN;
                email = [self getStringValueForResponseString:responseString andLlave:@"email\""];
                
                gigyaID = [self getStringValueForResponseString:responseString andLlave:@"UID\""];
                
                formTypeSecond = LOGIN;
                
                if([email isEqualToString:@"errorCode"]== false){
                    verifyState = [self getStringValueForResponseString:responseString andLlave:@"email"];
                    firstName = [self getStringValueForResponseString:responseString andLlave:@"firstName"];
                    lastName = [self getStringValueForResponseString:responseString andLlave:@"lastName"];
                    gigyaID = [self getStringValueForResponseString:responseString andLlave:@"UID\""];
                    gender = [self getStringValueForResponseString:responseString andLlave:@"gender"];
                    NSString *birthDay = [self getStringValueForResponseString:responseString andLlave:@"birthDay"];
                    NSString *birthMonth = [self getStringValueForResponseString:responseString andLlave:@"birthMonth"];
                    NSString *birthYear = [self getStringValueForResponseString:responseString andLlave:@"birthYear"];
                    
                    if ([birthDay isEqualToString:@""]){
                        birthdate = @"";
                    }else{
                        birthdate = [NSString stringWithFormat:@"%@/%@/%@",birthYear,birthMonth,birthDay];
                    }
                }
                
                NSString *allDataMessage = [NSString stringWithFormat:@"Los datos son: os: %@, deviceID: %@, email: %@, Nombre: %@, Apellidos: %@, Gender: %@, dateBirth: %@",os,deviceId,email,firstName,lastName, gender, birthdate];
                NSLog(@"***::::-----    %@     -----::::***",allDataMessage );
                
                
                
                ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
                NSString *respuesta = [connectionManager sendLoginDataWithEmail:email gigyaId:gigyaID firstName:firstName lastName:lastName gender:gender birthdate:birthdate uid:deviceId andOs:os];
                NSLog(@"***::::-----    %@     -----::::***\r\r\r",respuesta);
                
                
                //leemos el objeto retornado
                NSLog(@"***************::::-----  Procedemos al leer el perfil:        -----::::**************");
                
                NSData *data = [respuesta dataUsingEncoding:NSUTF8StringEncoding];
                id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                NSString *userEmail = [json objectForKey:@"email"];
                int userProfileLevel = [[json objectForKey:@"profile_level"] intValue];
                NSString *userProfileType = [json objectForKey:@"profile_type"];
                int notifClub = [[json objectForKey:@"notificaciones_club"] intValue];
                int notifNoticias = [[json objectForKey:@"notificaciones_noticias"] intValue];
                BOOL userStatus = false;
                if([json objectForKey:@"status"] == NULL){
                    userStatus = false;
                }else{
                    userStatus = [[json objectForKey:@"status"] boolValue];
                }
                int userDevice = [[json objectForKey:@"device"] intValue];
                //int userDevice =-111;
                NSString *userGigyaId = [json objectForKey:@"gigya_id"];
                
                SessionManager *sesion = [SessionManager session];
                UserProfile *perfil = [sesion getUserProfile];
                perfil.email = userEmail;
                perfil.name = firstName;
                perfil.lastName = lastName;
                perfil.profileLevel = userProfileLevel;
                perfil.profileType = userProfileType;
                perfil.status = userStatus;
                perfil.device = userDevice;
                
                if (notifClub == 1){
                    perfil.notificacionesClub = true;
                }else{
                    perfil.notificacionesClub = true;
                }
                
                if (notifNoticias == 1){
                    perfil.notificacionesNoticias = true;
                }else{
                    perfil.notificacionesNoticias = true;
                }
                
                
                
                perfil.gigyaId = userGigyaId;
                sesion.isLogged = true;
                
                NSString *saveEmail= userEmail;
                NSString *saveGigyaId= userGigyaId;
                [[NSUserDefaults standardUserDefaults] setObject:saveEmail forKey:@"savedEmail"];
                [[NSUserDefaults standardUserDefaults] setObject:saveGigyaId forKey:@"savedGigyaId"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogged"];
                
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                for (NSString* key in json) {
                    id value = [json objectForKey:key];
                    NSLog(@"Clave %@: %@", key,value);
                }
                
                NSLog(@"***************::::-----  FIN DEL PERFIL      -----::::**************\r\r");
                NSLog(@"***************::::-----   Session : %@  -----::::**************\r\r",[sesion profileDescription]);
            }
            
            
            if([operation isEqualToString:@"/accounts.r"]){
                
                NSLog(@"---------*** Es un Registro ***---------");
                formTypeSecond = REGISTRO;
                
                email = [self getStringValueForResponseString:responseString andLlave:@"email\""];
                if([email isEqualToString:@"errorCode"]== false){
                    verifyState = [self getStringValueForResponseString:responseString andLlave:@"email"];
                    firstName = [self getStringValueForResponseString:responseString andLlave:@"firstName"];
                    lastName = [self getStringValueForResponseString:responseString andLlave:@"lastName"];
                    gigyaID = [self getStringValueForResponseString:responseString andLlave:@"UID\""];
                    gender = [self getStringValueForResponseString:responseString andLlave:@"gender"];
                    NSString *birthDay = [self getStringValueForResponseString:responseString andLlave:@"birthDay"];
                    NSString *birthMonth = [self getStringValueForResponseString:responseString andLlave:@"birthMonth"];
                    NSString *birthYear = [self getStringValueForResponseString:responseString andLlave:@"birthYear"];
                    
                    if ([birthDay isEqualToString:@""]){
                        birthdate = @"";
                    }else{
                        birthdate = [NSString stringWithFormat:@"%@/%@/%@",birthYear,birthMonth,birthDay];
                    }
                    
                    NSString *allDataMessage = [NSString stringWithFormat:@"Los datos son: os: %@, deviceID: %@, email: %@, Nombre: %@, Apellidos: %@, Gender: %@, dateBirth: %@",os,deviceId,email,firstName,lastName, gender, birthdate];
                    NSLog(@"***::::-----    %@     -----::::***",allDataMessage );
                    
                    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
                    
                    NSString *respuesta = [connectionManager sendRegisterDataWithEmail:email firstName:firstName lastName:lastName gender:gender birthdate:birthdate uid:deviceId os:os gigyaId:gigyaID];
                    
                    NSLog(@"***::::-----  La respuesta es:   %@     -----::::***\r\r\r",respuesta);
                    
                    //leemos el objeto retornado
                    NSLog(@"***************::::-----  Procedemos al leer el perfil:        -----::::**************");
                    
                    NSData *data = [respuesta dataUsingEncoding:NSUTF8StringEncoding];
                    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    
                    NSString *userEmail = [json objectForKey:@"email"];
                    int userProfileLevel = [[json objectForKey:@"profile_level"] intValue];
                    BOOL userStatus = false;
                    if([json objectForKey:@"status"] == NULL){
                        userStatus = false;
                    }else{
                        userStatus = [[json objectForKey:@"status"] boolValue];
                    }
                    int userDevice = [[json objectForKey:@"device"] intValue];
                    //int userDevice =-111;
                    NSString *userGigyaId = [json objectForKey:@"gigya_id"];
                    
                    SessionManager *sesion = [SessionManager session];
                    UserProfile *perfil = [sesion getUserProfile];
                    perfil.email = userEmail;
                    perfil.name = firstName;
                    perfil.lastName = lastName;
                    perfil.profileLevel = userProfileLevel;
                    perfil.status = userStatus;
                    perfil.device = userDevice;
                    perfil.gigyaId = userGigyaId;
                    sesion.isLogged = true;
                    sesion.userProfile = perfil;
                    
                    NSString *saveEmail= userEmail;
                    NSString *saveGigyaId= userGigyaId;
                    [[NSUserDefaults standardUserDefaults] setObject:saveEmail forKey:@"savedEmail"];
                    [[NSUserDefaults standardUserDefaults] setObject:saveGigyaId forKey:@"savedGigyaId"];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogged"];
                    
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    
                    for (NSString* key in json) {
                        id value = [json objectForKey:key];
                        NSLog(@"Clave %@: %@", key,value);
                    }
                    NSLog(@"***************::::-----  FIN DEL PERFIL      -----::::**************\r\r");
                    NSLog(@"***************::::----- session  : %@  -----::::**************\r\r",[sesion profileDescription]);
                }else{
                    NSLog(@"***::::-----  EMAIL YA REGISTRADO:      -----::::***");
                    
                }
            }
            
            
            //nuevo
            if([operation isEqualToString:@"/accounts.g"]){
                
                NSLog(@"---------*** Es un Registro nuevoo con g ***---------");
                formTypeSecond = REGISTRO;
                
                email = [self getStringValueForResponseString:responseString andLlave:@"email\""];
                if([email isEqualToString:@"errorCode"]== false){
                    verifyState = [self getStringValueForResponseString:responseString andLlave:@"email"];
                    firstName = [self getStringValueForResponseString:responseString andLlave:@"firstName"];
                    lastName = [self getStringValueForResponseString:responseString andLlave:@"lastName"];
                    gigyaID = [self getStringValueForResponseString:responseString andLlave:@"UID\""];
                    gender = [self getStringValueForResponseString:responseString andLlave:@"gender"];
                    NSString *birthDay = [self getStringValueForResponseString:responseString andLlave:@"birthDay"];
                    NSString *birthMonth = [self getStringValueForResponseString:responseString andLlave:@"birthMonth"];
                    NSString *birthYear = [self getStringValueForResponseString:responseString andLlave:@"birthYear"];
                    
                    if ([birthDay isEqualToString:@""]){
                        birthdate = @"";
                    }else{
                        birthdate = [NSString stringWithFormat:@"%@/%@/%@",birthYear,birthMonth,birthDay];
                    }
                    
                    NSString *allDataMessage = [NSString stringWithFormat:@"Los datos son: os: %@, deviceID: %@, email: %@, Nombre: %@, Apellidos: %@, Gender: %@, dateBirth: %@",os,deviceId,email,firstName,lastName, gender, birthdate];
                    NSLog(@"***::::-----    %@     -----::::***",allDataMessage );
                    
                    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
                    
                    
                    NSString *respuesta = [connectionManager sendRegisterDataWithEmail:email firstName:firstName lastName:lastName gender:gender birthdate:birthdate uid:deviceId os:os gigyaId:gigyaID];
                    
                    NSLog(@"***::::-----  La respuesta es:   %@     -----::::***\r\r\r",respuesta);
                    
                    //leemos el objeto retornado
                    NSLog(@"***************::::-----  Procedemos al leer el perfil:        -----::::**************");
                    
                    NSData *data = [respuesta dataUsingEncoding:NSUTF8StringEncoding];
                    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    
                    NSString *userEmail = [json objectForKey:@"email"];
                    int userProfileLevel = [[json objectForKey:@"profile_level"] intValue];
                    BOOL userStatus = false;
                    if([json objectForKey:@"status"] == NULL){
                        userStatus = false;
                    }else{
                        userStatus = [[json objectForKey:@"status"] boolValue];
                    }
                    int userDevice = [[json objectForKey:@"device"] intValue];
                    //int userDevice =-111;
                    NSString *userGigyaId = [json objectForKey:@"gigya_id"];
                    
                    SessionManager *sesion = [SessionManager session];
                    UserProfile *perfil = [sesion getUserProfile];
                    perfil.email = userEmail;
                    perfil.name = firstName;
                    perfil.lastName = lastName;
                    perfil.profileLevel = userProfileLevel;
                    perfil.status = userStatus;
                    perfil.device = userDevice;
                    perfil.gigyaId = userGigyaId;
                    sesion.isLogged = true;
                    sesion.userProfile = perfil;
                    
                    if ([email isEqualToString:@""]){
                        formTypeSecond = INVALIDO;
                        sesion.isLogged = false;
                        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogged"];
                    }else{
                        NSString *saveEmail= userEmail;
                        NSString *saveGigyaId= userGigyaId;
                        [[NSUserDefaults standardUserDefaults] setObject:saveEmail forKey:@"savedEmail"];
                        [[NSUserDefaults standardUserDefaults] setObject:saveGigyaId forKey:@"savedGigyaId"];
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogged"];
                        
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                    }
                    
                    
                    
                    
                    for (NSString* key in json) {
                        id value = [json objectForKey:key];
                        NSLog(@"Clave %@: %@", key,value);
                    }
                    NSLog(@"***************::::-----  FIN DEL PERFIL      -----::::**************\r\r");
                    NSLog(@"***************::::----- session  : %@  -----::::**************\r\r",[sesion profileDescription]);
                }else{
                    NSLog(@"***::::-----  EMAIL YA REGISTRADO:      -----::::***");
                    
                }
                
            }
            //Fin nuevo
            switch (formTypeSecond) {
                case REGISTRO:{
                    SessionManager *sesion = [SessionManager session];
                    UserProfile *perfil = [sesion getUserProfile];
                    NSString *nombre = [NSString stringWithFormat:@"Bienvenido %@ , su sesión ha sido iniciada ",perfil.name];
                    [Tools showLocalSuccessNotificationWithTitle:@"Sesión iniciada" andMessage:nombre];
                    [self dismissViewControllerAnimated:YES
                                             completion:nil];
                }
                    break;
                    
                case LOGIN:{
                    
                    SessionManager *sesion = [SessionManager session];
                    UserProfile *perfil = [sesion getUserProfile];
                    NSString *nombre = [NSString stringWithFormat:@"Bienvenido %@ , su sesión ha sido iniciada ",perfil.name];
                    [Tools showLocalSuccessNotificationWithTitle:@"Sesión iniciada" andMessage:nombre];
                    [self dismissViewControllerAnimated:YES
                                             completion:nil];
                }
                    break;
                    
                case INVALIDO:{
                    //[self performSegueWithIdentifier:@"goToNews" sender:self];
                    //SessionManager *sesion = [SessionManager session];
                    //UserProfile *perfil = [sesion getUserProfile];
                    //NSString *nombre = [NSString stringWithFormat:@"Bienvenido %@ , su registro ha sido exitoso",perfil.name];
                    //[Tools showLocalSuccessNotificationWithTitle:@"Registro exitoso" andMessage:nombre];
                    
                }
                    
                    
            }
        }else{
            NSLog(@"***ERROR **");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Datos de ingreso incorrectos"
                                                            message:@"Revise los datos ingresados y reintente."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
        }
        
        NSLog(@"*** La transacción esta finalizada");
    }
}

- (NSString*)getStringValueForResponseString:(NSString*)responseString andLlave:(NSString*)llave{
    
    NSString * resultado = @"";
    NSRange rango ;
    if ([responseString rangeOfString:llave].location != NSNotFound) {
        
        NSUInteger from= [responseString rangeOfString:llave].location;
        if([llave isEqualToString:@"operation" ]){
            rango  = NSMakeRange(from, 23);
        }else{
            rango = NSMakeRange(from, 50);
            
        }
        NSString *emailPrev = [responseString substringWithRange:rango];
        NSArray *separados= [emailPrev componentsSeparatedByString:@"\""];
        resultado= separados[2];
        NSLog(@"Clave: %@ Valor: %@",llave,resultado);
    }
    return resultado;
}

- (void)pluginView:(GSPluginView *)pluginView didFailWithError:(NSError *)error {
    NSLog(@"Carga de plugin finalizada con evento:: %@", error);
}

- (void)accountDidLogin:(GSAccount *)account {
    NSLog(@"Cuenta logueada con cuenta: %@", account.email);
    self.user = account;
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"Test de sesión de Gigya"
                                       message:@"Has ingresado correctamente"
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
    [alert show];
}


@end
