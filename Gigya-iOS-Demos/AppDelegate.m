//
//  AppDelegate.m
//  Gigya-iOS-Demos
//
//  Created by Jay Reardon & Giovanni Alvarez on 12/22/14.
//  Copyright (c) 2014 Gigya. All rights reserved.
//

#import "AppDelegate.h"
#import "SingletonManager.h"
#import "InfantilContainerVC.h"
#import "InitialViewController.h"
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
    

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    UIColor *backColor = [UIColor colorWithRed: 1.0 green: 0.1 blue:0.1 alpha: 0.3];
    pageControl.backgroundColor = backColor;
    // grab correct storyboard depending on screen height
    UIStoryboard *storyboard = [self grabStoryboard];
    
    UIViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"initialViewController"];
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];

return YES;
}

- (void)obtenerBeneficios{
    
    //NSString *post = @"idComercio=1";
    NSData *jsonData = [self httpPostRequestWithUrl:@"http://mobile.asicom.cl:8282/cdbltws/servicio/obtenerBeneficios" post:@""];
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

- (void)obtenerSucursales2   {
    
   // NSString *post = @"idComercio=53";
    NSData *jsonData = [self httpPostRequestWithUrl:@"http://api-isibu.appspot.com/near/places" post:@"nil"];
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
    NSLog(@"El input post es: %@",post);
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

- (void)obtenerHistorialDelUsuario:(NSString*)mailUsuario   {
    
    NSString *post = [NSString stringWithFormat:@"mailUsuario=%@",mailUsuario];
    NSLog(@"El input post es: %@",post);
    NSData *jsonData = [self httpPostRequestWithUrl:@"http://mobile.asicom.cl:8282/cdbltws/servicio/obtenerHistorial" post:post];
    NSError *e = nil;
    
    NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&e];
    
    NSLog(@"Historial:%@", responseDict);
}

- (void)registrarParticipacionDelConcurso:(int)idConcurso nombres:(NSString*)nombres apellidos:(NSString*)apellidos
        rutUsuario:(int)rutUsuario fechaNacimiento:(NSString*)fechaNacimiento emailContacto:(NSString*)emailContacto
        fonoContacto:(int)fonoContacto actividad:(NSString*)actividad comuna:(NSString*)comuna
        emailUsuario:(NSString*)emailUsuario{
    
    NSString *post = [NSString stringWithFormat:@"idConcurso=%i&nombres=%@&apellidos=%@&rutUsuario=%i&fechaNacimiento=%@&emailContacto=%@&fonoContacto=%i&actividad=%@&comuna=%@&emailUsuario=%@",idConcurso,nombres,apellidos,rutUsuario,fechaNacimiento,emailContacto,fonoContacto,actividad,comuna,emailUsuario];
    
    NSLog(@"El input post es: %@",post);
    NSData *jsonData = [self httpPostRequestWithUrl:@"http://mobile.asicom.cl:8282/cdbltws/servicio/obtenerHistorial" post:post];
    NSError *e = nil;
    
    NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&e];
    
    NSLog(@"Registrar paticipaciónen concurso:%@", responseDict);
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

- (void)pluginView:(GSPluginView *)pluginView firedEvent:(NSDictionary *)event
{
    NSLog(@"Plugin event from %@ - %@", pluginView.plugin, [event objectForKey:@"eventName"]);
}


- (void)pluginView:(GSPluginView *)pluginView finishedLoadingPluginWithEvent:(NSDictionary *)event
{
    NSLog(@"Finished loading plugin: %@", pluginView.plugin);
}


- (void)pluginView:(GSPluginView *)pluginView didFailWithError:(NSError *)error
{
    NSLog(@"Plugin error: %@", [error localizedDescription]);
}

- (UIStoryboard *)grabStoryboard {
    //Singleton for grab storyboardName properly
    SingletonManager *singleton = [SingletonManager singletonManager];
    
    // determine screen size
    int screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIStoryboard *storyboard;
    
    switch (screenHeight) {
            
            // iPhone 4s
        case 480:
            NSLog(@"iPhone 4");
            storyboard = [UIStoryboard storyboardWithName:@"LaTerceraStoryboard-iPhone4" bundle:nil];
            singleton.storyBoardName = @"LaTerceraStoryboard-iPhone4";
            singleton.width = 320;
            break;
            
            // iPhone 5s
        case 568:
            NSLog(@"iPhone 5");
            storyboard = [UIStoryboard storyboardWithName:@"LaTerceraStoryboard-iPhone5" bundle:nil];
            singleton.storyBoardName = @"LaTerceraStoryboard-iPhone5";
            singleton.width = 320;
            break;
            
            // iPhone 6
        case 667:
            NSLog(@"iPhone 6");
            storyboard = [UIStoryboard storyboardWithName:@"LaTerceraStoryboard-iPhone6" bundle:nil];
            singleton.storyBoardName = @"LaTerceraStoryboard-iPhone6";
            singleton.width = 375;
            
            break;
            
            // iPhone 6 Plus
            
        case 736:
            NSLog(@"iPhone 6 PLus");
            storyboard = [UIStoryboard storyboardWithName:@"LaTerceraStoryboard-iPhone6Plus" bundle:nil];
            singleton.storyBoardName = @"LaTerceraStoryboard-iPhone6Plus";
            break;
            
        default:
            // it's an iPad
            NSLog(@"NONE");
            storyboard = [UIStoryboard storyboardWithName:@"LaTerceraStoryboard-iPhone6" bundle:nil];
            singleton.storyBoardName = @"LaTerceraStoryboard-iPhone6";
            singleton.width = 375;
            
            break;
    }
    
    return storyboard;
}



@end
