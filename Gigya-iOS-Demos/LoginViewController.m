//
//  ViewController.m
//  Gigya-iOS-Demos
//
//  Created by Jay Reardon & Giovanni Alvarez on 12/22/14.
//  Copyright (c) 2014 Gigya. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GigyaSDK/Gigya.h>
#import "NoticiasHomeViewController.h"
#import "SWRevealViewController.h"
#import "ConnectionManager.h"
#import "SessionManager.h"
#import "Tools.h"
#import "UserProfile.h"


@interface LoginViewController ()
@property GSAccount *user;
@end

@implementation LoginViewController

GigyaFormAction formType;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Estoy en el login View controller");

    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogged"]) {
        
        if ([Tools isNetworkAvailable]){
            NSLog(@"Autologueamos");
            [self autoLogin];
        }else{
            NSLog(@"No hay coneccion");
        }
    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) autoLogin{
    
    //Login code
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    NSString *emilio = [[NSUserDefaults standardUserDefaults] stringForKey:@"savedEmail"];
    NSString *gisyaId = [[NSUserDefaults standardUserDefaults] stringForKey:@"savedGigyaId"];
    
    NSString *respuesta = [connectionManager sendLoginDataWithEmail:emilio andGigyaId:gisyaId ];
    NSLog(@"***::::----- RESPUESTA PRIMARIAAA   %@     -----::::***\r\r\r",respuesta);
    //leemos el objeto retornado
    NSLog(@"***************::::-----  Procedemos al leer el perfil:        -----::::**************");
    
    NSData *data = [respuesta dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSString *firstName = [json objectForKey:@"name"];
    NSString *lastName = [json objectForKey:@"lastname"];
    int userProfileLevel = [[json objectForKey:@"profile_level"] intValue];
    BOOL userStatus = false;
    if([json objectForKey:@"status"] == NULL){
        userStatus = false;
    }else{
        userStatus = [[json objectForKey:@"status"] boolValue];
    }
    int userDevice = [[json objectForKey:@"device"] intValue];
    // int userDevice =-111;
    NSString *userGigyaId = [json objectForKey:@"gigya_id"];
    
    SessionManager *sesion = [SessionManager session];
    UserProfile *perfil = [sesion getUserProfile];
    perfil.email = emilio;
    perfil.name = firstName;
    perfil.lastName = lastName;
    perfil.profileLevel = userProfileLevel;
    perfil.status = userStatus;
    perfil.device = userDevice;
    perfil.gigyaId = userGigyaId;
    sesion.isLogged = true;
    sesion.userProfile = perfil;
    sesion.isLogged = true;
    
    for (NSString* key in json) {
        id value = [json objectForKey:key];
        NSLog(@"Clave %@: %@", key,value);
    }
    NSLog(@"***************::::-----  FIN DEL PERFIL      -----::::**************\r\r");
    NSLog(@"***************::::----- session  : %@  -----::::**************\r\r",[sesion profileDescription]);
    // Do any additional setup after loading the view, typically from a nib.
    
    [self performSegueWithIdentifier:@"goToNews" sender:self];
    
}

- (IBAction)logoutButtonAction:(id)sender {
    [Gigya logoutWithCompletionHandler:^(GSResponse *response, NSError *error) {
        self.user = nil;
        if (error) {
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:@"Salir de Gigya"
                                         message:[@"Hubo un problema saliendo de Gigya. Codigo error " stringByAppendingFormat:@"%d",response.errorCode]
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            [alert show];
        }
    }];

}


- (IBAction)mobileSessionCheckButtonAction:(id)sender {
    // If there is no Gigya session
    if (![Gigya session]) {
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"Gigya Session Test"
                                     message:@"You are not logged in"
                                     delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        [alert show];
    } else {
        GSRequest *request = [GSRequest requestForMethod:@"accounts.getAccountInfo"];
        [request sendWithResponseHandler:^(GSResponse *response, NSError *error) {
            if (!error) {
                self.user = (GSAccount *)response;
                UIAlertView *alert;
                alert = [[UIAlertView alloc] initWithTitle:@"Gigya Session Test"
                                                   message:[@"User is logged in\n" stringByAppendingFormat: @"%@ %@ (%@)", response[@"profile"][@"firstName"], response[@"profile"][@"lastName"], response[@"profile"][@"email"]]
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
                [alert show];
            }
            else {
                NSLog(@"Got error on getAccountInfo: %@", error);
            }
        }];
    }
}


- (IBAction)showScreenSet:(id)sender {

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"Mobile-login" forKey:@"screenSet"];
  //[params setObject:@"gigya-complete-registration-screen" forKey:@"startScreen"];
    
    [params setObject:@"gigya-register-screen" forKey:@"startScreen"];
    
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



- (IBAction)loginButtonClicked:(id)sender {
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


- (IBAction)nativeLoginButtonAction:(id)sender {
    
    if (![Gigya session]){
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[NSNumber numberWithInt:FBSDKLoginBehaviorNative] forKey:@"facebookLoginBehavior"];
        [Gigya showLoginProvidersDialogOver:self
                                  providers:@[@"facebook", @"twitter", @"googleplus", @"linkedin"]
                                 parameters:params
                          completionHandler:^(GSUser *user, NSError *error) {
                              if (error && error.code != 200001) {
                                  UIAlertView *alert;
                                  // Handle error
                                  alert = [[UIAlertView alloc] initWithTitle:@"Gigya Native Mobile Login"
                                                                     message:[@"There was a problem logging in with Gigya. Gigya returned error code " stringByAppendingFormat:@"%ld", (long)error.code]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil
                                           ];
                                  [alert show];
                              }
                              else {
                                  // Anything?
                              }
                          }
         ];
    } else {
        UIAlertView *alert;
        if (!self.user) {
            // Make Request to get User if it's empty.
            // Step 1 - Create the request and set the parameters
            GSRequest *request = [GSRequest requestForMethod:@"accounts.getAccountInfo"];
            [request sendWithResponseHandler:^(GSResponse *response, NSError *error) {
                if (!error) {
                    self.user = (GSAccount *)response;
                }
                else {
                    NSLog(@"Got error on getAccountInfo: %@", error);
                }
            }];
        }
        
        alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                           message:@"You are already logged in!"
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];
    }
}


- (void)accountDidLogout {
    self.user = nil;
}
- (IBAction)caminoRapido:(id)sender {
    NSLog(@"Usamos el camino rapido anonimo");
    [self setupFakeProfileData:3 andActiveState:true];
}

- (IBAction)caminoRapidoRegistrado:(id)sender {
    NSLog(@"Usamos el camino rapido para un registrado");
   // NSString *respuesta = [connectionManager sendLoginDataWithEmail:email andGigyaId:gigyaID];
    //NSLog(@"***::::-----    %@     -----::::***\r\r\r",respuesta);

    [self setupFakeProfileData:2 andActiveState:true];
}

- (IBAction)caminoRapidoSuscrito:(id)sender {
    NSLog(@"Usamos el camino rapido suscrito");
    [self setupFakeProfileData:1 andActiveState:true];
}

- (IBAction)caminoRapidoInactivo:(id)sender {
    NSLog(@"Usamos el camino rapido anonimo");
    [self setupFakeProfileData:3 andActiveState:false];
}

- (IBAction)caminoRapidoRegistradoInactivo:(id)sender {
    NSLog(@"Usamos el camino rapido para un registrado");
    [self setupFakeProfileData:2 andActiveState:false];
}

- (IBAction)caminoRapidoSuscritoInactivo:(id)sender {
    NSLog(@"Usamos el camino rapido suscrito");
    [self setupFakeProfileData:1 andActiveState:false];
}

- (void)pluginView:(GSPluginView *)pluginView finishedLoadingPluginWithEvent:(NSDictionary *)event {
    NSLog(@"Carga de plugin finalizada con evento finishedLoadingPluginWithEvent: %@", event);
}

- (void)pluginView:(GSPluginView *)pluginView firedEvent:(NSDictionary *)event {
    
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
            NSLog(@"*******++++++ La operacion: %@ ++++++*******",operation);

            if([operation isEqualToString:@"/accounts.l"]){
              NSLog(@"---------*** Es un login ***---------");
                formType = LOGIN;
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
                formType = LOGIN;
                email = [self getStringValueForResponseString:responseString andLlave:@"email\""];
                
                gigyaID = [self getStringValueForResponseString:responseString andLlave:@"UID\""];

                formType = LOGIN;
             
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
                formType = REGISTRO;

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
                }else{
                    NSLog(@"***::::-----  EMAIL YA REGISTRADO:      -----::::***");

                }
                
    
            }
            
            
            //nuevo
            if([operation isEqualToString:@"/accounts.g"]){
                
                NSLog(@"---------*** Es un Registro ***---------");
                formType = REGISTRO;
                
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
                }else{
                    NSLog(@"***::::-----  EMAIL YA REGISTRADO:      -----::::***");
                    
                }
                
                
            }
            //Fin nuevo
            switch (formType) {
                case REGISTRO:
                           [self performSegueWithIdentifier:@"goToNews" sender:self];
                    //[self performSegueWithIdentifier:@"GoToSWReveal" sender:self];
                    break;
                    
                case LOGIN:
                    [self performSegueWithIdentifier:@"goToNews" sender:self];
                    break;
               }
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

- (void) setupFakeProfileData:(int)profileCode andActiveState:(BOOL)state{
    
    //Creamos el singleton
    SessionManager *sesion = [SessionManager session];
    NSLog(@"Profile - Data original: %@",[sesion profileDescription]);
    
    UserProfile * perfilUsuario = [sesion getUserProfile];
    
    perfilUsuario.status = state;
    perfilUsuario.profileLevel = profileCode;
    
    NSLog(@"Fakeamos alguna data: %@",[sesion profileDescription]);
    
}

@end
