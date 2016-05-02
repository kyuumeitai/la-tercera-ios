//
//  Tools
//
//  Mario Alejandro
//  Created by 2016 Mario Alejandro Ramos
//  Copyright (c) 2016 Mario Alejandro Ramos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"
#import <UIKit/UIKit.h>


@interface Tools : NSObject <CLLocationManagerDelegate>

/***************************************** NETWORK STATUS  **************************************/
+(BOOL)isNetworkAvailable;

/**************************************** LOCATION SERVICES *************************************/
+(BOOL)isLocationServiceEnabled;
+(BOOL)isLocationServicesEnabledForApp;
+(BOOL)isLocationValid:(CLLocationCoordinate2D)coordinate;

/******************************************* DATE & TIME ****************************************/
+(NSString *)getCurrentDateStringWithFormat:(NSString *)formatString;
+(NSString *)getDateStringFromTimeStamp:(NSString *)timeStamp andFormatString:(NSString *)formatString;
+(NSString *)getFormattedDateString:(NSString *)dateString andFormatString:(NSString *)formatString;

/************************************** SORT AND FILTER ARRAY ***********************************/
+(NSArray *)getSortedArray:(NSArray *)sourceArray sortBy:(NSString *)key ascending:(BOOL)ascending;
+(NSArray *)getFilteredArray:(NSArray *)sourceArray filterWith:(NSPredicate *)predicate;

/******************************************* ANIMATION ******************************************/
+(void)showViewWithTransition:(UIView *)view duration:(NSTimeInterval)duration andAlpha:(CGFloat)alpha;

/************************************ OPEN NATIVE APPLICATIONS **********************************/
+(void)open4sqForVenue:(NSString *)venueId;
+(void)open4sqForTip:(NSString *)tipId;
+(void)startCallWithPhoneNumber:(NSString *)phoneNumber;
+(void)openSafariWithURL:(NSString *)url;
+(void)openMapsAppWithSourceLocation:(CLLocationCoordinate2D)sourceLocation andDestinationLocation:(CLLocationCoordinate2D)destinationLocation;
+(void)openGoogleMapsAppWithSourceLocation:(CLLocationCoordinate2D)sourceLocation andDestinationLocation:(CLLocationCoordinate2D)destinationLocation;

/****************************************** ERROR ALERTS ****************************************/
+(void)showNetworkError;
+(void)showLocationServicesErrorByType:(NSString *)messageType;

+(CGSize)getDynamicTextSizeWithText:(NSString *)text textWidth:(CGFloat)width textFont:(UIFont *)font;

+(void)showInvalidURLError:(NSString *)messageString andAlertTintColor:(UIColor *)alertTintColor;
+(void)showAlertMessage:(NSString *)messageString andAlertTintColor:(UIColor *)alertTintColor;

+ (NSUInteger) numberOfOccurrencesOfString:(NSString *)needle inString:(NSString *)haystack; 
+ (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;
@end
