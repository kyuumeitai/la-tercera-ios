//
//  ViewController.m
//  Gigya-iOS-Demos
//
//  Created by Jay Reardon & Giovanni Alvarez on 12/22/14.
//  Copyright (c) 2014 Gigya. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GigyaSDK/Gigya.h>

@interface ViewController ()
@property GSAccount *user;
@end

@implementation ViewController 


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSDictionary *diccionario = [self httpPostRequestWithUrl:@"http://mobile.asicom.cl:8282/cdbltws/servicio/obtenerCategorias" post:@"curl -X POST -d """];
    NSLog(@"EL diccionario es:%@",diccionario );

    for(NSString *key in [diccionario allKeys]) {
        NSLog(@"%@",[diccionario objectForKey:key]);
    }

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

- (void)pluginView:(GSPluginView *)pluginView finishedLoadingPluginWithEvent:(NSDictionary *)event {
    NSLog(@"Carga de plugin finalizada con evento: %@", event);
}

- (void)pluginView:(GSPluginView *)pluginView firedEvent:(NSDictionary *)event {
    NSLog(@"Carga de plugin finalizada con evento:: %@", event);
}

- (void)pluginView:(GSPluginView *)pluginView didFailWithError:(NSError *)error {
    NSLog(@"Carga de plugin finalizada con evento:: %@", error);
}

- (void)accountDidLogin:(GSAccount *)account {
    self.user = account;
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"Test de sesión de Gigya"
                                       message:@"Has ingresado correctamente"
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
    [alert show];
}

/**
 *  Do an HTTP POST request and return the results
 *
 *  @param  NSString *  url     the URL
 *  @param  NSString *  post    the POST data
 *
 *  @return NSDictionary *      a dictionary containing the response, error, and data
 */

- (NSDictionary *)httpPostRequestWithUrl:(NSString *)url post:(NSString *)post
{
    NSData *postData     = [post dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%d", (int)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:30]; // set timeout for 30 seconds
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSHTTPURLResponse   *response = nil;
    NSError         *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSMutableDictionary *rc = [[NSMutableDictionary alloc] init];
    if ( response )
        [rc setObject:response forKey:@"response"];
    if ( error )
        [rc setObject:error forKey:@"error"];
    if ( data )
        [rc setObject:data forKey:@"data"];
    
    return (NSDictionary *)rc;
}

- (void)accountDidLogout {
    self.user = nil;
}


@end
