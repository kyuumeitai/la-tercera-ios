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

@interface LoginViewController ()
@property GSAccount *user;
@end

@implementation LoginViewController


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


- (IBAction)showScreenSet:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"Mobile-login" forKey:@"screenSet"];
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

- (void)pluginView:(GSPluginView *)pluginView finishedLoadingPluginWithEvent:(NSDictionary *)event {
    NSLog(@"Carga de plugin finalizada con evento finishedLoadingPluginWithEvent: %@", event);
}

- (void)pluginView:(GSPluginView *)pluginView firedEvent:(NSDictionary *)event {
    NSString *email;
    if([[event objectForKey:@"eventName"]isEqualToString:@"afterSubmit"]){
        if([event objectForKey:@"errorCode"] == 0){

           // NSLog(@"*** La respuesta es positiva: %@",[event objectForKey:@"response"]);
            NSString * responseString = [event objectForKey:@"response"];
            NSString *word = @"email";
            if ([responseString rangeOfString:word].location != NSNotFound) {
                //NSLog(@"Yes it does contain that word at: %lu",(unsigned long)[responseString rangeOfString:word].location);
                NSUInteger from= [responseString rangeOfString:word].location;
                NSRange rango = NSMakeRange(from, 50);
                NSString *emailPrev = [responseString substringWithRange:rango];
                NSArray *separados= [emailPrev componentsSeparatedByString:@"\""];
                email= separados[2];
                 NSLog(@"Email del usuario: %@",email);
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login exitoso"
                                               message:email
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
            [alert show];
            
     [self performSegueWithIdentifier:@"GoToSWReveal" sender:self];
            
        }
             NSLog(@"*** La respuesta es: negativa");
        
    }
   
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
