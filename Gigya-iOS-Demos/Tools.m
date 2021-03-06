//
//  Tools
//
//  Mario Alejandro
//  Created by 2016 Mario Alejandro Ramos
//  Copyright (c) 2016 Mario Alejandro Ramos. All rights reserved.
//

#import "Tools.h"

@implementation Tools

/***************************************** NETWORK STATUS  **************************************/
+(BOOL)isNetworkAvailable {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    return networkStatus==NotReachable?NO:YES;
}
/***************************************** NETWORK STATUS  **************************************/

/**************************************** LOCATION SERVICES *************************************/
+(BOOL)isLocationServiceEnabled {
    return [CLLocationManager locationServicesEnabled]?YES:NO;
}

+(BOOL)isLocationServicesEnabledForApp {
    return [CLLocationManager authorizationStatus]!=kCLAuthorizationStatusDenied?YES:NO;
}

+(BOOL)isLocationValid:(CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DIsValid(coordinate)?YES:NO;
}
/**************************************** LOCATION SERVICES *************************************/

/******************************************* DATE & TIME ****************************************/
+(NSString *)getCurrentDateStringWithFormat:(NSString *)formatString {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];
    return [formatter stringFromDate:date];
}

+(NSString *)getDateStringFromTimeStamp:(NSString *)timeStamp andFormatString:(NSString *)formatString {
    NSTimeInterval interval = [timeStamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];
    return [formatter stringFromDate:date];
}

+(NSString *)getFormattedDateString:(NSString *)dateString andFormatString:(NSString *)formatString {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"es_ES"];
    [df setLocale:locale];
    [df setDateFormat:@"EEE MMM dd HH:mm:ss yyyy"];
    NSTimeInterval timeIntveral = [[df dateFromString:dateString] timeIntervalSince1970];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeIntveral];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];
    return [formatter stringFromDate:date];
}
/******************************************* DATE & TIME ****************************************/

/************************************** SORT AND FILTER ARRAY ***********************************/
+(NSArray *)getSortedArray:(NSArray *)sourceArray sortBy:(NSString *)key ascending:(BOOL)ascending {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [sourceArray sortedArrayUsingDescriptors:sortDescriptors];
    return sortedArray;
}

+(NSArray *)getFilteredArray:(NSArray *)sourceArray filterWith:(NSPredicate *)predicate {
    NSArray *filteredArray = [sourceArray filteredArrayUsingPredicate:predicate];
    return filteredArray;
}
/************************************** SORT AND FILTER ARRAY ***********************************/

/******************************************* ANIMATION ******************************************/
+(void)showViewWithTransition:(UIView *)view duration:(NSTimeInterval)duration andAlpha:(CGFloat)alpha{
    [UIView transitionWithView:view duration:duration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{ [view setAlpha:alpha]; } completion:nil];
}
/******************************************* ANIMATION ******************************************/

/************************************ OPEN NATIVE APPLICATIONS **********************************/
+(void)open4sqForVenue:(NSString *)venueId {
    NSURL *url;
    if (venueId) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"foursquare://"]] && venueId) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"foursquare://venues/%@",venueId]];
        }
        else {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://foursquare.com/v/%@",venueId]];
        }
        [[UIApplication sharedApplication] openURL:url];
    }
    else {
        [self showInvalidURLError:@"Error del id de FoursquareVenue"];
    }
}

+(void)open4sqForTip:(NSString *)tipId {
    NSURL *url;
    if (tipId) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"foursquare://"]] && tipId) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"foursquare://tips/%@",tipId]];
        }
        else {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"https://foursquare.com/item/%@",tipId]];
        }
        [[UIApplication sharedApplication] openURL:url];
    }
    else {
        [self showInvalidURLError:@"Error de tip de foursquare inválido"];
    }
}

+(void)startCallWithPhoneNumber:(NSString *)phoneNumber {
    if (phoneNumber) {
        NSString *number = [NSString stringWithFormat:@"tel:%@",[[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"+01234567890"] invertedSet]] componentsJoinedByString:@""]];
        NSURL *url = [NSURL URLWithString:number];
        [[UIApplication sharedApplication] openURL:url];
    }
    else{
        [self showInvalidURLError:@"Número de teléfono inválido"];
    }
}

