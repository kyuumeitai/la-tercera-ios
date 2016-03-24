//
//  MasCercanosViewController.m
//  La Tercera
//
//  Created by diseno on 24-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "MasCercanosViewController.h"
#import <CoreLocation/CoreLocation.h>

@implementation MasCercanosViewController
    CLLocationManager *locationManager;
    CLLocation  *userLocation;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self requestLocation];
}

-(void)requestLocation {
    
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    //self.locationManager.distanceFilter  = 1000.0f;
    
    // Check for iOS 8 Vs earlier version like iOS7.Otherwise code will
    // crash on ios 7
    if ([locationManager respondsToSelector:@selector
         (requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    
    if (authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"Autorizado");
        locationManager .desiredAccuracy = kCLLocationAccuracyBestForNavigation;   // 2 kilometers - hope for accuracy within 2 km.
        //_locationManager .distanceFilter  = 100.0f;   // one kilometer - move this far to get another update
        [locationManager startUpdatingLocation];
        
        _mapView.showsUserLocation = YES;
        
        //[self loadData ];
    }else{
        NSLog(@"No Autorizado");
       // [locationManager startUpdatingLocation];
        
        [locationManager requestWhenInUseAuthorization];
        [locationManager startUpdatingLocation];
    }
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
       NSString *longuitud = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        NSString *latitud = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        NSLog(@"La latitud es:%d y la longuitud: %d", latitud,longuitud);

    }
}
@end
