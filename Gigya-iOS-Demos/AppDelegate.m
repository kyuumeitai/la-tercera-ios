//
//  AppDelegate.m
//  Gigya-iOS-Demos
//
//  Created by Jay Reardon & Giovanni Alvarez on 12/22/14.
//  Copyright (c) 2014 Gigya. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GigyaSDK/Gigya.h>


@interface AppDelegate () <GSAccountsDelegate>

@end

@implementation AppDelegate

//static NSString * const kClientId = @"224059159380-llqo0j946bbl3s4rqu35kkolpmhpl07h.apps.googleusercontent.com";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Gigya initWithAPIKey:@"3_AG8H3fpJ5N0PHDj7yq7jEA3XNR6fXV0iPnyuxz-sZpYKHmKk9jmjsv_0hlNUFl4q" application:application launchOptions:launchOptions];
    
    [Gigya setAccountsDelegate:self];
    NSData *jsonData = [self httpPostRequestWithUrl:@"http://mobile.asicom.cl:8282/cdbltws/servicio/obtenerCategorias" post:@""];
    NSError *e = nil;
    if (jsonData == nil){
        NSLog(@"sin acceso a la red del Club La Tercera");
    }else{

    NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&e];
    
       //NSLog(@"EL dictionary es:%@", responseDict);
    
    //NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &e];
    
    if (!responseDict) {
        NSLog(@"Error parsing JSON: %@", e);
    } else {
        
        if ([[responseDict objectForKey:@"respuesta"]  isEqual: @"1"]) {
            NSLog(@"La respuesta es uno");
            //NSLog(@"Mensaje: %@", [responseDict objectForKey:@"mensaje"]);
           // NSLog(@"Categorias: %@", [jsonDictionary objectForKey:@"categorias"]);
            
        }
        // NSLog(@"Dict Categorias : %@", [responseDict objectForKey:@"categorias"]);
        NSArray *arrayCategorias = (NSArray*)[responseDict objectForKey:@"categorias"];
        //NSLog(@"Categorias 0: %@", [arrayCategorias objectAtIndex:0]);

        NSLog(@"    ------------ CATEGORIAS ------------");
        for (NSDictionary* objeto in arrayCategorias) {
            NSLog(@"        Categoría: %@. IdCategoria:%@", [objeto objectForKey:@"titulo"], [objeto objectForKey:@"id"]);
            NSLog(@"    --------------------------------------");
            NSArray *arraySubCategorias = (NSArray*)[objeto objectForKey:@"subcategorias"];
            for (NSDictionary* subObjeto in arraySubCategorias) {
                NSLog(@"            Subcategoría: %@. IdCategoria:%@", [subObjeto objectForKey:@"titulo"], [subObjeto objectForKey:@"id"]);
            }
            NSLog(@"    --------------------------------------");
        }
    }
 
   // [self obtenerBeneficios];
   // [self obtenerComercios];
   // [self obtenerSucursales]; //Necesitamos el idComercio
   // [self obtenerListaDeEventos];
   // [self obtenerConcursos];
        
   // [self registrarConsumoDelBeneficio:27 idSucursal:1 mailUsuario:@"mail@mail.cl" monto:2500];// el mail de usuario de ejemplo no funciona
   // [self obtenerTarjetaVirtualDelUsuario:@"mail@mail.cl"];//no acepta el input post
    
        
    }
    
   
    return YES;
}

- (void)obtenerBeneficios{
    
    NSString *post = @"idComercio=53";
    NSData *jsonData = [self httpPostRequestWithUrl:@"http://mobile.asicom.cl:8282/cdbltws/servicio/obtenerBeneficios" post:post];
    NSError *e = nil;
    
    NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&e];
    
    NSLog(@"EL dictionary es:%@", responseDict);
}

- (void)obtenerComercios{
    
    //NSString *post = @"idComercio=53";
    NSData *jsonData = [self httpPostRequestWithUrl:@"http://mobile.asicom.cl:8282/cdbltws/servicio/obtenerComercios" post:@"nil"];
    NSError *e = nil;
    
    NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&e];
    
    NSLog(@"Los comercios son:%@", responseDict);
}

- (void)obtenerSucursales   {
    
    //NSString *post = @"idComercio=53";
    NSData *jsonData = [self httpPostRequestWithUrl:@"http://mobile.asicom.cl:8282/cdbltws/servicio/obtenerSucursales" post:@"nil"];
    NSError *e = nil;
    
    NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&e];
    
    NSLog(@"Las sucursales son:%@", responseDict);
}

- (void)obtenerListaDeEventos   {
    
    //NSString *post = @"idComercio=53";
    NSData *jsonData = [self httpPostRequestWithUrl:@"http://mobile.asicom.cl:8282/cdbltws/servicio/obtenerEventos" post:@"nil"];
    NSError *e = nil;
    
    NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&e];
    
    NSLog(@"Los eventos son:%@", responseDict);
}

- (void)obtenerConcursos  {
    
    //NSString *post = @"idComercio=53";
    NSData *jsonData = [self httpPostRequestWithUrl:@"http://mobile.asicom.cl:8282/cdbltws/servicio/obtenerConcursos" post:@"nil"];
    NSError *e = nil;
    
    NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&e];
    
    NSLog(@"Los concursos son:%@", responseDict);
}

- (void)registrarConsumoDelBeneficio:(int)idBeneficio idSucursal:(int)idSucursal mailUsuario:(NSString*)mailUsuario monto:(int)monto  {
    
    NSString *post = [NSString stringWithFormat:@"idBeneficio=%i&idSucursal=%i&mailUsuario=%@&monto=%i",idBeneficio,idSucursal,mailUsuario,monto];
    NSLog(@"El post es: %@",post);
    NSData *jsonData = [self httpPostRequestWithUrl:@"http://mobile.asicom.cl:8282/cdbltws/servicio/registrarConsumoBeneficio" post:post];
    NSError *e = nil;
    
    NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&e];
    
    NSLog(@"Registro del consumo:%@", responseDict);
}

- (void)obtenerTarjetaVirtualDelUsuario:(NSString*)mailUsuario   {
    
    NSString *post = [NSString stringWithFormat:@"mailUsuario=%@",mailUsuario];
    NSLog(@"El post es: %@",post);
    NSData *jsonData = [self httpPostRequestWithUrl:@"http://mobile.asicom.cl:8282/cdbltws/servicio/obtenerTarjetaVirtual" post:post];
    NSError *e = nil;
    
    NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&e];
    
    NSLog(@"Tarjeta Virtual:%@", responseDict);
}






//-------------------------------------------------------------------


- (void)accountDidLogin:(GSAccount *)account {
    
}

- (void)accountDidLogout {
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"Salir de Gigya"
                                       message:@"Has salido correctamente de Gigya."
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
    [alert show];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    // Logs 'install' and 'app activate' App Events.
    [Gigya handleDidBecomeActive];
    //[FBAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [Gigya handleOpenURL:url application:application sourceApplication:sourceApplication annotation:annotation];
}

- (NSData*)httpPostRequestWithUrl:(NSString *)url post:(NSString *)post
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
    
    //return (NSDictionary *)rc;
    return data;
}


@end
