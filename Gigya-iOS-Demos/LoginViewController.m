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


@interface LoginViewController ()
@property GSAccount *user;
@end

@implementation LoginViewController

GigyaFormAction formType;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSLog(@"Usamos el camino rapido");
    [self setupFakeProfileData];
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
                /*
                firstName = [self getStringValueForResponseString:responseString andLlave:@"firstName"];
                lastName = [self getStringValueForResponseString:responseString andLlave:@"lastName"];
                gender = [self getStringValueForResponseString:responseString andLlave:@"gender"];
                NSString *birthDay = [self getStringValueForResponseString:responseString andLlave:@"birthDay"];
                NSString *birthMonth = [self getStringValueForResponseString:responseString andLlave:@"birthMonth"];
                NSString *birthYear = [self getStringValueForResponseString:responseString andLlave:@"birthYear"];
                
                birthdate = [NSString stringWithFormat:@"%@/%@/%@",birthYear,birthMonth,birthDay];
                
                NSString *allDataMessage = [NSString stringWithFormat:@"Los datos son: os: %@, deviceID: %@, email: %@, Nombre: %@, Apellidos: %@, Gender: %@, dateBirth: %@",os,deviceId,email,firstName,lastName, gender, birthdate];
                NSLog(@"***::::-----    %@     -----::::***",allDataMessage );
                 */
                ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
                NSString *respuesta = [connectionManager sendLoginDataWithEmail:email andGigyaId:gigyaID];
                NSLog(@"***::::-----    %@     -----::::***",respuesta);
                
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
                
                NSLog(@"***::::-----  La respuesta es:   %@     -----::::***",respuesta);
                }else{
                    NSLog(@"***::::-----  EMAIL YA REGISTRADO:      -----::::***");

                }
    
            }
            
            switch (formType) {
                case REGISTRO:
                    [self performSegueWithIdentifier:@"GoToSWReveal" sender:self];
                    break;
                    
                case LOGIN:
                          [self performSegueWithIdentifier:@"goToNews" sender:self];
                    break;
            }
        }
             NSLog(@"*** La respuesta es: negativa");
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

- (void) setupFakeProfileData{
    
    //Creamos el singleton
    SessionManager *sesion = [SessionManager session];
    NSLog(@"Profile - Data original: %@",[sesion description]);
    
    UserProfile * perfilUsuario = [sesion getUserProfile];
    
    perfilUsuario.status = true;
    
    
    NSLog(@"Fakeamos alguna data: %@",[sesion description]);
    
    
}

@end