+(void)openSafariWithURL:(NSString *)url {
    if (url) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    else{
        [self showInvalidURLError:NSLocalizedString(@"InvalidWebURLMessage", @"")];
    }
}


+(void)openGoogleMapsAppWithSourceLocation:(CLLocationCoordinate2D)sourceLocation andDestinationLocation:(CLLocationCoordinate2D)destinationLocation {
    

CGFloat latitud = sourceLocation.latitude;
CGFloat longuitud = sourceLocation.longitude;
    /*
     Directionsmode (driving / transit / walking), mapmode (standard / streetview) and views (satellite / traffic / transit) sets how Google Maps presents its data to you.
     */
NSString *stringMapDirections = [NSString stringWithFormat:@"comgooglemaps://?saddr=&daddr=%1.6f,%1.6f&directionsmode=walking&views=traffic&mapmode=standard",latitud,longuitud];

if ([[UIApplication sharedApplication] canOpenURL:
     
     [NSURL URLWithString:@"comgooglemaps://"]]) {
    
    [[UIApplication sharedApplication] openURL:
     
     [NSURL URLWithString:stringMapDirections]];
    
} else {
    
    NSLog(@"Without Google Maps");
    
    [self openMapsAppWithSourceLocation:sourceLocation andDestinationLocation:destinationLocation];
    }
}

