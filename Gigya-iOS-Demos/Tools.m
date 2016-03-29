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

@end