+(void)openMapsAppWithSourceLocation:(CLLocationCoordinate2D)sourceLocation andDestinationLocation:(CLLocationCoordinate2D)destinationLocation {
    NSString *urlString  =[NSString stringWithFormat:@"http://maps.apple.com/?daddr=%@&saddr=%@",[NSString stringWithFormat:@"%f,%f",destinationLocation.latitude,destinationLocation.longitude],[NSString stringWithFormat:@"%f,%f",sourceLocation.latitude, sourceLocation.longitude]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

+(void)openMapsAppWithOneLocation:(CLLocationCoordinate2D)sourceLocation {
    NSString *urlString  =[NSString stringWithFormat:@"http://maps.apple.com/?spn=%@",[NSString stringWithFormat:@"%f,%f",sourceLocation.latitude, sourceLocation.longitude]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

+(void)openMapsAppWithOneLocationAndAddress:(CLLocationCoordinate2D)sourceLocation address:(NSString *)address{
    NSString * formattedAddrees = [address stringByReplacingOccurrencesOfString:@", " withString:@"+"];
    formattedAddrees = [formattedAddrees stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *urlString  =[NSString stringWithFormat:@"http://maps.apple.com/?daddr=%@&saddr=%@",[NSString stringWithFormat:@"%f,%f",sourceLocation.latitude,sourceLocation.longitude],[NSString stringWithFormat:@"%@",formattedAddrees]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}
/************************************ OPEN NATIVE APPLICATIONS **********************************/

/****************************************** ERROR ALERTS ****************************************/
+(void)showNetworkError {
    
    NSString *mensaje = @"Esta aplicación requiere acceso a Internet";
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@""
                          message:mensaje
                          delegate:self
                          cancelButtonTitle: @"OK"
                          otherButtonTitles:nil];
    [alert show];
}

+(void)showLocationServicesErrorByType:(NSString *)messageType {
    NSString *errorMessage;
    if ([messageType isEqualToString:@"locationServicesDisabledError"]) {
        errorMessage = @"Esta aplicación requiere acceso a servicios de localización, que se encuentran desactivados. Habilítelos en ajustes.";
    }
    else if ([messageType isEqualToString:@"locationServicesAuthorizationStatusDenied"]) {
        errorMessage = @"No se ha autorizado a esta app para acceder a localización";
    }
    else if([messageType isEqualToString:@"getDirectionsError"]) {
        errorMessage = @"Error obteniendo la dirección";
    }
    else if([messageType isEqualToString:@"invalidLocationError"]) {
        errorMessage = @"Se ha recibido un localización inválida";
    }
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@""
                          message:errorMessage
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}

+(void)showInvalidURLError:(NSString *)messageString {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@""
                          message:messageString
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}
/****************************************** ERROR ALERTS ****************************************/

+(CGSize)getDynamicTextSizeWithText:(NSString *)text textWidth:(CGFloat)width textFont:(UIFont *)font {
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    CGRect frame = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary context:nil];
    return frame.size;
}

+(void)showInvalidURLError:(NSString *)messageString andAlertTintColor:(UIColor *)alertTintColor {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@""
                          message:messageString
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}

+(void)showAlertMessage:(NSString *)messageString andAlertTintColor:(UIColor *)alertTintColor {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@""
                          message:messageString
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}

+ (NSUInteger) numberOfOccurrencesOfString:(NSString *)needle inString:(NSString *)haystack {
    const char * rawNeedle = [needle UTF8String];
    NSUInteger needleLength = strlen(rawNeedle);
    
    const char * rawHaystack = [haystack UTF8String];
    NSUInteger haystackLength = strlen(rawHaystack);
    
    NSUInteger needleCount = 0;
    NSUInteger needleIndex = 0;
    for (NSUInteger index = 0; index < haystackLength; ++index) {
        const char thisCharacter = rawHaystack[index];
        if (thisCharacter != rawNeedle[needleIndex]) {
            needleIndex = 0; //they don't match; reset the needle index
        }
        
        //resetting the needle might be the beginning of another match
        if (thisCharacter == rawNeedle[needleIndex]) {
            needleIndex++; //char match
            if (needleIndex >= needleLength) {
                needleCount++; //we completed finding the needle
                needleIndex = 0;
            }
        }
    }
    
    return needleCount;
}

+ (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

+ (void)shareText:(NSString *)text andImage:(UIImage *)image andUrl:(NSURL *)url forSelf:(id)yoMismo
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    if (text) {
        [sharingItems addObject:text];
    }
    if (image) {
        [sharingItems addObject:image];
    }
    if (url) {
        [sharingItems addObject:url];
    }
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [yoMismo presentViewController:activityController animated:YES completion:nil];
}

+ (void)showLocalErrorNotificationWithTitle:(NSString*)title andMessage:(NSString*)message{
    
    EHPlainAlert * localNotif = [[EHPlainAlert alloc] initWithTitle:title message:message type:ViewAlertError];
   
    //localNotif.titleFont = [UIFont fontWithName:@"TrebuchetMS" size:15];
    //localNotif.subTitleFont = [UIFont fontWithName:@"TrebuchetMS-Italic" size:12];
    //localNotif.messageColor = [UIColor blackColor];
    
    [localNotif show];
}

+ (void)showLocalSuccessNotificationWithTitle:(NSString*)title andMessage:(NSString*)message{
    
    EHPlainAlert * localNotif = [[EHPlainAlert alloc] initWithTitle:title message:message type:ViewAlertSuccess];
    
    //localNotif.titleFont = [UIFont fontWithName:@"TrebuchetMS" size:15];
    //localNotif.subTitleFont = [UIFont fontWithName:@"TrebuchetMS-Italic" size:12];
    //localNotif.messageColor = [UIColor blackColor];
    
    [localNotif show];
}

+ (void)showLocalInfoNotificationWithTitle:(NSString*)title andMessage:(NSString*)message{
    
    EHPlainAlert * localNotif = [[EHPlainAlert alloc] initWithTitle:title message:message type:ViewAlertInfo];
    
    //localNotif.titleFont = [UIFont fontWithName:@"TrebuchetMS" size:15];
    //localNotif.subTitleFont = [UIFont fontWithName:@"TrebuchetMS-Italic" size:12];
    localNotif.messageColor = [UIColor colorWithRed:0.65 green:0.09 blue:0.09 alpha:1.0];
    
    [localNotif show];
}

+ (void)showLocalPanicNotificationWithTitle:(NSString*)title andMessage:(NSString*)message{
    
    EHPlainAlert * localNotif = [[EHPlainAlert alloc] initWithTitle:title message:message type:ViewAlertError];
    
    //localNotif.titleFont = [UIFont fontWithName:@"TrebuchetMS" size:15];
    //localNotif.subTitleFont = [UIFont fontWithName:@"TrebuchetMS-Italic" size:12];
    //localNotif.messageColor = [UIColor redColor];
    
    [localNotif show];
}

+ (void)showLocalUnknownNotificationWithTitle:(NSString*)title andMessage:(NSString*)message{
    
    EHPlainAlert * localNotif = [[EHPlainAlert alloc] initWithTitle:title message:message type:ViewAlertUnknown];
    
    //localNotif.titleFont = [UIFont fontWithName:@"TrebuchetMS" size:15];
    //localNotif.subTitleFont = [UIFont fontWithName:@"TrebuchetMS-Italic" size:12];
    //localNotif.messageColor = [UIColor redColor];
    
    [localNotif show];
}


/**
 This function allows to resolve if the device model is newer or older than iphone 6

 @return return a bool if is newer or older than iPhone 6
 */
+ (BOOL)isIphone6OrMore{
    
    SessionManager *sesion = [SessionManager session];
    
     if([sesion.storyBoardName isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [sesion.storyBoardName isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
        // NSLog(@"Es menor a iphone 6");
         return false;
     }else{
        // NSLog(@"Es igual o mayor a iphone 6");

         return true;
     }
}

/**
 Calculate HEight for each news cells Collection view

 @param title string with the title of the article
 @param summary string with the summary of the article
 @param isIphone5 boolean true if is iphone 4/5
 @return height size
 */
+ (float)getHeightForNewsListCellWithTitle:(NSString*)title andSummary:(NSString*)summary isIphone5:(BOOL)isIphone5{
    
    float altoLineas = 0;
    NSString *titulo = title;
    //NSLog(@"Titulo: %@",titulo);
    NSString *resumen = summary;
    
    if(isIphone5){
        float characterCountTitulo = [titulo length]+4;
        //NSLog(@"characterCountTitulo: %f",characterCountTitulo);
        float characterCountResumen = [resumen length]+5;
        //NSLog(@"characterCountResumne: %f",characterCountResumen);
        int cantLineasTitulo= ceil(characterCountTitulo/26);
        //NSLog(@"cantLineasTitulo: %d",cantLineasTitulo);
        int cantLineasSummary= floor(characterCountResumen/39);
        //NSLog(@"cantLineasSummary: %d",cantLineasSummary);
        cantLineasTitulo = (cantLineasTitulo==0) ? 1 : cantLineasTitulo;
        //NSLog(@"cantLineasTitulo final: %d",cantLineasTitulo);
        cantLineasSummary = (cantLineasSummary==0) ? 1 : cantLineasSummary;
        //NSLog(@"cantLineasSummary final: %d",cantLineasTitulo);
        cantLineasSummary = (cantLineasSummary>8) ? cantLineasSummary+1 : cantLineasSummary;
        
        //NSLog(@"Summary: %@ cantidad de lineas resumen:%d ",resumen,cantLineasSummary);
         altoLineas = 330+(cantLineasTitulo*26)+(cantLineasSummary*16);
        //NSLog(@"Titulo: %@ cantidad de lineas:%d  y alto asignado: %f",titulo,cantLineasTitulo,altoLineas);
 
    } else{
        float characterCountTitulo = [titulo length]+4;
       // NSLog(@"characterCountTitulo: %f",characterCountTitulo);

        float characterCountResumen = [resumen length]+5;
        //NSLog(@"characterCountResumne: %f",characterCountResumen);
        int cantLineasTitulo= ceil(characterCountTitulo/35);
        //NSLog(@"cantLineasTitulo: %d",cantLineasTitulo);
        int cantLineasSummary= floor(characterCountResumen/39);
        //NSLog(@"cantLineasSummary: %d",cantLineasSummary);
        cantLineasTitulo = (cantLineasTitulo==0) ? 1 : cantLineasTitulo;
        //NSLog(@"cantLineasTitulo final: %d",cantLineasTitulo);
        cantLineasSummary = (cantLineasSummary==0) ? 1 : cantLineasSummary;
        //NSLog(@"cantLineasSummary final: %d",cantLineasTitulo);
        cantLineasSummary = (cantLineasSummary>8) ? cantLineasSummary+1 : cantLineasSummary;
        //NSLog(@"Summary: %@ cantidad de lineas resumen:%d ",resumen,cantLineasSummary);
              if(characterCountTitulo>80 ){
        altoLineas = 340+(cantLineasTitulo*15)+(cantLineasSummary*20);
              }else{
                  altoLineas = 320+(cantLineasTitulo*12)+(cantLineasSummary*15);

              }
        //NSLog(@"Titulo: %@ cantidad de lineas:%d  y alto asignado: %f",titulo,cantLineasTitulo,altoLineas);
    }

    return altoLineas;
}


@end
